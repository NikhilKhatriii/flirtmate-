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
      backgroundColor: const Color(0xFF03030F),
      body: Stack(
        children: [
          // 1. Nebula Background
          const _NebulaBackground(),
          
          // 2. Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    
                    // The Stylized "F" Logo
                    const _AILogo(),
                    
                    const SizedBox(height: 32),

                    // FlirtMate Title with Heart
                    const _BrandTitle(),

                    const SizedBox(height: 20),

                    // AI-Powered Chemistry Badge
                    const _TaglineBadge(),

                    const SizedBox(height: 16),

                    Text(
                      "Built for real connections.",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Feature Row
                    const Row(
                      children: [
                        Expanded(
                          child: _FeatureCard(
                            icon: CupertinoIcons.chat_bubble_fill,
                            title: "14 Detailed\nMoods",
                            subtitle: "Express how you feel with precision.",
                            color: Color(0xFFFE53BB),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: CupertinoIcons.infinite,
                            title: "Infinite\nLines",
                            subtitle: "Break the ice with limitless openers.",
                            color: Color(0xFF9D50BB),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _FeatureCard(
                            icon: CupertinoIcons.sparkles,
                            title: "Smart\nResponses",
                            subtitle: "AI-crafted replies that feel natural.",
                            color: Color(0xFF08F7FE),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),

                    // Get Started Button
                    _GradientStartButton(
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

class _AILogo extends StatelessWidget {
  const _AILogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Logo Glow
          Container(
            width: 180, height: 180,
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
          // Custom Drawn "F"
          SizedBox(
            width: 140, height: 180,
            child: CustomPaint(
              painter: _LogoFPainter(),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .shimmer(duration: 3.seconds, color: Colors.white.withValues(alpha: 0.1)),
        ],
      ),
    ).animate().fadeIn(duration: 1.seconds).scale(begin: const Offset(0.8, 0.8));
  }
}

class _LogoFPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFE53BB), Color(0xFF6C5CE7), Color(0xFF08F7FE)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Top bar of F
    path.moveTo(size.width * 0.2, size.height * 0.1);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.05, size.width * 0.9, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.8, size.height * 0.35, size.width * 0.2, size.height * 0.3);
    path.close();

    // Middle bar of F
    path.moveTo(size.width * 0.15, size.height * 0.45);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.4, size.width * 0.8, size.height * 0.55);
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.65, size.width * 0.15, size.height * 0.6);
    path.close();

    // Stem of F
    path.moveTo(size.width * 0.1, size.height * 0.15);
    path.quadraticBezierTo(size.width * 0.05, size.height * 0.5, size.width * 0.1, size.height * 0.9);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9, size.width * 0.2, size.height * 0.15);
    path.close();

    canvas.drawPath(path, paint);
    
    // Add a soft glow stroke
    final glowPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrandTitle extends StatelessWidget {
  const _BrandTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Fl",
          style: GoogleFonts.cormorantGaramond(
            fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1,
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "i",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1,
              ),
            ),
            Positioned(
              top: 4,
              child: const Icon(CupertinoIcons.heart_fill, size: 14, color: Color(0xFFFE53BB))
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.2, 1.2)),
            ),
          ],
        ),
        Text(
          "rtMate",
          style: GoogleFonts.cormorantGaramond(
            fontSize: 52, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1,
          ),
        ),
      ],
    );
  }
}

class _TaglineBadge extends StatelessWidget {
  const _TaglineBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.sparkles, size: 14, color: Color(0xFFFE53BB)),
          const SizedBox(width: 8),
          Text(
            'AI-POWERED CHEMISTRY',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.sparkles, size: 14, color: Color(0xFF08F7FE)),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [color, color.withValues(alpha: 0.5)],
            ).createShader(bounds),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10, color: Colors.white.withValues(alpha: 0.4), height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 24, height: 3,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientStartButton extends StatefulWidget {
  final VoidCallback onTap;
  const _GradientStartButton({required this.onTap});
  @override
  State<_GradientStartButton> createState() => _GradientStartButtonState();
}

class _GradientStartButtonState extends State<_GradientStartButton> with SingleTickerProviderStateMixin {
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
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [Color(0xFFFE53BB), Color(0xFF6C5CE7), Color(0xFF08F7FE)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE53BB).withValues(alpha: 0.3),
                blurRadius: 20, offset: const Offset(-4, 0),
              ),
              BoxShadow(
                color: const Color(0xFF08F7FE).withValues(alpha: 0.3),
                blurRadius: 20, offset: const Offset(4, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Get Started',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(CupertinoIcons.arrow_right, color: Colors.white, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _NebulaBackground extends StatelessWidget {
  const _NebulaBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dark Base
        Container(color: const Color(0xFF03030F)),
        
        // Pink Glow Top Left
        Positioned(
          top: -100, left: -50,
          child: Container(
            width: 300, height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFE53BB).withValues(alpha: 0.08),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .blur(begin: 50, end: 100, duration: 4.seconds),
        ),

        // Blue Glow Bottom Right
        Positioned(
          bottom: -50, right: -50,
          child: Container(
            width: 400, height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF08F7FE).withValues(alpha: 0.08),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .blur(begin: 50, end: 100, duration: 5.seconds),
        ),

        // Subtle Smoke effect (Static for performance, could animate)
        CustomPaint(
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          painter: _SmokePainter(),
        ),
      ],
    );
  }
}

class _SmokePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.02)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
