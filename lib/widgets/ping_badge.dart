import 'package:flutter/material.dart';
import '../l10n/app_translations.dart';

class PingBadge extends StatelessWidget {
  final int? pingMs;
  final String locale;

  const PingBadge({super.key, required this.pingMs, required this.locale});

  @override
  Widget build(BuildContext context) {
    final hasPing = pingMs != null;
    final color = hasPing
        ? (pingMs! < 180
            ? const Color(0xFF00E676)
            : pingMs! < 350
                ? const Color(0xFFFFD600)
                : const Color(0xFFFF1744))
        : const Color(0xFF8B949E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF141A24),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt_rounded, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            hasPing
                ? '${AppTranslations.tr('ping', locale)}: $pingMs ${AppTranslations.tr('ping_ms', locale)}'
                : AppTranslations.tr('checking_ping', locale),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
