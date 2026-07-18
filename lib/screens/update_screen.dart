import 'package:flutter/material.dart';
import '../services/update_service.dart';
import '../services/vpn_service.dart';
import '../l10n/app_translations.dart';

class UpdateScreen extends StatefulWidget {
  final VpnServiceController vpnController;
  final String locale;

  const UpdateScreen({
    super.key,
    required this.vpnController,
    required this.locale,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  ReleaseInfo? _publisherRelease;
  bool _isChecking = true;
  bool _isDownloading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkUpdates();
  }

  Future<void> _checkUpdates() async {
    setState(() => _isChecking = true);
    final release = await UpdateService.fetchLatestPublisherRelease();
    if (mounted) {
      setState(() {
        _publisherRelease = release;
        _isChecking = false;
      });
    }
  }

  Future<void> _performCoreUpdate() async {
    if (_publisherRelease == null) return;

    setState(() {
      _isDownloading = true;
      _statusMessage = AppTranslations.tr('updating', widget.locale);
    });

    final abi = await widget.vpnController.getAbi();
    final downloadUrl = UpdateService.getMatchingBinaryUrl(_publisherRelease!, abi);

    if (downloadUrl != null) {
      final bytes = await UpdateService.downloadBinary(downloadUrl);
      if (bytes != null) {
        final success = await widget.vpnController.updateBinaryBytes(bytes);
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _statusMessage = success
                ? AppTranslations.tr('update_success', widget.locale)
                : AppTranslations.tr('update_failed', widget.locale);
          });
          return;
        }
      }
    }

    if (mounted) {
      setState(() {
        _isDownloading = false;
        _statusMessage = AppTranslations.tr('update_failed', widget.locale);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = (String key) => AppTranslations.tr(key, widget.locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('updates')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.security_update_good_rounded, size: 40, color: Color(0xFF00E5FF)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAlignment.start,
                        children: [
                          const Text(
                            'Aether Engine Updater',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            '${tr('current_version')}: v1.2.0',
                            style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Color(0xFF00E5FF)),
                      onPressed: _checkUpdates,
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_isChecking)
              const Center(child: CircularProgressIndicator(color: Color(0xFF00E5FF)))
            else if (_publisherRelease != null) ...[
              Card(
                color: const Color(0xFF141A24),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${tr('latest_version')}: ${_publisherRelease!.tagName}',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00E5FF)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7C4DFF).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('GitHub Release', style: TextStyle(fontSize: 10, color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _publisherRelease!.body.isNotEmpty
                            ? _publisherRelease!.body
                            : 'Official release from CluvexStudio/Aether repo.',
                        style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isDownloading ? null : _performCoreUpdate,
                          icon: _isDownloading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                )
                              : const Icon(Icons.download_rounded),
                          label: Text(
                            _isDownloading ? _statusMessage : tr('update_now'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Engine up to date with CluvexStudio/Aether publisher repository.',
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ),
              ),

            if (_statusMessage.isNotEmpty && !_isDownloading) ...[
              const SizedBox(height: 16),
              Text(
                _statusMessage,
                style: const TextStyle(color: Color(0xFF00E676), fontWeight: FontWeight.bold),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
