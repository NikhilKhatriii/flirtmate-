import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/theme_selector_sheet.dart';
import '../widgets/language_selector_sheet.dart';
import 'generator_screen.dart';
import 'favorites_screen.dart';
import 'mood_mixer_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    final favCount = context.watch<FlirtProvider>().favorites.length;

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // Navigation bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
            child: Row(children: [
              Text(lp.translate('app_name'),
                style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.primary),
              ),
              const Spacer(),
              _ActionIcon(icon: CupertinoIcons.globe, onTap: () => showLanguageSelector(context)),
              _ActionIcon(icon: CupertinoIcons.paintbrush, onTap: () => showThemeSelector(context)),
              Stack(clipBehavior: Clip.none, children: [
                _ActionIcon(icon: CupertinoIcons.heart, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
                if (favCount > 0)
                  Positioned(top: 6, right: 6, child: _Badge(count: favCount)),
              ]),
            ]),
          ),

          // Adaptive Large title block
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(lp.translate('choose_style'),
                style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF8E95A0), letterSpacing: 1.2, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(lp.translate('flirt_style'),
                style: GoogleFonts.playfairDisplay(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 5),
              Text(lp.translate('tagline'),
                style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF8E95A0)),
              ),
            ]),
          ),

          // Mood Mixer with relative sizing
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodMixerScreen())),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.primary]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [
                  const Icon(CupertinoIcons.slider_horizontal_3, color: Colors.black, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(lp.translate('mood_mixer'), style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black)),
                      Text(lp.translate('mood_mixer_desc'), style: GoogleFonts.inter(fontSize: 11, color: Colors.black54)),
                    ]),
                  ),
                  const Icon(CupertinoIcons.chevron_right, color: Colors.black45, size: 16),
                ]),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05),

          // Enterprise Grid Architecture (Adaptive & Responsive)
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220, // Adaptive sizing
                crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9,
              ),
              itemCount: kCategories.length,
              itemBuilder: (ctx, i) => _CategoryCard(category: kCategories[i], index: i),
            ),
          ),
        ]),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final FlirtCategory category;
  final int index;
  const _CategoryCard({required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    final accent = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        context.read<FlirtProvider>().selectCategory(category);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GeneratorScreen()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF14171C), // Strictly surface color
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.15), width: 1), // Requirement 3: Thin accent border
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtle tinted icon background (Requirement 3)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: accent.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(category.icon, color: accent, size: 20),
              ),
              const Spacer(),
              // Flexible text handling (Requirement 4)
              Text(lp.translate(category.id),
                style: GoogleFonts.playfairDisplay(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                maxLines: 1, overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(lp.translate('${category.id}_desc'),
                style: GoogleFonts.inter(fontSize: 10.5, color: const Color(0xFF8E95A0), height: 1.3),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (index * 40).ms).fadeIn(duration: 400.ms).scale(begin: const Offset(0.9, 0.9));
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionIcon({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => CupertinoButton(padding: const EdgeInsets.all(10), onPressed: onTap, child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20));
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});
  @override
  Widget build(BuildContext context) => Container(width: 16, height: 16, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle), child: Center(child: Text('$count', style: const TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w700))));
}
