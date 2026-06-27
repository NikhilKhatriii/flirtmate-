import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/settings_sheet.dart';

import '../widgets/glass_card.dart';
import '../theme/app_theme.dart';
import 'mood_mixer_screen.dart';
import 'generator_screen.dart';

import '../services/analytics_service.dart';
import '../data/arc_lines.dart';

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
    final provider = context.watch<FlirtProvider>();
    final favCount = provider.favorites.length;

    return Scaffold(
      backgroundColor: Colors.transparent, // transparency for dashboard background gradient
      body: Column(
        children: [
          _buildAppBar(context, lp, favCount),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(lp),
                  _buildDailyInsight(lp),
                  _buildMoodMixer(context, lp),
                  _buildCategoryGrid(),
                ],
              ),
            ),
          ),
        ],
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
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ),
          const Spacer(),
          _ActionIcon(
            icon: LucideIcons.settings,
            onTap: () {
              HapticFeedback.lightImpact();
              showSettingsSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lp.translate('choose_style').toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.textMuted,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            lp.translate('flirt_style'),
            style: GoogleFonts.cormorantGaramond(
              fontSize: 44,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
              height: 1.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyInsight(LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 24,
        opacity: 0.05,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.sparkles, color: AppTheme.champagneGold, size: 18),
                const SizedBox(width: 8),
                Text(
                  "DAILY INSIGHT",
                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.champagneGold, letterSpacing: 1.2),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Confidence is silent. Insecurities are loud. Today, speak with the certainty that you belong in the room.",
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withValues(alpha: 0.8), height: 1.5, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
    );
  }

  Widget _buildMoodMixer(BuildContext context, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MoodMixerScreen()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFA1A1AA), // Solid light/medium grey
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(LucideIcons.sliders, color: Colors.black87, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lp.translate('mood_mixer'),
                      style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Blend styles for a custom signature",
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.black38, size: 18),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 32),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 240,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: kCategories.length,
      itemBuilder: (ctx, i) => _CategoryCard(category: kCategories[i], index: i),
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
    _ctrl = AnimationController(vsync: this, duration: 150.ms);
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  void _showStageChooser(BuildContext context, LanguageProvider lp) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final provider = context.watch<FlirtProvider>();
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white10),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36, height: 4,
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.category.icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lp.translate(widget.category.id),
                          style: GoogleFonts.cormorantGaramond(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                        Text(
                          "CHOOSE CONVERSATION STAGE",
                          style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.2),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...ArcStage.values.map((stage) {
                  final isSel = provider.arcStage == stage;
                  String desc = "Break the ice naturally";
                  if (stage == ArcStage.followUp) desc = "Keep momentum after a good reply";
                  if (stage == ArcStage.deeper) desc = "Genuine connection & deeper dialogue";

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      provider.selectCategory(widget.category);
                      provider.setArcStage(stage);
                      Navigator.pop(ctx);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => GeneratorScreen()));
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSel ? Theme.of(context).primaryColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSel ? Theme.of(context).primaryColor : Colors.white10,
                          width: isSel ? 1.5 : 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSel ? LucideIcons.checkCircle2 : LucideIcons.circle,
                            color: isSel ? Theme.of(context).primaryColor : Colors.white38,
                            size: 20,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  stage.label,
                                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  desc,
                                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          const Icon(LucideIcons.chevronRight, size: 16, color: Colors.white24),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
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
          HapticFeedback.lightImpact();
          _showStageChooser(context, lp);
        },
        onTapCancel: () => _ctrl.reverse(),
        child: GlassCard(
          borderRadius: 28,
          opacity: 0.05,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(widget.category.icon, color: Colors.white, size: 20),
              ),
              const Spacer(),
              Text(
                lp.translate(widget.category.id),
                style: GoogleFonts.cormorantGaramond(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white, height: 1.1),
              ),
              const SizedBox(height: 6),
              Text(
                lp.translate('${widget.category.id}_desc'),
                style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                maxLines: 2, overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (widget.index * 40).ms).fadeIn().moveY(begin: 30, end: 0, curve: Curves.easeOutQuad);
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ActionIcon({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => CupertinoButton(padding: const EdgeInsets.all(8), onPressed: onTap, child: Icon(icon, color: Colors.white70, size: 20));
}


