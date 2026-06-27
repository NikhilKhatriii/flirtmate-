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
    final primaryColor = Theme.of(context).primaryColor;
    final bool isLight = primaryColor.computeLuminance() > 0.4;
    final Color onPrimary = isLight ? const Color(0xFF09090B) : Colors.white;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: isLight ? null : Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: isLight ? 0.2 : 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          onTap: widget.onTap,
          // Propagate contrast color via DefaultTextStyle and IconTheme
          child: DefaultTextStyle.merge(
            style: TextStyle(color: onPrimary),
            child: IconTheme(
              data: IconThemeData(color: onPrimary),
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
