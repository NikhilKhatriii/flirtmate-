import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import 'generator_screen.dart';

/// Lets the user pick exactly two categories to blend into one combined
/// style — e.g. Romantic + Funny gives sweet lines with a comedic edge.
/// Tapping two cards and confirming jumps straight into the generator
/// using a synthetic, blended FlirtCategory.
class MoodMixerScreen extends StatefulWidget {
  const MoodMixerScreen({super.key});

  @override
  State<MoodMixerScreen> createState() => _MoodMixerScreenState();
}

class _MoodMixerScreenState extends State<MoodMixerScreen> {
  final List<FlirtCategory> _picked = [];

  void _toggle(FlirtCategory cat) {
    setState(() {
      if (_picked.contains(cat)) {
        _picked.remove(cat);
      } else if (_picked.length < 2) {
        _picked.add(cat);
      } else {
        // Already have 2 picked — swap out the oldest pick for the new one
        // so tapping a third card always replaces rather than doing nothing.
        _picked.removeAt(0);
        _picked.add(cat);
      }
    });
  }

  void _confirm() {
    if (_picked.length != 2) return;
    context
        .read<FlirtProvider>()
        .selectMixedCategories(_picked[0], _picked[1]);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const GeneratorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final readyToMix = _picked.length == 2;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          // Navigation bar
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
            child: Row(children: [
              CupertinoButton(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () => Navigator.pop(context),
                child: const Icon(
                  CupertinoIcons.chevron_left,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryDark, AppTheme.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: AppTheme.background,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Mood Mixer',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ]),
            ]),
          ),

          // Status line
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: AnimatedSwitcher(
              duration: 220.ms,
              child: Text(
                _picked.isEmpty
                    ? 'Pick any 2 styles to blend together'
                    : _picked.length == 1
                    ? 'Picked ${_picked[0].name} — choose one more'
                    : '${_picked[0].name} + ${_picked[1].name} — ready to mix',
                key: ValueKey(_picked.length),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
            child: Text(
              'Lines will alternate between both styles for one combined mood.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // Category grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
              itemCount: kCategories.length,
              itemBuilder: (ctx, i) {
                final cat = kCategories[i];
                final selectedIndex = _picked.indexOf(cat);
                return _MixCard(
                  category: cat,
                  index: i,
                  selectedOrder:
                  selectedIndex == -1 ? null : selectedIndex + 1,
                  onTap: () => _toggle(cat),
                );
              },
            ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: AnimatedContainer(
              duration: 200.ms,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: readyToMix
                    ? const LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: readyToMix ? null : AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: readyToMix
                      ? Colors.transparent
                      : AppTheme.cardBorder,
                  width: 0.5,
                ),
                boxShadow: readyToMix
                    ? [
                  BoxShadow(
                    color: AppTheme.primaryDark.withValues(alpha: 0.30),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
                    : null,
              ),
              child: CupertinoButton(
                onPressed: readyToMix ? _confirm : null,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      readyToMix
                          ? CupertinoIcons.sparkles
                          : CupertinoIcons.hand_point_right,
                      size: 16,
                      color: readyToMix
                          ? AppTheme.background
                          : AppTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      readyToMix
                          ? 'Mix & Generate'
                          : 'Pick 2 styles to continue',
                      style: GoogleFonts.inter(
                        color: readyToMix
                            ? AppTheme.background
                            : AppTheme.textMuted,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _MixCard extends StatelessWidget {
  final FlirtCategory category;
  final int index;
  final int? selectedOrder; // 1 or 2 if picked, else null
  final VoidCallback onTap;

  const _MixCard({
    required this.category,
    required this.index,
    required this.selectedOrder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedOrder != null;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary
                : AppTheme.cardBorder,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected ? AppTheme.primary.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.1),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(children: [
          // Icon replaces emoji
          Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: category.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                category.icon,
                color: AppTheme.textPrimary,
                size: 18,
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  category.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category.tagline,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Selection order badge — "1" or "2"
          if (isSelected)
            Positioned(
              top: 10, right: 10,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$selectedOrder',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.background,
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    ).animate(delay: (index * 30).ms).fadeIn(duration: 350.ms).slideY(begin: 0.08);
  }
}
