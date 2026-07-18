import 'package:flutter/material.dart';
import '../models/aether_config.dart';
import '../l10n/app_translations.dart';

class SettingsScreen extends StatefulWidget {
  final AetherConfig config;
  final String locale;
  final VoidCallback onConfigChanged;

  const SettingsScreen({
    super.key,
    required this.config,
    required this.locale,
    required this.onConfigChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final tr = (String key) => AppTranslations.tr(key, widget.locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Section 1: Protocol Selection
          _buildSectionHeader(tr('protocol'), Icons.vpn_lock_rounded),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(tr('protocol_masque')),
                  subtitle: const Text('HTTP/3 (QUIC) & HTTP/2 (TLS)'),
                  value: 'masque',
                  groupValue: widget.config.protocol,
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (v) {
                    setState(() => widget.config.protocol = v!);
                    widget.onConfigChanged();
                  },
                ),
                RadioListTile<String>(
                  title: Text(tr('protocol_wg')),
                  subtitle: const Text('Lightweight WireGuard transport'),
                  value: 'wg',
                  groupValue: widget.config.protocol,
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (v) {
                    setState(() => widget.config.protocol = v!);
                    widget.onConfigChanged();
                  },
                ),
                RadioListTile<String>(
                  title: Text(tr('protocol_gool')),
                  subtitle: const Text('Nested WireGuard double tunnel'),
                  value: 'gool',
                  groupValue: widget.config.protocol,
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (v) {
                    setState(() => widget.config.protocol = v!);
                    widget.onConfigChanged();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section 2: MASQUE Advanced Options
          if (widget.config.protocol == 'masque') ...[
            _buildSectionHeader(tr('masque_options'), Icons.tune_rounded),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(tr('masque_h2')),
                    value: widget.config.useHttp2,
                    activeColor: const Color(0xFF00E5FF),
                    onChanged: (v) {
                      setState(() => widget.config.useHttp2 = v);
                      widget.onConfigChanged();
                    },
                  ),
                  if (widget.config.useHttp2) ...[
                    const Divider(height: 1),
                    SwitchListTile(
                      title: Text(tr('masque_h2_fragment')),
                      value: widget.config.enableFragment,
                      activeColor: const Color(0xFF00E5FF),
                      onChanged: (v) {
                        setState(() => widget.config.enableFragment = v);
                        widget.onConfigChanged();
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Section 3: Stealth Noise Profile
          _buildSectionHeader(tr('noise_profile'), Icons.remove_red_eye_outlined),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.config.noiseProfile,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E2638),
                  items: [
                    DropdownMenuItem(value: 'firewall', child: Text(tr('noise_firewall'))),
                    DropdownMenuItem(value: 'gfw', child: Text(tr('noise_gfw'))),
                    DropdownMenuItem(value: 'balanced', child: Text(tr('noise_balanced'))),
                    DropdownMenuItem(value: 'aggressive', child: Text(tr('noise_aggressive'))),
                    DropdownMenuItem(value: 'light', child: Text(tr('noise_light'))),
                    DropdownMenuItem(value: 'off', child: Text(tr('noise_off'))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => widget.config.noiseProfile = v);
                      widget.onConfigChanged();
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Section 4: Scan Speed Mode
          _buildSectionHeader(tr('scan_mode'), Icons.radar_rounded),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: widget.config.scanMode,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E2638),
                  items: [
                    DropdownMenuItem(value: 'turbo', child: Text(tr('scan_turbo'))),
                    DropdownMenuItem(value: 'balanced', child: Text(tr('scan_balanced'))),
                    DropdownMenuItem(value: 'thorough', child: Text(tr('scan_thorough'))),
                    DropdownMenuItem(value: 'stealth', child: Text(tr('scan_stealth'))),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() => widget.config.scanMode = v);
                      widget.onConfigChanged();
                    }
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Section 5: Reconnect & Mode Options
          _buildSectionHeader('General Preferences', Icons.display_settings_rounded),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(tr('quick_reconnect')),
                  subtitle: Text(tr('quick_reconnect_desc')),
                  value: widget.config.quickReconnect,
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (v) {
                    setState(() => widget.config.quickReconnect = v);
                    widget.onConfigChanged();
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: Text(tr('system_vpn_mode')),
                  subtitle: Text(tr('system_vpn_desc')),
                  value: widget.config.isSystemVpn,
                  activeColor: const Color(0xFF00E5FF),
                  onChanged: (v) {
                    setState(() => widget.config.isSystemVpn = v);
                    widget.onConfigChanged();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF00E5FF)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF00E5FF),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
