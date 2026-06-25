import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFE91E8C);
  static const Color primaryDark = Color(0xFFC2185B);
  static const Color primaryLight = Color(0xFFFF6B9D);
  static const Color background = Color(0xFF0D0D1A);
  static const Color surface = Color(0xFF161628);
  static const Color surfaceLight = Color(0xFF1E1E35);
  static const Color cardBorder = Color(0xFF2A2A4A);
  static const Color textPrimary = Color(0xFFF5F5FF);
  static const Color textSecondary = Color(0xFF9090B8);
  static const Color textMuted = Color(0xFF5A5A80);
  static const Color accent = Color(0xFFFFB3CC);
  static const Color gold = Color(0xFFFFD700);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryLight,
        surface: surface,
        onPrimary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: primaryLight),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E1E3A),
        contentTextStyle: GoogleFonts.lato(color: textPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
