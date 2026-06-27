import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class SatisfyingCopyButton extends StatefulWidget {
  final String textToCopy;
  final String label;
  final String copiedLabel;
  final EdgeInsetsGeometry? padding;
  final double height;
  final bool enabled;

  const SatisfyingCopyButton({
    super.key,
    required this.textToCopy,
    this.label = "Copy Reply",
    this.copiedLabel = "✓ Copied!",
    this.padding,
    this.height = 48.0,
    this.enabled = true,
  });

  @override
  State<SatisfyingCopyButton> createState() => _SatisfyingCopyButtonState();
}

class _SatisfyingCopyButtonState extends State<SatisfyingCopyButton> {
  bool _isCopied = false;

  void _handleCopy() async {
    if (_isCopied) return;

    // Haptic feedback for ultra satisfying touch feel
    HapticFeedback.mediumImpact();
    await Clipboard.setData(ClipboardData(text: widget.textToCopy));

    setState(() {
      _isCopied = true;
    });

    // Revert after 2 seconds
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCopy,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: widget.height,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: _isCopied
              ? const LinearGradient(colors: [AppTheme.emeraldGreen, Color(0xFF10B981)])
              : LinearGradient(colors: [Theme.of(context).primaryColor, AppTheme.royalPurple]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isCopied
              ? [
                  BoxShadow(
                    color: AppTheme.emeraldGreen.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: _isCopied
                  ? const Icon(
                      LucideIcons.check,
                      key: ValueKey("check"),
                      color: Colors.white,
                      size: 18,
                    )
                  : const Icon(
                      LucideIcons.copy,
                      key: ValueKey("copy"),
                      color: Colors.white,
                      size: 16,
                    ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
              child: Text(
                _isCopied ? widget.copiedLabel : widget.label,
                key: ValueKey(_isCopied),
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(target: _isCopied ? 1 : 0).scaleXY(end: 0.96, duration: 100.ms).then().scaleXY(end: 1.0, duration: 150.ms);
  }
}
