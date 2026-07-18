import 'package:flutter/material.dart';

class AppTheme {
  // Brand Dark Palette (Aether Obsidian Cyber)
  static const Color backgroundDark = Color(0xFF0B0E14);
  static const Color surfaceDark = Color(0xFF141A24);
  static const Color cardDark = Color(0xFF1E2638);
  
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color primaryPurple = Color(0xFF7C4DFF);
  static const Color primaryMagenta = Color(0xFFFF007F);
  
  static const Color textBright = Color(0xFFF0F6FC);
  static const Color textMuted = Color(0xFF8B949E);
  static const Color statusSuccess = Color(0xFF00E676);
  static const Color statusWarning = Color(0xFFFFD600);
  static const Color statusDanger = Color(0xFFFF1744);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryCyan,
      colorScheme: const ColorScheme.dark(
        primary: primaryCyan,
        secondary: primaryPurple,
        tertiary: primaryMagenta,
        surface: surfaceDark,
        background: backgroundDark,
        error: statusDanger,
      ),
      cardTheme: CardTheme(
        color: cardDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2D3748), width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryCyan),
        titleTextStyle: TextStyle(
          color: textBright,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryCyan,
          foregroundColor: backgroundDark,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF4F6FB),
      primaryColor: primaryPurple,
      colorScheme: const ColorScheme.light(
        primary: primaryPurple,
        secondary: primaryCyan,
        tertiary: primaryMagenta,
        surface: Colors.white,
        background: Color(0xFFF4F6FB),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
    );
  }
}
