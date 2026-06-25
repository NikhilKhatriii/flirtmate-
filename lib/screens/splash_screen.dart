import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/gradient_text.dart';
import 'category_screen.dart';

// Professional, Apple-inspired palette — kept local to this screen
// so it doesn't depend on the app-wide pink/purple theme.
class _Palette {
  static const Color background = Color(0xFF0B0B0D);
  static const Color backgroundLight = Color(0xFF1C1C1E);
  static const Color accent = Color(0xFF0A84FF); // iOS system blue
  static const Color accentDark = Color(0xFF0060DB);
  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFAEAEB2);
  static const Color textMuted = Color(0xFF6E6E73);
  static const Color divider = Color(0xFF2C2C2E);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: 2200.ms)
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.06).animate(
        CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_Palette.backgroundLight, _Palette.background],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon mark
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Transform.scale(
                    scale: _pulseAnim.value,
                    child: Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_Palette.accent, _Palette.accentDark],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _Palette.accent.withValues(alpha: 0.35),
                            blurRadius: 36,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 46,
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                const SizedBox(height: 28),

                // App name
                GradientText(
                  'FlirtMate',
                  colors: const [_Palette.textPrimary, _Palette.textSecondary],
                  style: GoogleFonts.inter(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.8,
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2),

                const SizedBox(height: 8),

                Text(
                  'Say it better. Say it right.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: _Palette.textSecondary,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.2,
                  ),
                ).animate(delay: 400.ms).fadeIn(duration: 600.ms),

                const SizedBox(height: 14),

                // Feature badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: _Palette.divider),
                    borderRadius: BorderRadius.circular(20),
                    color: _Palette.backgroundLight.withValues(alpha: 0.6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 14, color: _Palette.accent),
                      const SizedBox(width: 8),
                      Text(
                        '14 MOODS · INFINITE LINES',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: _Palette.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 500.ms).fadeIn(duration: 600.ms),

                const SizedBox(height: 56),

                // Get Started button
                _GetStartedButton(
                  onTap: () => Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const CategoryScreen())),
                ).animate(delay: 700.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3),

                const SizedBox(height: 22),

                Text(
                  '14 moods · Always fresh · Always free',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _Palette.textMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ).animate(delay: 900.ms).fadeIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GetStartedButton({required this.onTap});
  @override
  State<_GetStartedButton> createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<_GetStartedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 150.ms);
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 17),
          decoration: BoxDecoration(
            color: _Palette.accent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _Palette.accent.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Get Started',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}