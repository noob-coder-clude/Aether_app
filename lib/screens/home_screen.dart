import 'dart:async';
import 'package:flutter/material.dart';
import '../models/aether_config.dart';
import '../l10n/app_translations.dart';
import '../services/vpn_service.dart';
import '../services/socks_tester.dart';
import '../services/update_service.dart';
import '../widgets/logo_header.dart';
import '../widgets/connect_button.dart';
import '../widgets/lang_switcher.dart';
import '../widgets/ping_badge.dart';

class HomeScreen extends StatefulWidget {
  final AetherConfig config;
  final VpnServiceController vpnController;
  final String currentLocale;
  final ValueChanged<String> onLocaleChanged;

  const HomeScreen({
    super.key,
    required this.config,
    required this.vpnController,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ConnectionStatus _status = ConnectionStatus.disconnected;
  int? _pingMs;
  Timer? _pingTimer;
  ReleaseInfo? _publisherUpdate;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    _checkForPublisherUpdate();
  }

  Future<void> _checkStatus() async {
    final running = await widget.vpnController.isCoreRunning();
    if (running && _status != ConnectionStatus.connected) {
      setState(() {
        _status = ConnectionStatus.connected;
      });
      _startPingLoop();
    }
  }

  Future<void> _checkForPublisherUpdate() async {
    final release = await UpdateService.fetchLatestPublisherRelease();
    if (release != null && release.tagName != 'v1.2.0') {
      setState(() {
        _publisherUpdate = release;
      });
    }
  }

  void _startPingLoop() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 4), (_) async {
      if (_status == ConnectionStatus.connected) {
        final ping = await SocksTester.measurePing();
        if (mounted) {
          setState(() {
            _pingMs = ping;
          });
        }
      }
    });
  }

  void _toggleConnection() async {
    if (_status == ConnectionStatus.connected) {
      setState(() {
        _status = ConnectionStatus.disconnected;
        _pingMs = null;
      });
      _pingTimer?.cancel();
      await widget.vpnController.stopTunnel();
    } else {
      if (widget.config.isSystemVpn) {
        final prepared = await widget.vpnController.prepareVpn();
        if (!prepared) return;
      }

      setState(() {
        _status = ConnectionStatus.connecting;
      });

      final success = await widget.vpnController.startTunnel(widget.config);
      if (mounted) {
        setState(() {
          _status = success ? ConnectionStatus.connected : ConnectionStatus.error;
        });
        if (success) {
          _startPingLoop();
        }
      }
    }
  }

  @override
  void dispose() {
    _pingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = (String key) => AppTranslations.tr(key, widget.currentLocale);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Top Navigation Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Text(
                        tr('app_title'),
                        style: const TextStyle(
                          color: Color(0xFF00E5FF),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        tr('subtitle'),
                        style: const TextStyle(
                          color: Color(0xFF8B949E),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  LangSwitcher(
                    currentLocale: widget.currentLocale,
                    onLocaleChanged: widget.onLocaleChanged,
                  ),
                ],
              ),

              const Spacer(),

              // Publisher Update Banner
              if (_publisherUpdate != null) ...[
                GestureDetector(
                  onTap: () {
                    DefaultTabController.of(context).animateTo(3); // Navigate to update screen
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C4DFF), Color(0xFFFF007F)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF007F).withOpacity(0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.system_update_rounded, color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAlignment.start,
                            children: [
                              Text(
                                tr('core_update_available'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${_publisherUpdate!.tagName} - ${tr('update_now')}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],

              // Central Brand Logo & Glowing Connect Switch
              const LogoHeader(size: 110),
              const SizedBox(height: 32),

              ConnectButton(
                status: _status,
                onTap: _toggleConnection,
              ),

              const SizedBox(height: 24),

              // Status Text & Ping Badge
              Text(
                _status == ConnectionStatus.connected
                    ? tr('status_connected')
                    : _status == ConnectionStatus.connecting
                        ? tr('status_connecting')
                        : _status == ConnectionStatus.error
                            ? tr('status_error')
                            : tr('status_disconnected'),
                style: TextStyle(
                  color: _status == ConnectionStatus.connected
                      ? const Color(0xFF00E676)
                      : _status == ConnectionStatus.connecting
                          ? const Color(0xFFFFD600)
                          : const Color(0xFF8B949E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              PingBadge(pingMs: _pingMs, locale: widget.currentLocale),

              const Spacer(),

              // Quick Specs Overview Cards
              Card(
                color: const Color(0xFF141A24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSpecItem(
                        Icons.shield_outlined,
                        tr('protocol'),
                        widget.config.protocol.toUpperCase(),
                      ),
                      Container(width: 1, height: 28, color: const Color(0xFF2D3748)),
                      _buildSpecItem(
                        Icons.speed_rounded,
                        tr('scan_mode'),
                        widget.config.scanMode,
                      ),
                      Container(width: 1, height: 28, color: const Color(0xFF2D3748)),
                      _buildSpecItem(
                        Icons.security_rounded,
                        tr('noise_profile'),
                        widget.config.noiseProfile,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF00E5FF)),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
