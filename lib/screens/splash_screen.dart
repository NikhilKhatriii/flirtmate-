import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../services/analytics_service.dart';
import 'category_screen.dart';

/// A high-fidelity onboarding screen matching the premium visual design.
/// Optimized for Impeller rendering with proper layer management.
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
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          const _PremiumNebulaBackground(),
          const _MainOnboardingContent(),
        ],
      ),
    );
  }
}

class _MainOnboardingContent extends StatelessWidget {
  const _MainOnboardingContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(flex: 2),
            const _AdvancedFluidLogo(),
            const Spacer(flex: 1),
            const _BrandTitleSection(),
            const SizedBox(height: 12),
            const _AIPoweredBadge(),
            const SizedBox(height: 12),
            const _TaglineText(),
            const Spacer(flex: 2),
            const _FeatureHighlightGrid(),
            const Spacer(flex: 3),
            _VibrantCTAButton(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CategoryScreen()),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _AdvancedFluidLogo extends StatelessWidget {
  const _AdvancedFluidLogo();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // High-Intensity Focal Glow
        Container(
          width: 180, height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.royalPurple.withValues(alpha: 0.15),
                blurRadius: 100, spreadRadius: 20,
              ),
            ],
          ),
        ),
        // Stylized Fluid "F" Monogram
        // Using a solid Opacity wrapper as a buffer for Impeller inherited opacity validation
        Opacity(
          opacity: 1.0,
          child: RepaintBoundary(
            child: SizedBox(
              width: 120, height: 150,
              child: CustomPaint(
                painter: _LogoVectorPainter(),
              ),
            ),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .shimmer(duration: 4.seconds, color: Colors.white.withValues(alpha: 0.15))
         .moveY(begin: -5, end: 5, duration: 3.seconds, curve: Curves.easeInOutSine),
      ],
    ).animate().fadeIn(duration: 1200.ms).scale(begin: const Offset(0.9, 0.9));
  }
}

class _LogoVectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [AppTheme.neonPink, AppTheme.royalPurple, AppTheme.electricBlue],
        stops: [0.1, 0.5, 0.9],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path1 = Path();
    path1.moveTo(size.width * 0.35, size.height * 0.9);
    path1.cubicTo(size.width * 0.1, size.height * 0.6, size.width * 0.25, size.height * 0.2, size.width * 0.45, size.height * 0.15);
    path1.quadraticBezierTo(size.width * 0.85, size.height * 0.1, size.width * 0.9, size.height * 0.35);
    path1.quadraticBezierTo(size.width * 0.8, size.height * 0.45, size.width * 0.4, size.height * 0.42);
    path1.close();
    canvas.drawPath(path1, paint);

    final path2 = Path();
    path2.moveTo(size.width * 0.42, size.height * 0.55);
    path2.quadraticBezierTo(size.width * 0.95, size.height * 0.5, size.width * 0.8, size.height * 0.8);
    path2.quadraticBezierTo(size.width * 0.6, size.height * 0.95, size.width * 0.42, size.height * 0.55);
    canvas.drawPath(path2, paint);

    final glossPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(path1, glossPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BrandTitleSection extends StatelessWidget {
  const _BrandTitleSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Fl", style: _titleStyle),
        Stack(
          alignment: Alignment.center,
          children: [
            Text("i", style: _titleStyle),
            Positioned(
              top: 6,
              child: const Icon(CupertinoIcons.heart_fill, size: 12, color: AppTheme.neonPink)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 800.ms),
            ),
          ],
        ),
        Text("rtMate", style: _titleStyle),
      ],
    );
  }

  TextStyle get _titleStyle => GoogleFonts.inter(
    fontSize: 44, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1.5,
  );
}

class _AIPoweredBadge extends StatelessWidget {
  const _AIPoweredBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        color: Colors.white.withValues(alpha: 0.05),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(CupertinoIcons.sparkles, size: 14, color: AppTheme.neonPink),
          const SizedBox(width: 10),
          Text(
            '✦ AI-POWERED CHEMISTRY ✦',
            style: GoogleFonts.inter(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 10),
          const Icon(CupertinoIcons.sparkles, size: 14, color: AppTheme.electricBlue),
        ],
      ),
    );
  }
}

class _TaglineText extends StatelessWidget {
  const _TaglineText();

  @override
  Widget build(BuildContext context) {
    return Text(
      "Built for real connections.",
      style: GoogleFonts.inter(
        fontSize: 16, color: Colors.white.withValues(alpha: 0.5), fontWeight: FontWeight.w400,
      ),
    ).animate(delay: 400.ms).fadeIn();
  }
}

class _FeatureHighlightGrid extends StatelessWidget {
  const _FeatureHighlightGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _FeatureCard(
            icon: CupertinoIcons.chat_bubble_text_fill,
            title: "14 Detailed\nMoods",
            subtitle: "Express how you feel with precision.",
            accent: AppTheme.neonPink,
            delay: 0,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _FeatureCard(
            icon: CupertinoIcons.infinite,
            title: "Infinite\nLines",
            subtitle: "Break the ice with limitless openers.",
            accent: AppTheme.royalPurple,
            delay: 150,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _FeatureCard(
            icon: CupertinoIcons.sparkles,
            title: "Smart\nResponses",
            subtitle: "AI-crafted replies that feel natural.",
            accent: AppTheme.electricBlue,
            delay: 300,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final int delay;

  const _FeatureCard({
    required this.icon, required this.title, required this.subtitle, required this.accent, required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(shape: BoxShape.circle, color: accent.withValues(alpha: 0.1)),
            child: Icon(icon, size: 24, color: accent),
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 9, color: Colors.white.withValues(alpha: 0.4), height: 1.3),
          ),
          const SizedBox(height: 12),
          Container(
            width: 24, height: 3,
            decoration: BoxDecoration(
              color: accent, borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: accent.withValues(alpha: 0.5), blurRadius: 6)],
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
            gradient: const LinearGradient(colors: [AppTheme.neonPink, AppTheme.royalPurple, AppTheme.electricBlue]),
            boxShadow: [
              BoxShadow(color: AppTheme.neonPink.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(-8, 0)),
              BoxShadow(color: AppTheme.electricBlue.withValues(alpha: 0.35), blurRadius: 30, offset: const Offset(8, 0)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Get Started', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
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
        Container(color: Colors.black),
        // Deep Purple Wash
        Positioned(
          top: 0, right: -100,
          child: Container(
            width: 500, height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.royalPurple.withValues(alpha: 0.06),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
           .blur(begin: const Offset(80, 80), end: const Offset(150, 150), duration: 8.seconds),
        ),

        // Animated Aurora Lines
        RepaintBoundary(
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: _NebulaPainter(),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .fade(begin: 0.3, end: 0.7, duration: 4.seconds),
      ],
    );
  }
}

class _NebulaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.cubicTo(size.width * 0.4, size.height * 0.05, size.width * 0.6, size.height * 0.4, size.width, size.height * 0.1);
    canvas.drawPath(path, paint);

    final path2 = Path();
    path2.moveTo(size.width, size.height * 0.8);
    path2.cubicTo(size.width * 0.6, size.height * 0.95, size.width * 0.4, size.height * 0.6, 0, size.height * 0.9);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
