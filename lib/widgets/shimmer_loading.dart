import 'package:flutter/material.dart';

// Neutral, Apple-style palette — kept local so this widget doesn't
// depend on the app-wide pink/purple theme.
class _ShimmerPalette {
  static const Color surfaceLight = Color(0xFF2C2C2E);
  static const Color accent = Color(0xFF0A84FF);
  static const Color textMuted = Color(0xFF8E8E93);
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({super.key});

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();
    _anim = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _anim,
          builder: (_, __) => ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                _ShimmerPalette.surfaceLight,
                _ShimmerPalette.accent.withValues(alpha: 0.5),
                _ShimmerPalette.surfaceLight,
              ],
              stops: [
                (_anim.value - 0.3).clamp(0.0, 1.0),
                _anim.value.clamp(0.0, 1.0),
                (_anim.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds),
            child: Column(children: [
              _shimmerLine(0.85), const SizedBox(height: 12),
              _shimmerLine(0.70), const SizedBox(height: 12),
              _shimmerLine(0.55),
            ]),
          ),
        ),
        const SizedBox(height: 24),
        const _PulsingDots(),
        const SizedBox(height: 8),
        const Text('Crafting the perfect line...',
            style: TextStyle(color: _ShimmerPalette.textMuted, fontSize: 13,
                fontStyle: FontStyle.italic)),
      ],
    );
  }

  Widget _shimmerLine(double width) => FractionallySizedBox(
    widthFactor: width,
    child: Container(
      height: 14, decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(7),
    ),
    ),
  );
}

class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) => AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final delay = i * 0.2;
          final val = ((_ctrl.value - delay) * 3).clamp(0.0, 1.0);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: _ShimmerPalette.accent.withValues(alpha: 0.3 + val * 0.7),
              shape: BoxShape.circle,
            ),
          );
        },
      )),
    );
  }
}