import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';
import 'category_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartCtrl;
  late AnimationController _particleCtrl;
  late Animation<double> _heartAnim;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(vsync: this, duration: 1200.ms)..repeat(reverse: true);
    _particleCtrl = AnimationController(vsync: this, duration: 6000.ms)..repeat();
    _heartAnim = Tween<double>(begin: 1.0, end: 1.22).animate(
        CurvedAnimation(parent: _heartCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _heartCtrl.dispose(); _particleCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 1.5,
            colors: [Color(0xFF2A0A1E), Color(0xFF0D0D1A), Color(0xFF08080F)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating particles
              ...List.generate(16, (i) => _FloatingParticle(index: i, controller: _particleCtrl)),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Heart logo
                    AnimatedBuilder(
                      animation: _heartAnim,
                      builder: (_, __) => Transform.scale(
                        scale: _heartAnim.value,
                        child: Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(
                              color: AppTheme.primary.withOpacity(0.4),
                              blurRadius: 40, spreadRadius: 10,
                            )],
                          ),
                          child: const Text('💖', style: TextStyle(fontSize: 80),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                    const SizedBox(height: 28),

                    // App name
                    GradientText('FlirtMate',
                      colors: const [AppTheme.primary, AppTheme.primaryLight, Color(0xFFFFB3CC)],
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 52, fontWeight: FontWeight.w800, letterSpacing: -1,
                      ),
                    ).animate(delay: 200.ms).fadeIn(duration: 600.ms).slideY(begin: 0.2),

                    const SizedBox(height: 10),

                    Text('Say it better. Say it flirty.',
                      style: GoogleFonts.lato(
                        fontSize: 16, color: AppTheme.textSecondary,
                        fontStyle: FontStyle.italic, letterSpacing: 0.5,
                      ),
                    ).animate(delay: 400.ms).fadeIn(duration: 600.ms),

                    const SizedBox(height: 14),

                    // AI badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.primary.withOpacity(0.4)),
                        borderRadius: BorderRadius.circular(20),
                        color: AppTheme.primary.withOpacity(0.1),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 7, height: 7, decoration: const BoxDecoration(
                          color: AppTheme.primary, shape: BoxShape.circle,
                        )).animate(onPlay: (c) => c.repeat(reverse: true))
                            .scaleXY(begin: 0.6, end: 1.2, duration: 800.ms),
                        const SizedBox(width: 8),
                        Text('14 MOODS · INFINITE LINES',
                            style: GoogleFonts.lato(fontSize: 11, color: AppTheme.primary,
                                fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                      ]),
                    ).animate(delay: 500.ms).fadeIn(duration: 600.ms),

                    const SizedBox(height: 56),

                    // Get Started button
                    _GetStartedButton(
                      onTap: () => Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (_) => const CategoryScreen())),
                    ).animate(delay: 700.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3),

                    const SizedBox(height: 24),

                    Text('14 moods · Always fresh · Always free',
                      style: GoogleFonts.lato(fontSize: 12, color: AppTheme.textMuted),
                    ).animate(delay: 900.ms).fadeIn(),
                  ],
                ),
              ),
            ],
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
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.primaryDark],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: [BoxShadow(
              color: AppTheme.primary.withOpacity(0.45),
              blurRadius: 30, offset: const Offset(0, 10),
            )],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text('Get Started', style: GoogleFonts.lato(
              fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white,
              letterSpacing: 0.5,
            )),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
          ]),
        ),
      ),
    );
  }
}

class _FloatingParticle extends StatelessWidget {
  final int index;
  final AnimationController controller;
  const _FloatingParticle({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {
    final emojis = ['💕', '💖', '✨', '🌹', '💫', '❤️', '💝', '🌟'];
    final emoji = emojis[index % emojis.length];
    final delay = index * 0.07;
    final left = (index * 67 + 23) % 90 + 5.0;
    final duration = 5.0 + (index % 4) * 1.5;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final progress = ((controller.value + delay) % 1.0);
        final opacity = progress < 0.15 ? progress / 0.15
            : progress > 0.85 ? (1 - progress) / 0.15 : 1.0;
        return Positioned(
          left: MediaQuery.of(context).size.width * left / 100,
          bottom: MediaQuery.of(context).size.height * progress,
          child: Opacity(
            opacity: (opacity * 0.6).clamp(0.0, 1.0),
            child: Text(emoji, style: TextStyle(fontSize: 14 + (index % 3) * 4.0)),
          ),
        );
      },
    );
  }
}
