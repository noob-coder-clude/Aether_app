import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/vpn_service.dart';
import '../l10n/app_translations.dart';

class LogsScreen extends StatefulWidget {
  final VpnServiceController vpnController;
  final String locale;

  const LogsScreen({
    super.key,
    required this.vpnController,
    required this.locale,
  });

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<String> _localLogs = [];

  @override
  void initState() {
    super.initState();
    _localLogs.addAll(widget.vpnController.logs);
    widget.vpnController.listenLogs((line) {
      if (mounted) {
        setState(() {
          _localLogs.add(line);
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = (String key) => AppTranslations.tr(key, widget.locale);

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('logs')),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_rounded),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _localLogs.join('\n')));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logs copied to clipboard')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () {
              setState(() {
                _localLogs.clear();
              });
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF070A0F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2D3748)),
        ),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _localLogs.length,
          itemBuilder: (context, index) {
            final line = _localLogs[index];
            final isError = line.contains('Error') || line.contains('FAILED');
            final isSuccess = line.contains('Connected') || line.contains('Pass');

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: SelectableText(
                line,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: isError
                      ? const Color(0xFFFF1744)
                      : isSuccess
                          ? const Color(0xFF00E676)
                          : const Color(0xFF00E5FF),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
