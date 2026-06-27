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
import '../theme/app_theme.dart';
import 'generator_screen.dart';
import 'favorites_screen.dart';
import 'mood_mixer_screen.dart';
import '../services/analytics_service.dart';

/// A high-fidelity category selection screen with a premium editorial design.
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
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, lp, favCount),
            _buildHeader(lp),
            _buildMoodMixer(context, lp),
            _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, LanguageProvider lp, int favCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
      child: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, AppTheme.electricBlue],
            ).createShader(bounds),
            child: Text(
              "FlirtMate",
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),
          const Spacer(),
          _ActionIcon(icon: CupertinoIcons.globe, onTap: () => showLanguageSelector(context)),
          _ActionIcon(icon: CupertinoIcons.paintbrush, onTap: () => showThemeSelector(context)),
          Stack(
            clipBehavior: Clip.none,
            children: [
              _ActionIcon(
                icon: CupertinoIcons.heart,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                ),
              ),
              if (favCount > 0)
                Positioned(top: 6, right: 6, child: _Badge(count: favCount)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lp.translate('choose_style').toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textSecondary,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lp.translate('flirt_style'),
            style: GoogleFonts.cormorantGaramond(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.1,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Premium lines for sophisticated connections.",
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodMixer(BuildContext context, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MoodMixerScreen()),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: AppTheme.electricBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lp.translate('mood_mixer'),
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Blend styles for a custom signature",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(CupertinoIcons.chevron_right, color: Colors.white24, size: 18),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05);
  }

  Widget _buildCategoryGrid() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 240,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: kCategories.length,
        itemBuilder: (ctx, i) => _CategoryCard(category: kCategories[i], index: i),
      ),
    ).animate().shimmer(
          duration: 3000.ms,
          color: AppTheme.royalPurple.withValues(alpha: 0.05),
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
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          context.read<FlirtProvider>().selectCategory(widget.category);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GeneratorScreen()),
          );
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // Subtle Background Glow
                Positioned(
                  top: -20, right: -20,
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.category.gradientColors.first.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon with dynamic gradient
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: widget.category.gradientColors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: widget.category.gradientColors.first.withValues(alpha: 0.3),
                              blurRadius: 15, offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Icon(widget.category.icon, color: Colors.white, size: 24),
                      ),
                      const Spacer(),
                      Text(
                        lp.translate(widget.category.id),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lp.translate('${widget.category.id}_desc'),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: (widget.index * 50).ms)
     .fadeIn(duration: 600.ms, curve: Curves.easeOut)
     .moveY(begin: 40, end: 0, duration: 600.ms, curve: Curves.easeOutQuad);
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionIcon({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: const EdgeInsets.all(10),
        onPressed: onTap,
        child: Icon(icon, color: AppTheme.textPrimary, size: 22),
      );
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});
  @override
  Widget build(BuildContext context) => Container(
        width: 18, height: 18,
        decoration: const BoxDecoration(color: AppTheme.neonPink, shape: BoxShape.circle),
        child: Center(
          child: Text(
            '$count',
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
          ),
        ),
      );
}
