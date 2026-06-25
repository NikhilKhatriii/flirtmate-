import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';
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
    context.read<FlirtProvider>().selectMixedCategories(_picked[0], _picked[1]);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const GeneratorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF150D20), AppTheme.background, Color(0xFF08080F)],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: AppTheme.textSecondary,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                GradientText('🧪 Mood Mixer',
                    colors: const [AppTheme.primary, AppTheme.primaryLight],
                    style: GoogleFonts.playfairDisplay(
                        fontSize: 21, fontWeight: FontWeight.w700)),
              ]),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 4),
              child: Text(
                _picked.isEmpty
                    ? 'Pick any 2 styles to blend together'
                    : _picked.length == 1
                    ? 'Picked ${_picked[0].name} — choose one more'
                    : '${_picked[0].name} + ${_picked[1].name} — ready to mix',
                style: GoogleFonts.lato(fontSize: 14, color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                'Lines will alternate between both styles for one combined mood.',
                style: GoogleFonts.lato(fontSize: 12, color: AppTheme.textMuted),
              ),
            ),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                  childAspectRatio: 0.95,
                ),
                itemCount: kCategories.length,
                itemBuilder: (ctx, i) {
                  final cat = kCategories[i];
                  final selectedIndex = _picked.indexOf(cat);
                  return _MixCard(
                    category: cat,
                    index: i,
                    selectedOrder: selectedIndex == -1 ? null : selectedIndex + 1,
                    onTap: () => _toggle(cat),
                  );
                },
              ),
            ),

            // Confirm bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _picked.length == 2 ? _confirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: AppTheme.surfaceLight,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    _picked.length == 2 ? 'Mix & Generate' : 'Pick 2 styles to continue',
                    style: GoogleFonts.lato(
                        color: _picked.length == 2 ? Colors.white : AppTheme.textMuted,
                        fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                ),
              ),
            ),
          ]),
        ),
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
    required this.category, required this.index,
    required this.selectedOrder, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedOrder != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: category.gradientColors,
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: [BoxShadow(
            color: category.gradientColors.last.withOpacity(isSelected ? 0.55 : 0.3),
            blurRadius: isSelected ? 22 : 14, offset: const Offset(0, 6),
          )],
        ),
        child: Stack(children: [
          if (!isSelected)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 28)),
                const Spacer(),
                Text(category.name, style: GoogleFonts.playfairDisplay(
                    fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 2),
                Text(category.tagline, style: GoogleFonts.lato(
                    fontSize: 10, color: Colors.white60, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 8, right: 8,
              child: Container(
                width: 24, height: 24,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: Center(child: Text('$selectedOrder', style: GoogleFonts.lato(
                    fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.primary))),
              ),
            ),
        ]),
      ),
    ).animate(delay: (index * 30).ms).fadeIn(duration: 350.ms).slideY(begin: 0.1);
  }
}
