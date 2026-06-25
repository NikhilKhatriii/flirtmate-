import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final TextAlign? textAlign;

  const GradientText(this.text, {
    super.key, required this.colors, this.style, this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(text, style: style?.copyWith(color: Colors.white) ??
          const TextStyle(color: Colors.white), textAlign: textAlign),
    );
  }
}
