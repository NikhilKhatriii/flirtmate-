import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import '../data/arc_lines.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/personalize_sheet.dart';
import 'favorites_screen.dart';

/// Builds a short, readable summary of the active personalization/vibe for
/// the badge row, e.g. "For Maya · loves hiking", "For Maya", "Just met",
/// or "About: plays guitar · Reconnecting" when multiple are set.
String _personalizationSummary(FlirtProvider provider, LanguageProvider lp) {
  final name = provider.targetName;
  final trait = provider.targetTrait;
  final parts = <String>[];
  if (name.isNotEmpty && trait.isNotEmpty) {
    parts.add('${lp.translate('for')} $name · $trait');
  } else if (name.isNotEmpty) {
    parts.add('${lp.translate('for')} $name');
  } else if (trait.isNotEmpty) {
    parts.add('${lp.translate('about')}: $trait');
  }
  if (provider.hasVibe) parts.add(provider.selectedVibe.label);
  return parts.join(' · ');
}

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
    _msgCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlirtProvider>().generateLine();
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  void _animateAndGenerate() {
    _msgCtrl.forward(from: 0).then((_) {
      context.read<FlirtProvider>().generateLine();
      _msgCtrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    final provider = context.watch<FlirtProvider>();
    final cat = provider.selectedCategory;
    
    if (cat == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: Center(child: Text('No category', style: TextStyle(color: AppTheme.textPrimary))),
      );
    }
    final favCount = provider.favorites.length;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          // Navigation bar
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 12, 0),
            child: Row(children: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () => Navigator.pop(context),
                child: const Icon(
                  CupertinoIcons.chevron_left,
                  color: AppTheme.primaryPlatinum, // Using preset for consistency
                  size: 20,
                ),
              ),
              const Spacer(),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(cat.icon, color: Theme.of(context).colorScheme.primary, size: 17),
                const SizedBox(width: 6),
                Text(
                  lp.translate(cat.id),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ]),
              const Spacer(),
              Stack(clipBehavior: Clip.none, children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(10),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                  child: Icon(
                    CupertinoIcons.heart,
                    color: Theme.of(context).colorScheme.primary,
                    size: 22,
                  ),
                ),
                if (favCount > 0)
                  Positioned(
                    top: 6, right: 6,
                    child: Container(
                      width: 16, height: 16,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$favCount',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ]),
            ]),
          ),

          // Arc stage selector
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: ArcStage.values.map((stage) {
                final isSelected = provider.arcStage == stage;
                final accent = Theme.of(context).colorScheme.primary;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => provider.setArcStage(stage),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.only(
                        left: stage == ArcStage.opener ? 0 : 4,
                        right: stage == ArcStage.deeper ? 0 : 4,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? accent.withValues(alpha: 0.12)
                            : AppTheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? accent.withValues(alpha: 0.4)
                              : AppTheme.cardBorder,
                          width: isSelected ? 1.5 : 0.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            stage.icon,
                            size: 14,
                            color: isSelected ? accent : AppTheme.textSecondary,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            lp.translate('stage_${stage.name}'),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isSelected
                                  ? AppTheme.textPrimary
                                  : AppTheme.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Category info badge
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              borderRadius: 14,
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: cat.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(cat.icon, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      lp.translate('${cat.id}_tagline').toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      lp.translate('${cat.id}_desc'),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textPrimary.withValues(alpha: 0.8),
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                ),
                const SizedBox(width: 8),
                // Mode pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                  child: Icon(
                    provider.isAiAvailable ? CupertinoIcons.sparkles : CupertinoIcons.infinite,
                    size: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ]),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

          // Personalize entry point
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: GestureDetector(
              onTap: () => showPersonalizeSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: provider.isCustomized
                      ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
                      : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: provider.isCustomized
                        ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                        : AppTheme.cardBorder,
                    width: 0.5,
                  ),
                ),
                child: Row(children: [
                  Icon(
                    provider.isCustomized
                        ? CupertinoIcons.person_crop_circle_fill
                        : CupertinoIcons.pencil,
                    size: 16,
                    color: provider.isCustomized
                        ? Theme.of(context).colorScheme.primary
                        : AppTheme.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provider.isCustomized
                          ? _personalizationSummary(provider, lp)
                          : lp.translate('personalize_hint'),
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: provider.isCustomized
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                        fontWeight: provider.isCustomized
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 14,
                    color: AppTheme.textMuted,
                  ),
                ]),
              ),
            ),
          ),

          // History navigation
          if (provider.historyCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(children: [
                _NavBtn(
                  icon: CupertinoIcons.chevron_left,
                  enabled: provider.hasPrev,
                  onTap: () => provider.navigateHistory(-1),
                ),
                const Spacer(),
                Text(
                  provider.state == GeneratorState.loading
                      ? lp.translate('generating').toUpperCase()
                      : '#${provider.historyIndex + 1} OF ${provider.historyCount}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.textMuted,
                  ),
                ),
                const Spacer(),
                _NavBtn(
                  icon: CupertinoIcons.chevron_right,
                  enabled: provider.hasNext,
                  onTap: () => provider.navigateHistory(1),
                ),
              ]),
            ),

          // Message card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: GestureDetector(
                onHorizontalDragStart: (d) => _dragStart = d.localPosition.dx,
                onHorizontalDragEnd: (d) {
                  final dx = d.localPosition.dx - _dragStart;
                  if (provider.state == GeneratorState.loading) return;
                  if (dx < -60) {
                    _animateAndGenerate();
                  } else if (dx > 60 && provider.hasPrev) {
                    provider.navigateHistory(-1);
                  }
                },
                child: _MessageCard(
                  provider: provider,
                  cat: cat,
                  animCtrl: _msgCtrl,
                ),
              ),
            ),
          ),

          // Action buttons — row 1
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(children: [
              _ActionBtn(
                icon: CupertinoIcons.sparkles,
                label: provider.state == GeneratorState.loading
                    ? lp.translate('crafting')
                    : lp.translate('new_line'),
                gradient: [Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.primary],
                enabled: provider.state != GeneratorState.loading,
                isPrimary: true,
                onTap: _animateAndGenerate,
              ),
              const SizedBox(width: 10),
              _ActionBtn(
                icon: provider.isFavorited(provider.currentMessage)
                    ? CupertinoIcons.heart_fill
                    : CupertinoIcons.heart,
                label: provider.isFavorited(provider.currentMessage)
                    ? lp.translate('saved')
                    : lp.translate('save'),
                enabled: provider.currentMessage.isNotEmpty &&
                    provider.state == GeneratorState.success,
                onTap: () async {
                  await provider.toggleFavorite();
                  if (context.mounted) {
                    final isSaved =
                    provider.isFavorited(provider.currentMessage);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(children: [
                          Icon(
                            isSaved
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart_slash,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isSaved
                                ? lp.translate('added_to_fav')
                                : lp.translate('removed_from_fav'),
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600),
                          ),
                        ]),
                        duration: const Duration(milliseconds: 1800),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                },
              ),
            ]),
          ),

          // Action buttons — row 2
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(children: [
              _ActionBtn(
                icon: CupertinoIcons.doc_on_doc,
                label: lp.translate('copy'),
                enabled: provider.currentMessage.isNotEmpty &&
                    provider.state == GeneratorState.success,
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: provider.currentMessage));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(children: [
                        Icon(CupertinoIcons.checkmark_circle,
                            color: Theme.of(context).colorScheme.primary, size: 15),
                        const SizedBox(width: 8),
                        Text(lp.translate('copied'),
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AppTheme.textPrimary)),
                      ]),
                      duration: const Duration(milliseconds: 1500),
                      backgroundColor: AppTheme.surfaceLight,
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              _ActionBtn(
                icon: CupertinoIcons.share,
                label: lp.translate('share'),
                enabled: provider.currentMessage.isNotEmpty &&
                    provider.state == GeneratorState.success,
                onTap: () => Share.share(provider.currentMessage),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final FlirtProvider provider;
  final dynamic cat;
  final AnimationController animCtrl;

  const _MessageCard({
    required this.provider,
    required this.cat,
    required this.animCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: AppTheme.surface,
        border: Border.all(
          color: AppTheme.cardBorder,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(children: [
        Positioned(
          top: 12, left: 16,
          child: Icon(
            CupertinoIcons.quote_bubble,
            size: 52,
            color: accent.withValues(alpha: 0.06),
          ),
        ),
        // Glow
        Positioned(
          bottom: -20, right: -20,
          child: Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                accent.withValues(alpha: 0.04),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        // Content
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: _buildContent(context),
          ),
        ),
      ]),
    );
  }

  Widget _buildContent(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    switch (provider.state) {
      case GeneratorState.loading:
        return const ShimmerLoading();

      case GeneratorState.error:
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 40,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 14),
          Text(
            lp.translate('error_title'),
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.errorMessage,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => provider.generateLine(),
            child: Text(
              lp.translate('tap_to_retry'),
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ]);

      case GeneratorState.success:
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(anim),
              child: child,
            ),
          ),
          child: Text(
            provider.currentMessage,
            key: ValueKey(provider.currentMessage),
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              color: AppTheme.textPrimary,
              height: 1.6,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        );

      default:
        return Text(
          lp.translate('tap_begin').toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppTheme.textMuted,
          ),
          textAlign: TextAlign.center,
        );
    }
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavBtn({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.2,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            border: Border.all(
              color: AppTheme.cardBorder,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.textPrimary, size: 18),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;
  final bool isPrimary;
  final VoidCallback onTap;
  final List<Color>? gradient;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.isPrimary = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.35,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: isPrimary && gradient != null
                  ? LinearGradient(colors: gradient!)
                  : null,
              color: isPrimary ? null : AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isPrimary ? Colors.transparent : AppTheme.cardBorder,
                width: 0.5,
              ),
              boxShadow: isPrimary
                  ? [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
                  : null,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                icon,
                color: isPrimary ? Theme.of(context).colorScheme.onPrimary : AppTheme.textPrimary,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: isPrimary ? Theme.of(context).colorScheme.onPrimary : AppTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
