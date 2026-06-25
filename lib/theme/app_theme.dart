import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // Production-Grade Design Tokens (Base)
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFF0B0C0E);
  static const Color surface = Color(0xFF14171C);
  static const Color surfaceLight = Color(0xFF1F2229);
  static const Color cardBorder = Color(0xFF2C3039);

  static const Color textPrimary = Color(0xFFE2E5E9);
  static const Color textSecondary = Color(0xFF8E95A0);
  static const Color textMuted = Color(0xFF636971);

  // Default Accents (Presets)
  static const Color primaryPlatinum = Color(0xFFE2E5E9);
  static const Color primaryChampagne = Color(0xFFE5C07B);
  static const Color primaryTeal = Color(0xFF00E5FF);

  // Legacy support for files not yet using colorScheme
  // Note: These are getters, so they cannot be used in 'const' constructors.
  static Color get primary => primaryPlatinum; 
  static Color get primaryDark => const Color(0xFFB0B3B8);

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
        displayLarge: GoogleFonts.playfairDisplay(color: effectiveTextPrimary, fontWeight: FontWeight.w800),
        displayMedium: GoogleFonts.playfairDisplay(color: effectiveTextPrimary, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.inter(color: effectiveTextPrimary, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: effectiveTextPrimary),
        bodyMedium: GoogleFonts.inter(color: effectiveTextPrimary),
        bodySmall: GoogleFonts.inter(color: effectiveTextSecondary),
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
