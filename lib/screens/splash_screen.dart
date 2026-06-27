import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../services/analytics_service.dart';
import 'category_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView('onboarding_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010103),
      body: Stack(
        children: [
          // 1. Nebula Background Effects
          const _PremiumNebulaBackground(),
          
          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    
                    // The Glossy "F" Logo
                    const _FluidAILogo(),
                    
                    const SizedBox(height: 32),

                    // FlirtMate Title with Heart on 'i'
                    const _BrandTitleWithHeart(),

                    const SizedBox(height: 20),

                    // AI-Powered Chemistry Badge
                    const _ChemistryBadge(),

                    const SizedBox(height: 18),

                    Text(
                      "Built for real connections.",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Feature Grid Row
                    const Row(
                      children: [
                        Expanded(
                          child: _FeatureGlassCard(
                            icon: CupertinoIcons.chat_bubble_text_fill,
                            title: "14 Detailed\nMoods",
                            subtitle: "Express how you feel with precision.",
                            accentColor: Color(0xFFFE53BB), // Pink
                            delay: 0,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureGlassCard(
                            icon: CupertinoIcons.infinite,
                            title: "Infinite\nLines",
                            subtitle: "Break the ice with limitless openers.",
                            accentColor: Color(0xFF9D50BB), // Purple
                            delay: 150,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureGlassCard(
                            icon: CupertinoIcons.sparkles,
                            title: "Smart\nResponses",
                            subtitle: "AI-crafted replies that feel natural.",
                            accentColor: Color(0xFF08F7FE), // Cyan
                            delay: 300,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Get Started Button
                    _VibrantCTAButton(
                      onTap: () => Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => const CategoryScreen())),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FluidAILogo extends StatelessWidget {
  const _FluidAILogo();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background Glow
        Container(
          width: 240, height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C5CE7).withValues(alpha: 0.15),
                blurRadius: 100, spreadRadius: 20,
              ),
            ],
          ),
        ),
        // Stylized Vector "F"
        SizedBox(
          width: 160, height: 200,
          child: CustomPaint(
            painter: _AdvancedLogoPainter(),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .shimmer(duration: 4.seconds, color: Colors.white.withValues(alpha: 0.2))
         .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), duration: 2.seconds, curve: Curves.easeInOut),
      ],
    ).animate().fadeIn(duration: 1.seconds);
  }
}

class _AdvancedLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFFE53BB), Color(0xFF6C5CE7), Color(0xFF08F7FE)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // We draw the complex fluid shape of the F from the reference image
    final path = Path();
    
    // Bottom element
    path.moveTo(size.width * 0.35, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.3, size.height * 0.6, size.width * 0.45, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.45, size.width * 0.85, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.1, size.width * 0.35, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.2, size.height * 0.4, size.width * 0.35, size.height * 0.9);
    
    // Second stroke element
    final path2 = Path();
    path2.moveTo(size.width * 0.42, size.height * 0.55);
    path2.quadraticBezierTo(size.width * 0.9, size.height * 0.5, size.width * 0.7, size.height * 0.85);
    path2.quadraticBezierTo(size.width * 0.5, size.height * 0.95, size.width * 0.42, size.height * 0.55);

    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint);

    // Inner highlight for 3D glass look
    final whitePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    
    canvas.drawPath(path, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrandTitleWithHeart extends StatelessWidget {
  const _BrandTitleWithHeart();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Fl",
          style: GoogleFonts.inter(
            fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "i",
              style: GoogleFonts.inter(
                fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1,
              ),
            ),
            Positioned(
              top: 8,
              child: const Icon(CupertinoIcons.heart_fill, size: 14, color: Color(0xFFFE53BB))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 1.seconds),
            ),
          ],
        ),
        Text(
          "rtMate",
          style: GoogleFonts.inter(
            fontSize: 56, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}

class _ChemistryBadge extends StatelessWidget {
  const _ChemistryBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.sparkles, size: 14, color: Color(0xFFFE53BB)),
          const SizedBox(width: 10),
          Text(
            '✦ AI-POWERED CHEMISTRY ✦',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(CupertinoIcons.sparkles, size: 14, color: Color(0xFF08F7FE)),
        ],
      ),
    );
  }
}

class _FeatureGlassCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accentColor;
  final int delay;

  const _FeatureGlassCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Column(
        children: [
          // Icon with glow
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: Icon(icon, size: 30, color: accentColor),
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10, color: Colors.white.withValues(alpha: 0.4), height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          // Accent bar
          Container(
            width: 30, height: 3,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: accentColor.withValues(alpha: 0.5), blurRadius: 8)],
            ),
          ),
        ],
      ),
    ).animate(delay: delay.ms).fadeIn().slideY(begin: 0.1);
  }
}

class _VibrantCTAButton extends StatefulWidget {
  final VoidCallback onTap;
  const _VibrantCTAButton({required this.onTap});
  @override
  State<_VibrantCTAButton> createState() => _VibrantCTAButtonState();
}

class _VibrantCTAButtonState extends State<_VibrantCTAButton> with SingleTickerProviderStateMixin {
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
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.96).animate(_ctrl),
        child: Container(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [Color(0xFFFE53BB), Color(0xFF6C5CE7), Color(0xFF08F7FE)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE53BB).withValues(alpha: 0.35),
                blurRadius: 30, offset: const Offset(-8, 0),
              ),
              BoxShadow(
                color: const Color(0xFF08F7FE).withValues(alpha: 0.35),
                blurRadius: 30, offset: const Offset(8, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 24),
            ],
          ),
        ),
      ),
    ).animate(delay: 1.seconds).fadeIn().slideY(begin: 0.2);
  }
}

class _PremiumNebulaBackground extends StatelessWidget {
  const _PremiumNebulaBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Deep Black Base
        Container(color: Colors.black),
        
        // Pink Glow Top Left
        Positioned(
          top: -150, left: -100,
          child: Container(
            width: 450, height: 450,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFE53BB).withValues(alpha: 0.08),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .blur(begin: const Offset(80, 80), end: const Offset(150, 150), duration: 8.seconds),
        ),

        // Blue Glow Middle Right
        Positioned(
          top: 200, right: -150,
          child: Container(
            width: 500, height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF08F7FE).withValues(alpha: 0.06),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .blur(begin: const Offset(80, 80), end: const Offset(150, 150), duration: 10.seconds),
        ),

        // Animated Aurora effect
        Opacity(
          opacity: 0.1,
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: _NebulaPainter(),
          ),
        ),
      ],
    );
  }
}

class _NebulaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 50);

    final path = Path();
    path.moveTo(0, size.height * 0.4);
    path.cubicTo(size.width * 0.3, size.height * 0.2, size.width * 0.7, size.height * 0.6, size.width, size.height * 0.3);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
