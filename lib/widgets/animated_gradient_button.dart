import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedGradientButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double height;
  final double width;
  final double borderRadius;

  const AnimatedGradientButton({
    super.key,
    required this.child,
    this.onTap,
    this.height = 56,
    this.width = double.infinity,
    this.borderRadius = 28,
  });

  @override
  State<AnimatedGradientButton> createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: [
                AppTheme.neonPink,
                AppTheme.royalPurple,
                Theme.of(context).primaryColor,
                AppTheme.neonPink,
              ],
              begin: Alignment(-2.0 + (_controller.value * 2.0), -1.0),
              end: Alignment(1.0 + (_controller.value * 2.0), 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.neonPink.withValues(alpha: 0.25),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              onTap: widget.onTap,
              child: Center(child: widget.child),
            ),
          ),
        );
      },
    );
  }
}
