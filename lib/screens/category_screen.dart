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
import '../services/analytics_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView('category_screen');
  }

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
              // Brand Branding Header
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFF38BDF8)],
                ).createShader(bounds),
                child: Text("FlirtMate",
                  style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -1),
                ),
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
                style: GoogleFonts.cormorantGaramond(fontSize: 48, fontWeight: FontWeight.w800, letterSpacing: -0.5, height: 1.1),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                ),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(CupertinoIcons.slider_horizontal_3, color: Theme.of(context).colorScheme.primary, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(lp.translate('mood_mixer'), style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      Text(lp.translate('mood_mixer_desc'), style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary)),
                    ]),
                  ),
                  const Icon(CupertinoIcons.chevron_right, color: Colors.white24, size: 16),
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
          ).animate().shimmer(duration: 2000.ms, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)),
        ]),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final FlirtCategory category;
  final int index;
  const _CategoryCard({required this.category, required this.index});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    final accent = Theme.of(context).colorScheme.primary;

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          context.read<FlirtProvider>().selectCategory(widget.category);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const GeneratorScreen()));
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.4), // Glass effect
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1), 
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: widget.category.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: widget.category.gradientColors.first.withValues(alpha: 0.3),
                        blurRadius: 12, offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Icon(widget.category.icon, color: Colors.white, size: 22),
                ),
                const Spacer(),
                Text(lp.translate(widget.category.id),
                  style: GoogleFonts.cormorantGaramond(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(lp.translate('${widget.category.id}_desc'),
                  style: GoogleFonts.inter(fontSize: 11.5, color: const Color(0xFF94A3B8), height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (widget.index * 40).ms)
     .fadeIn(duration: 500.ms, curve: Curves.easeOut)
     .moveY(begin: 30, end: 0, duration: 500.ms, curve: Curves.easeOutQuad);
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
