import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../providers/language_provider.dart';
import '../services/analytics_service.dart';
import '../theme/app_theme.dart';
import '../data/arc_lines.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/personalize_sheet.dart';
import 'favorites_screen.dart';

/// A premium, high-status message generator with an editorial aesthetic.
class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _msgCtrl;
  double _dragStart = 0;

  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView('generator_screen');
    _msgCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lp = context.read<LanguageProvider>();
      context.read<FlirtProvider>().generateLine(
        languageCode: lp.currentLanguage.name,
      );
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _animateAndGenerate() {
    final lp = context.read<LanguageProvider>();
    _msgCtrl.forward(from: 0).then((_) {
      context.read<FlirtProvider>().generateLine(
        languageCode: lp.currentLanguage.name,
      );
      _msgCtrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    final provider = context.watch<FlirtProvider>();
    final cat = provider.selectedCategory;
    
    if (cat == null) return const SizedBox.shrink();
    final favCount = provider.favorites.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, lp, cat, favCount),
            _buildArcStageSelector(provider, lp),
            _buildCategoryBadge(cat, provider, lp),
            _buildPersonalizationBar(provider, lp),
            _buildHistoryCounter(provider, lp),
            _buildMainMessageArea(provider, cat),
            _buildActionButtons(context, provider, lp, cat),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, LanguageProvider lp, dynamic cat, int favCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(12),
            onPressed: () => Navigator.pop(context),
            child: const Icon(CupertinoIcons.chevron_left, color: Colors.white, size: 24),
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lp.translate(cat.id).toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textSecondary,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                "Editorial Selection",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.electricBlue.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CupertinoButton(
                padding: const EdgeInsets.all(12),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                child: const Icon(CupertinoIcons.heart, color: Colors.white, size: 24),
              ),
              if (favCount > 0)
                Positioned(top: 8, right: 8, child: _Badge(count: favCount)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArcStageSelector(FlirtProvider provider, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: ArcStage.values.map((stage) {
          final isSelected = provider.arcStage == stage;
          return Expanded(
            child: GestureDetector(
              onTap: () => provider.setArcStage(stage),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.electricBlue.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.electricBlue.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      stage.icon,
                      size: 16,
                      color: isSelected ? AppTheme.electricBlue : AppTheme.textMuted,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lp.translate('stage_${stage.name}'),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryBadge(dynamic cat, FlirtProvider provider, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: cat.gradientColors),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(cat.icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lp.translate('${cat.id}_tagline').toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textMuted, letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    lp.translate('${cat.id}_desc'),
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white70),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              provider.isAiAvailable ? CupertinoIcons.sparkles : CupertinoIcons.infinite,
              size: 14, color: AppTheme.electricBlue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalizationBar(FlirtProvider provider, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: GestureDetector(
        onTap: () => showPersonalizeSheet(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: provider.isCustomized ? AppTheme.electricBlue.withValues(alpha: 0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: provider.isCustomized ? AppTheme.electricBlue.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
            ),
          ),
          child: Row(
            children: [
              Icon(
                provider.isCustomized ? CupertinoIcons.person_crop_circle_fill : CupertinoIcons.pencil,
                size: 18, color: provider.isCustomized ? AppTheme.electricBlue : AppTheme.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  provider.isCustomized ? _personalizationSummary(provider, lp) : lp.translate('personalize_hint'),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: provider.isCustomized ? Colors.white : AppTheme.textSecondary,
                    fontWeight: provider.isCustomized ? FontWeight.w600 : FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(CupertinoIcons.chevron_right, size: 14, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCounter(FlirtProvider provider, LanguageProvider lp) {
    if (provider.historyCount <= 0) return const SizedBox(height: 12);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              provider.state == GeneratorState.loading
                  ? "CRAFTING..."
                  : "${provider.historyIndex + 1} / ${provider.historyCount}",
              style: GoogleFonts.inter(
                fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.electricBlue, letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMessageArea(FlirtProvider provider, dynamic cat) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: GestureDetector(
          onHorizontalDragStart: (d) => _dragStart = d.localPosition.dx,
          onHorizontalDragEnd: (d) {
            final dx = d.localPosition.dx - _dragStart;
            if (provider.state == GeneratorState.loading) return;
            if (dx < -60) _animateAndGenerate();
            else if (dx > 60 && provider.hasPrev) provider.navigateHistory(-1);
          },
          child: _MessageDisplayCard(provider: provider, animCtrl: _msgCtrl),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, FlirtProvider provider, LanguageProvider lp, dynamic cat) {
    final bool isSuccess = provider.state == GeneratorState.success;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _MainActionBtn(
                  label: isSuccess ? "NEW LINE" : "GENERATE",
                  icon: CupertinoIcons.sparkles,
                  onTap: _animateAndGenerate,
                  isLoading: provider.state == GeneratorState.loading,
                ),
              ),
              const SizedBox(width: 12),
              _SecondaryActionBtn(
                icon: provider.isFavorited(provider.currentMessage) ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                onTap: isSuccess ? () => provider.toggleFavorite() : null,
                activeColor: AppTheme.neonPink,
                isActive: provider.isFavorited(provider.currentMessage),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _TertiaryActionBtn(
                  label: "COPY",
                  icon: CupertinoIcons.doc_on_doc,
                  onTap: isSuccess ? () => _copyToClipboard(context, provider.currentMessage) : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TertiaryActionBtn(
                  label: "SHARE",
                  icon: CupertinoIcons.share,
                  onTap: isSuccess ? () => Share.share(provider.currentMessage) : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Copied to clipboard"),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.surfaceLight,
        duration: 1500.ms,
      ),
    );
  }
}

class _MessageDisplayCard extends StatelessWidget {
  final FlirtProvider provider;
  final AnimationController animCtrl;

  const _MessageDisplayCard({required this.provider, required this.animCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppTheme.royalPurple.withValues(alpha: 0.1),
            blurRadius: 40, spreadRadius: -10,
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 24, left: 24,
            child: Icon(CupertinoIcons.quote_bubble, size: 60, color: Colors.white10),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: _buildContent(context),
            ),
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .moveY(begin: 0, end: 8, duration: 3.seconds, curve: Curves.easeInOutSine);
  }

  Widget _buildContent(BuildContext context) {
    if (provider.state == GeneratorState.loading) return const ShimmerLoading();
    
    if (provider.state == GeneratorState.error) {
      return Text(
        provider.errorMessage,
        style: GoogleFonts.inter(color: AppTheme.textSecondary),
        textAlign: TextAlign.center,
      );
    }

    return AnimatedSwitcher(
      duration: 600.ms,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(anim),
          child: child,
        ),
      ),
      child: Text(
        provider.currentMessage,
        key: ValueKey(provider.currentMessage),
        style: GoogleFonts.cormorantGaramond(
          fontSize: 34,
          color: Colors.white,
          height: 1.4,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _MainActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLoading;

  const _MainActionBtn({required this.label, required this.icon, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isLoading ? null : onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppTheme.neonPink, AppTheme.royalPurple]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: AppTheme.neonPink.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CupertinoActivityIndicator(color: Colors.white)
            else ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _SecondaryActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color activeColor;
  final bool isActive;

  const _SecondaryActionBtn({required this.icon, required this.onTap, required this.activeColor, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        width: 60, height: 60,
        decoration: BoxDecoration(
          color: isActive ? activeColor.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isActive ? activeColor.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, color: isActive ? activeColor : Colors.white70, size: 24),
      ),
    );
  }
}

class _TertiaryActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _TertiaryActionBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  const _Badge({required this.count});
  @override
  Widget build(BuildContext context) => Container(
        width: 18, height: 18,
        decoration: const BoxDecoration(color: AppTheme.neonPink, shape: BoxShape.circle),
        child: Center(
          child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
        ),
      );
}

String _personalizationSummary(FlirtProvider provider, LanguageProvider lp) {
  final name = provider.targetName;
  final trait = provider.targetTrait;
  final parts = <String>[];
  if (name.isNotEmpty && trait.isNotEmpty) parts.add('${lp.translate('for')} $name · $trait');
  else if (name.isNotEmpty) parts.add('${lp.translate('for')} $name');
  else if (trait.isNotEmpty) parts.add('${lp.translate('about')}: $trait');
  if (provider.hasVibe) parts.add(provider.selectedVibe.label);
  return parts.join(' · ');
}
