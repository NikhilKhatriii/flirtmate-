import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import 'generator_screen.dart';

// ---------------------------------------------------------------------------
// Apple-style design tokens
//   Background        #000000
//   Elevated surface  #1C1C1E
//   Card border       #38383A
//   Label primary     #FFFFFF
//   Label secondary   #8E8E93
//   System blue       #007AFF
//   Deep blue         #0051A8
// ---------------------------------------------------------------------------

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
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(children: [
          // ----------------------------------------------------------------
          // Navigation bar
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
            child: Row(children: [
              CupertinoButton(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () => Navigator.pop(context),
                child: const Icon(
                  CupertinoIcons.chevron_left,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              // Title — icon replaces 🧪 emoji
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0051A8), Color(0xFF007AFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Mood Mixer',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.4,
                  ),
                ),
              ]),
            ]),
          ),

          // ----------------------------------------------------------------
          // Status line
          // ----------------------------------------------------------------
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
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
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
                color: const Color(0xFF8E8E93),
              ),
            ),
          ),

          // ----------------------------------------------------------------
          // Category grid
          // ----------------------------------------------------------------
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
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

          // ----------------------------------------------------------------
          // Confirm button — system blue when active
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: AnimatedContainer(
              duration: 200.ms,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: readyToMix
                    ? const LinearGradient(
                  colors: [Color(0xFF0051A8), Color(0xFF007AFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: readyToMix ? null : const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: readyToMix
                      ? Colors.transparent
                      : const Color(0xFF38383A),
                  width: 0.5,
                ),
                boxShadow: readyToMix
                    ? [
                  BoxShadow(
                    color:
                    const Color(0xFF007AFF).withValues(alpha: 0.30),
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
                          ? Colors.white
                          : const Color(0xFF636366),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      readyToMix
                          ? 'Mix & Generate'
                          : 'Pick 2 styles to continue',
                      style: GoogleFonts.inter(
                        color: readyToMix
                            ? Colors.white
                            : const Color(0xFF636366),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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

// ---------------------------------------------------------------------------
// Individual mix card
// ---------------------------------------------------------------------------

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
          gradient: LinearGradient(
            colors: category.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.90)
                : Colors.white.withValues(alpha: 0.07),
            width: isSelected ? 2 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: category.gradientColors.last
                  .withValues(alpha: isSelected ? 0.50 : 0.25),
              blurRadius: isSelected ? 20 : 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(children: [
          // Dim overlay when not selected
          if (!isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.20),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

          // Top-edge shine
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon replaces emoji
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const Spacer(),
                Text(
                  category.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  category.tagline,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.60),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Selection order badge — "1" or "2"
          if (isSelected)
            Positioned(
              top: 8, right: 8,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$selectedOrder',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF007AFF),
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