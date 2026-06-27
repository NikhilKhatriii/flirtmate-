import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // Luxury Startup Design Tokens ($50M Aesthetic)
  // ---------------------------------------------------------------------------
  static const Color background = Color(0xFF09090B); // Zinc 950 (Modern Zinc Dark)
  static const Color surface = Color(0xFF18181B); // Zinc 900
  static const Color surfaceLight = Color(0xFF27272A); // Zinc 800
  static const Color cardBorder = Color(0xFFFFFFFF); // Used with low opacity

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFA1A1AA); // Zinc 400
  static const Color textMuted = Color(0xFF71717A); // Zinc 500

  // Grayscale Luxury Aesthetic Colors
  static const Color neonPink = Colors.white;
  static const Color electricBlue = Color(0xFFE4E4E7); // Zinc 200
  static const Color royalPurple = Color(0xFF27272A); // Zinc 800
  static const Color emeraldGreen = Color(0xFF10B981);
  static const Color champagneGold = Color(0xFFA1A1AA);

  static const Color primary = Colors.white;
  static const Color accentBlue = Color(0xFFD4D4D8); // Zinc 300

  /// Dynamic Glassmorphism Decoration
  static BoxDecoration glassDecoration({
    double opacity = 0.08,
    double blur = 20,
    double borderRadius = 24,
    Color borderColor = Colors.white,
    double borderOpacity = 0.10,
  }) {
    return BoxDecoration(
      color: Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor.withValues(alpha: borderOpacity), width: 1.2),
    );
  }

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
