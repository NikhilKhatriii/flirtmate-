import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // Professional Enterprise Design Tokens
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFF0F172A); // Deep Navy
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
  static const Color cardBorder = Color(0xFF475569);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Accent Colors
  static const Color accentBlue = Color(0xFF38BDF8); // Electric Blue
  static const Color accentGreen = Color(0xFF10B981); // Emerald Green
  static const Color primary = accentBlue;

  /// Dynamically generates a production-ready theme based on mode and accent.
  static ThemeData buildTheme({
    required ThemeMode mode,
    required Color accent,
  }) {
    const Color effectiveBackground = background;
    const Color effectiveSurface = surface;
    const Color effectiveTextPrimary = textPrimary;
    const Color effectiveTextSecondary = textSecondary;
    
    final bool isAccentLight = accent.computeLuminance() > 0.6;
    final Color onPrimary = isAccentLight ? background : Colors.white;
    
    final Color accentVariant = Color.lerp(accent, Colors.black, 0.15) ?? accent;
    final Color effectiveCardBorder = Color.lerp(effectiveSurface, Colors.white, 0.08) ?? effectiveSurface;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: effectiveBackground,
      primaryColor: accent,
      
      colorScheme: ColorScheme.dark(
        primary: accent,
        onPrimary: onPrimary,
        secondary: accentVariant,
        surface: effectiveSurface,
        onSurface: effectiveTextPrimary,
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(color: effectiveTextPrimary, fontWeight: FontWeight.w700, fontSize: 52, height: 1.1),
        displayMedium: GoogleFonts.cormorantGaramond(color: effectiveTextPrimary, fontWeight: FontWeight.w700, fontSize: 40, height: 1.2),
        displaySmall: GoogleFonts.cormorantGaramond(color: effectiveTextPrimary, fontWeight: FontWeight.w600, fontSize: 32),
        headlineMedium: GoogleFonts.cormorantGaramond(color: effectiveTextPrimary, fontWeight: FontWeight.w600, fontSize: 28),
        titleLarge: GoogleFonts.cormorantGaramond(color: effectiveTextPrimary, fontWeight: FontWeight.w600, fontSize: 24),
        bodyLarge: GoogleFonts.inter(color: effectiveTextPrimary, fontSize: 17, height: 1.6, letterSpacing: 0.2),
        bodyMedium: GoogleFonts.inter(color: effectiveTextPrimary, fontSize: 15, height: 1.5),
        bodySmall: GoogleFonts.inter(color: effectiveTextSecondary, fontSize: 14),
        labelLarge: GoogleFonts.inter(color: effectiveTextPrimary, fontWeight: FontWeight.w600, fontSize: 16, letterSpacing: 0.5),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: accent),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, letterSpacing: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: BorderSide(color: accent.withValues(alpha: 0.5), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      cardTheme: CardThemeData(
        color: effectiveSurface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: effectiveCardBorder, width: 1),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: effectiveCardBorder,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
