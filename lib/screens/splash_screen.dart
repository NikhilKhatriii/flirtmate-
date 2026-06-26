import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';
import '../services/analytics_service.dart';
import '../widgets/gradient_text.dart';
import 'category_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _rotationCtrl;

  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView('splash_screen');
    _rotationCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
  }

  @override
  void dispose() {
    _rotationCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14), // Ultra deep midnight
      body: Stack(
        children: [
          // 1. Background Layers (Celestial/Constellation)
          const _CelestialBackground(),
          
          // 2. Rotating Astrological Ring (Subtle)
          Center(
            child: RotationTransition(
              turns: _rotationCtrl,
              child: Opacity(
                opacity: 0.15,
                child: CustomPaint(
                  size: const Size(600, 600),
                  painter: _AstrologicalPainter(),
                ),
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  
                  // Central Logo - The Metallic Plate & Crystal Heart
                  const _LuxuryLogo(),
                  
                  const SizedBox(height: 48),

                  // App Name - Silver Gradient
                  GradientText(
                    lp.translate('app_name'),
                    colors: const [Color(0xFFE2E5E9), Color(0xFF989CA3)],
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 52,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, curve: Curves.easeOut),

                  const SizedBox(height: 12),

                  // Tagline
                  Text(
                    lp.translate('tagline_splash'),
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      color: AppTheme.textSecondary.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ).animate(delay: 300.ms).fadeIn(duration: 800.ms),

                  const SizedBox(height: 24),

                  // Feature Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: Text(
                      '✦ 14 CURATED MOODS · UNLIMITED LINES ✦',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textPrimary.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ).animate(delay: 500.ms).fadeIn(duration: 800.ms),

                  const Spacer(flex: 2),

                  // Action Button
                  _LuxuryStartButton(
                    onTap: () => Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (_) => const CategoryScreen())),
                  ).animate(delay: 800.ms).fadeIn(duration: 800.ms).slideY(begin: 0.4, curve: Curves.easeOut),

                  const SizedBox(height: 24),

                  // Footer
                  Text(
                    'Explore 14 Detailed Moods. Enjoy Fresh Daily Content. Forever Free to Use.',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ).animate(delay: 1200.ms).fadeIn(),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryLogo extends StatelessWidget {
  const _LuxuryLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, height: 220,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C5CE7).withValues(alpha: 0.2),
            blurRadius: 60, spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Metallic Ring
          Container(
            width: 210, height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF505458), Color(0xFF1B1D21), Color(0xFF505458)],
              ),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
            ),
          ),
          // Inner Brushed Ring
          Container(
            width: 190, height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [Color(0xFF2C3035), Color(0xFF4A4E54), Color(0xFF2C3035)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          // Reflection Highlight
          Positioned(
            top: 20, left: 20,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withValues(alpha: 0.08), Colors.transparent],
                  center: Alignment.topLeft,
                ),
              ),
            ),
          ),
          // Crystal Heart Icon
          _CrystalHeart(),
        ],
      ),
    ).animate().scale(duration: 1000.ms, curve: Curves.elasticOut);
  }
}

class _CrystalHeart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow behind heart
        const Icon(CupertinoIcons.heart_fill, size: 90, color: Color(0xFF6C5CE7))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .blurXY(begin: 10, end: 30, duration: 2000.ms),
            
        // The Crystal Base
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE0C3FC), Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          ).createShader(bounds),
          child: const Icon(CupertinoIcons.heart_fill, size: 84, color: Colors.white),
        ),
        
        // Sparkle highlights
        const Icon(CupertinoIcons.heart, size: 84, color: Colors.white24),
      ],
    );
  }
}

class _LuxuryStartButton extends StatefulWidget {
  final VoidCallback onTap;
  const _LuxuryStartButton({required this.onTap});
  @override
  State<_LuxuryStartButton> createState() => _LuxuryStartButtonState();
}

class _LuxuryStartButtonState extends State<_LuxuryStartButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 150.ms);
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.95).animate(_ctrl),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF323639), Color(0xFF121416)],
            ),
            border: Border.all(color: const Color(0xFFE2E5E9).withValues(alpha: 0.4), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.1),
                blurRadius: 20, offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lp.translate('get_started').toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFFE2E5E9),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(CupertinoIcons.arrow_right, color: Color(0xFFE2E5E9), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CelestialBackground extends StatelessWidget {
  const _CelestialBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [Color(0xFF1A1A2F), Color(0xFF05050A)],
        ),
      ),
      child: Stack(
        children: List.generate(50, (index) {
          final random = math.Random(index);
          return Positioned(
            left: random.nextDouble() * MediaQuery.of(context).size.width,
            top: random.nextDouble() * MediaQuery.of(context).size.height,
            child: Container(
              width: random.nextDouble() * 2 + 1,
              height: random.nextDouble() * 2 + 1,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: random.nextDouble() * 0.5),
                shape: BoxShape.circle,
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
             .fadeIn(duration: (1000 + random.nextInt(2000)).ms)
             .move(begin: Offset.zero, end: Offset(random.nextDouble() * 20 - 10, random.nextDouble() * 20 - 10), duration: 10.seconds, curve: Curves.linear),
          );
        }),
      ),
    );
  }
}

class _AstrologicalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    
    // Draw concentric thin circles
    canvas.drawCircle(center, size.width * 0.45, paint);
    canvas.drawCircle(center, size.width * 0.38, paint);
    
    // Draw cross lines
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

    // Draw some random connection lines for constellation feel
    for (int i = 0; i < 12; i++) {
      double angle = i * (2 * math.pi / 12);
      double x = center.dx + size.width * 0.45 * math.cos(angle);
      double y = center.dy + size.height * 0.45 * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
