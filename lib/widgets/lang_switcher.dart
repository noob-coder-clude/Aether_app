import 'package:flutter/material.dart';

class LangSwitcher extends StatelessWidget {
  final String currentLocale;
  final ValueChanged<String> onLocaleChanged;

  const LangSwitcher({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF141A24),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF2D3748)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChip('FA', 'فارسی', currentLocale == 'fa'),
          const SizedBox(width: 4),
          _buildChip('EN', 'English', currentLocale == 'en'),
        ],
      ),
    );
  }

  Widget _buildChip(String code, String label, bool isSelected) {
    return GestureDetector(
      onTap: () => onLocaleChanged(code.toLowerCase()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00E5FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF0B0E14) : const Color(0xFF8B949E),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
