import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/gradient_text.dart';
import '../widgets/personalize_sheet.dart';
import 'favorites_screen.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});
  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

/// Builds a short, readable summary of the active personalization/vibe for
/// the badge row, e.g. "For Maya · loves hiking", "For Maya", "Just met",
/// or "About: plays guitar · Reconnecting" when multiple are set.
String _personalizationSummary(FlirtProvider provider) {
  final name = provider.targetName;
  final trait = provider.targetTrait;
  final parts = <String>[];
  if (name.isNotEmpty && trait.isNotEmpty) {
    parts.add('For $name · $trait');
  } else if (name.isNotEmpty) {
    parts.add('For $name');
  } else if (trait.isNotEmpty) {
    parts.add('About: $trait');
  }
  if (provider.hasVibe) parts.add(provider.selectedVibe.label);
  return parts.join(' · ');
}

class _GeneratorScreenState extends State<GeneratorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _msgCtrl;
  double _dragStart = 0;

  @override
  void initState() {
    super.initState();
    _msgCtrl = AnimationController(vsync: this, duration: 400.ms);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlirtProvider>().generateLine();
    });
  }

  @override
  void dispose() { _msgCtrl.dispose(); super.dispose(); }

  void _animateAndGenerate() {
    _msgCtrl.forward(from: 0).then((_) {
      context.read<FlirtProvider>().generateLine();
      _msgCtrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlirtProvider>();
    final cat = provider.selectedCategory;
    if (cat == null) return const Scaffold(body: Center(child: Text('No category')));
    final favCount = provider.favorites.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [
              cat.gradientColors.first.withOpacity(0.3),
              AppTheme.background,
              AppTheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            // AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: AppTheme.textSecondary,
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                GradientText(cat.emoji + ' ' + cat.name,
                  colors: cat.gradientColors,
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 19, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Stack(children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_rounded),
                    color: AppTheme.primaryLight,
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                  ),
                  if (favCount > 0) Positioned(
                    top: 6, right: 6,
                    child: Container(
                      width: 16, height: 16,
                      decoration: const BoxDecoration(
                          color: AppTheme.primary, shape: BoxShape.circle),
                      child: Center(child: Text('$favCount',
                          style: const TextStyle(color: Colors.white, fontSize: 9,
                              fontWeight: FontWeight.bold))),
                    ),
                  ),
                ]),
              ]),
            ),

            // Category badge
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                borderRadius: 14,
                child: Row(children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(cat.tagline, style: GoogleFonts.lato(
                        fontSize: 11, color: AppTheme.textMuted,
                        letterSpacing: 1, fontWeight: FontWeight.w600)),
                    Text(cat.description, style: GoogleFonts.lato(
                        fontSize: 12, color: AppTheme.textSecondary)),
                  ]),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        cat.gradientColors.first.withOpacity(0.6),
                        cat.gradientColors.last.withOpacity(0.6),
                      ]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                        provider.isMixed
                            ? '🧪 MIX'
                            : (provider.isAiAvailable
                            ? (provider.lastLineWasAi ? '✨ AI' : '✨ AI · offline')
                            : '∞'),
                        style: GoogleFonts.lato(
                            fontSize: 11, color: Colors.white, fontWeight: FontWeight.w800)),
                  ),
                ]),
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

            // Personalize entry point
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: GestureDetector(
                onTap: () => showPersonalizeSheet(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: provider.isCustomized
                        ? AppTheme.primary.withOpacity(0.12)
                        : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: provider.isCustomized
                          ? AppTheme.primary.withOpacity(0.4)
                          : AppTheme.cardBorder,
                    ),
                  ),
                  child: Row(children: [
                    Icon(
                      provider.isCustomized
                          ? Icons.favorite_rounded
                          : Icons.edit_note_rounded,
                      size: 17,
                      color: provider.isCustomized
                          ? AppTheme.primaryLight
                          : AppTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.isCustomized
                            ? _personalizationSummary(provider)
                            : 'Personalize with a name, detail, or vibe',
                        style: GoogleFonts.lato(
                          fontSize: 12.5,
                          color: provider.isCustomized
                              ? AppTheme.textPrimary
                              : AppTheme.textMuted,
                          fontWeight: provider.isCustomized
                              ? FontWeight.w600 : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded,
                        size: 18, color: AppTheme.textMuted),
                  ]),
                ),
              ),
            ),

            // History nav
            if (provider.historyCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(children: [
                  _NavBtn(
                    icon: Icons.chevron_left_rounded,
                    enabled: provider.hasPrev,
                    onTap: () => provider.navigateHistory(-1),
                  ),
                  const Spacer(),
                  Text(
                    provider.state == GeneratorState.loading
                        ? 'Generating...'
                        : '#${provider.historyIndex + 1} of ${provider.historyCount}',
                    style: GoogleFonts.lato(fontSize: 12, color: AppTheme.textMuted),
                  ),
                  const Spacer(),
                  _NavBtn(
                    icon: Icons.chevron_right_rounded,
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
                    if (dx < -60) _animateAndGenerate();
                    else if (dx > 60 && provider.hasPrev) provider.navigateHistory(-1);
                  },
                  child: _MessageCard(
                    provider: provider, cat: cat,
                    animCtrl: _msgCtrl,
                  ),
                ),
              ),
            ),

            // Swipe hint
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.swipe_rounded, color: AppTheme.textMuted, size: 14),
                const SizedBox(width: 6),
                Text('Swipe left for new · Swipe right for previous',
                    style: GoogleFonts.lato(fontSize: 11, color: AppTheme.textMuted)),
              ]),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(children: [
                _ActionBtn(
                  icon: Icons.auto_awesome_rounded,
                  label: provider.state == GeneratorState.loading ? 'Crafting...' : 'New Line',
                  gradient: cat.gradientColors,
                  enabled: provider.state != GeneratorState.loading,
                  isPrimary: true,
                  onTap: _animateAndGenerate,
                ),
                const SizedBox(width: 10),
                _ActionBtn(
                  icon: provider.isFavorited(provider.currentMessage)
                      ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: provider.isFavorited(provider.currentMessage) ? 'Saved' : 'Save',
                  enabled: provider.currentMessage.isNotEmpty &&
                      provider.state == GeneratorState.success,
                  onTap: () async {
                    await provider.toggleFavorite();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(provider.isFavorited(provider.currentMessage)
                            ? '💔 Removed from favorites' : '❤️ Saved to favorites!'),
                        duration: 1800.ms,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      ));
                    }
                  },
                ),
              ]),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(children: [
                _ActionBtn(
                  icon: Icons.copy_rounded, label: 'Copy',
                  enabled: provider.currentMessage.isNotEmpty &&
                      provider.state == GeneratorState.success,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: provider.currentMessage));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('📋 Copied to clipboard!'),
                      duration: 1800.ms,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    ));
                  },
                ),
                const SizedBox(width: 10),
                _ActionBtn(
                  icon: Icons.share_rounded, label: 'Share',
                  enabled: provider.currentMessage.isNotEmpty &&
                      provider.state == GeneratorState.success,
                  onTap: () => Share.share(provider.currentMessage),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final FlirtProvider provider;
  final dynamic cat;
  final AnimationController animCtrl;

  const _MessageCard({required this.provider, required this.cat, required this.animCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [
            AppTheme.surfaceLight,
            AppTheme.surface,
          ],
        ),
        border: Border.all(
            color: cat.gradientColors.last.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: cat.gradientColors.last.withOpacity(0.2),
              blurRadius: 30, offset: const Offset(0, 10)),
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20, offset: const Offset(0, 5)),
        ],
      ),
      child: Stack(children: [
        // Decorative quote mark
        Positioned(top: 14, left: 18,
            child: Text('"', style: GoogleFonts.playfairDisplay(
                fontSize: 80, color: cat.gradientColors.last.withOpacity(0.12),
                height: 1))),
        // Glow
        Positioned(bottom: 0, right: 0,
          child: Container(width: 150, height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                cat.gradientColors.last.withOpacity(0.08), Colors.transparent,
              ]),
            ),
          ),
        ),
        // Content
        Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: _buildContent(),
          ),
        ),
      ]),
    );
  }

  Widget _buildContent() {
    switch (provider.state) {
      case GeneratorState.loading:
        return const ShimmerLoading();
      case GeneratorState.error:
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('😕', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 14),
          Text('Something went wrong', style: GoogleFonts.lato(
              fontSize: 16, color: AppTheme.textSecondary)),
          const SizedBox(height: 8),
          Text(provider.errorMessage, style: GoogleFonts.lato(
              fontSize: 12, color: AppTheme.textMuted), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Tap "New Line" to try again', style: GoogleFonts.lato(
              fontSize: 11, color: AppTheme.textMuted)),
        ]);
      case GeneratorState.success:
        return AnimatedSwitcher(
          duration: 350.ms,
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
                  .animate(anim),
              child: child,
            ),
          ),
          child: Text(provider.currentMessage,
            key: ValueKey(provider.currentMessage),
            style: GoogleFonts.playfairDisplay(
                fontSize: 19, color: AppTheme.textPrimary,
                height: 1.65, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        );
      default:
        return Text('Tap "New Line" to begin',
            style: GoogleFonts.lato(fontSize: 15, color: AppTheme.textMuted),
            textAlign: TextAlign.center);
    }
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.3,
        duration: 200.ms,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.cardBorder),
            borderRadius: BorderRadius.circular(10),
            color: AppTheme.surfaceLight,
          ),
          child: Icon(icon, color: AppTheme.textSecondary, size: 20),
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
    required this.icon, required this.label, required this.onTap,
    this.enabled = true, this.isPrimary = false, this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.4,
          duration: 200.ms,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              gradient: isPrimary && gradient != null
                  ? LinearGradient(colors: gradient!)
                  : null,
              color: isPrimary ? null : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isPrimary
                    ? Colors.transparent
                    : AppTheme.cardBorder,
              ),
              boxShadow: isPrimary ? [BoxShadow(
                color: (gradient?.last ?? AppTheme.primary).withOpacity(0.3),
                blurRadius: 16, offset: const Offset(0, 6),
              )] : null,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon,
                  color: isPrimary ? Colors.white : AppTheme.textSecondary, size: 22),
              const SizedBox(height: 4),
              Text(label, style: GoogleFonts.lato(
                  fontSize: 11.5,
                  color: isPrimary ? Colors.white : AppTheme.textSecondary,
                  fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w500)),
            ]),
          ),
        ),
      ),
    );
  }
}
