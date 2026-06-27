import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../services/analytics_service.dart';
import 'dashboard_screen.dart';
import '../widgets/glass_card.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _currentSlide = 0;
  final List<Map<String, String>> _socialProofSlides = [
    {
      "value": "AI REPLIES",
      "label": "GENERATED IN SECONDS",
    },
    {
      "value": "CRAFTED NATURAL",
      "label": "NOT ROBOTIC OR CLICHÉD",
    },
    {
      "value": "SMART CONTEXT",
      "label": "FOR HIGH-STAKES CHEMISTRY",
    }
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView('onboarding_screen');
    _rotateSlides();
  }

  void _rotateSlides() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return;
      setState(() {
        _currentSlide = (_currentSlide + 1) % _socialProofSlides.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          const _AnimatedNebulaBackground(),
          
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const SizedBox(height: 8),
                              const _AdvancedFluidLogo(),
                              const SizedBox(height: 12),
                              const _BrandTitleSection(),
                              const SizedBox(height: 6),
                              const _CorporateTagline(),
                              const SizedBox(height: 16),
                              
                              // Social Proof Carousel Slide
                              _buildSocialProofCarousel(),
                              
                              const SizedBox(height: 20),
                              const _FeatureHighlightGrid(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: _StartupGetStartedButton(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialProofCarousel() {
    final slide = _socialProofSlides[_currentSlide];
    return AnimatedSwitcher(
      duration: 500.ms,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation), child: child),
        );
      },
      child: GlassCard(
        key: ValueKey(_currentSlide),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${slide['value']} ",
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppTheme.electricBlue,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              slide['label']!,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorporateTagline extends StatelessWidget {
  const _CorporateTagline();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Say Less. Flirt Better.",
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 4),
        Text(
          "Your premium AI wingman for high-stakes social chemistry.",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ).animate(delay: 500.ms).fadeIn(),
      ],
    );
  }
}

class _AdvancedFluidLogo extends StatelessWidget {
  const _AdvancedFluidLogo();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Pulsing background glow
        Container(
          width: 150, height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.1),
                blurRadius: 80, spreadRadius: 15,
              ),
            ],
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 3.seconds),
        
        SizedBox(
          width: 110, height: 125,
          child: CustomPaint(
            painter: _LogoVectorPainter(primaryColor),
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true))
         .shimmer(duration: 4.seconds, color: Colors.white.withValues(alpha: 0.15))
         .moveY(begin: -4, end: 4, duration: 3.seconds, curve: Curves.easeInOutSine),
      ],
    ).animate().fadeIn(duration: 1.seconds);
  }
}

class _LogoVectorPainter extends CustomPainter {
  final Color primaryColor;
  _LogoVectorPainter(this.primaryColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = primaryColor
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
  @override bool shouldRepaint(covariant _LogoVectorPainter oldDelegate) => oldDelegate.primaryColor != primaryColor;
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
              child: const Icon(CupertinoIcons.heart_fill, size: 10, color: AppTheme.neonPink)
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
    fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1.5,
  );
}

class _FeatureHighlightGrid extends StatelessWidget {
  const _FeatureHighlightGrid();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _FeatureCard(
            icon: LucideIcons.shieldAlert,
            title: "Safe &\nRespected",
            accent: AppTheme.emeraldGreen,
            delay: 0,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _FeatureCard(
            icon: LucideIcons.infinity,
            title: "Infinite\nLines",
            accent: AppTheme.royalPurple,
            delay: 150,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _FeatureCard(
            icon: LucideIcons.sparkles,
            title: "Smart\nResponses",
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
  final Color accent;
  final int delay;

  const _FeatureCard({
    required this.icon, required this.title, required this.accent, required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      height: 120,
      opacity: 0.04,
      borderRadius: 20,
      child: Column(
        children: [
          Icon(icon, size: 24, color: accent),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1),
          ),
          const SizedBox(height: 8),
          Container(
            width: 20, height: 3,
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

class _StartupGetStartedButton extends StatefulWidget {
  final VoidCallback onTap;
  const _StartupGetStartedButton({required this.onTap});
  @override
  State<_StartupGetStartedButton> createState() => _StartupGetStartedButtonState();
}

class _StartupGetStartedButtonState extends State<_StartupGetStartedButton> with SingleTickerProviderStateMixin {
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
    final accent = Theme.of(context).primaryColor;
    // Compute text/icon color for contrast: dark text on light accent, white on dark accent
    final bool isLight = accent.computeLuminance() > 0.4;
    final Color onAccent = isLight ? const Color(0xFF09090B) : Colors.white;
    final Color glowColor = isLight ? accent.withValues(alpha: 0.2) : accent.withValues(alpha: 0.3);

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.96).animate(_ctrl),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: accent,
            border: isLight ? null : Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'GET STARTED',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: onAccent,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 14),
              Icon(CupertinoIcons.arrow_right, color: onAccent, size: 22),
            ],
          ),
        ),
      ),
    ).animate(delay: 1.seconds).fadeIn().slideY(begin: 0.2);
  }
}

class _AnimatedNebulaBackground extends StatelessWidget {
  const _AnimatedNebulaBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: Colors.black),
        _MovingGlow(color: AppTheme.neonPink.withValues(alpha: 0.08), size: 450, start: const Offset(-0.2, -0.2), end: const Offset(0.2, 0.1)),
        _MovingGlow(color: AppTheme.electricBlue.withValues(alpha: 0.06), size: 500, start: const Offset(0.5, 0.2), end: const Offset(0.3, 0.5)),
      ],
    );
  }
}

class _MovingGlow extends StatelessWidget {
  final Color color;
  final double size;
  final Offset start, end;
  const _MovingGlow({required this.color, required this.size, required this.start, required this.end});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(start.dx, start.dy),
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .move(begin: Offset.zero, end: end * 100, duration: 10.seconds, curve: Curves.easeInOut)
     .blur(begin: const Offset(80, 80), end: const Offset(120, 120), duration: 5.seconds);
  }
}
