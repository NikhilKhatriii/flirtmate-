import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../data/arc_lines.dart';
import '../widgets/glass_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/personalize_sheet.dart';
import 'favorites_screen.dart';

// ---------------------------------------------------------------------------
// Apple-style design tokens
//   Background        #000000
//   Elevated surface  #1C1C1E
//   Card border       #38383A
//   Label primary     #FFFFFF
//   Label secondary   #8E8E93
//   System blue       #007AFF
//   Destructive red   #FF3B30
// ---------------------------------------------------------------------------

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
    _msgCtrl = AnimationController(vsync: this, duration: 400.ms);
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
    final provider = context.watch<FlirtProvider>();
    final cat = provider.selectedCategory;
    if (cat == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Center(child: Text('No category', style: TextStyle(color: Colors.white))),
      );
    }
    final favCount = provider.favorites.length;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(children: [
          // ----------------------------------------------------------------
          // Navigation bar
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 8, 12, 0),
            child: Row(children: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () => Navigator.pop(context),
                child: const Icon(
                  CupertinoIcons.chevron_left,
                  color: Color(0xFF007AFF),
                  size: 20,
                ),
              ),
              const Spacer(),
              // Category title — icon + name
              Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(cat.icon, color: Colors.white, size: 17),
                const SizedBox(width: 6),
                Text(
                  cat.name,
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ]),
              const Spacer(),
              // Favorites button with badge
              Stack(clipBehavior: Clip.none, children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(10),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FavoritesScreen())),
                  child: const Icon(
                    CupertinoIcons.heart,
                    color: Color(0xFF007AFF),
                    size: 22,
                  ),
                ),
                if (favCount > 0)
                  Positioned(
                    top: 6, right: 6,
                    child: Container(
                      width: 16, height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFF007AFF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$favCount',
                          style: const TextStyle(
                            color: Colors.white,
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

          // ----------------------------------------------------------------
          // Arc stage selector — segmented control style
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: ArcStage.values.map((stage) {
                final isSelected = provider.arcStage == stage;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => provider.setArcStage(stage),
                    child: AnimatedContainer(
                      duration: 200.ms,
                      margin: EdgeInsets.only(
                        left: stage == ArcStage.opener ? 0 : 4,
                        right: stage == ArcStage.deeper ? 0 : 4,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF007AFF).withValues(alpha: 0.15)
                        : const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF007AFF).withValues(alpha: 0.55)
                          : const Color(0xFF38383A),
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        stage.icon,
                        size: 14,
                        color: isSelected
                            ? const Color(0xFF007AFF)
                            : const Color(0xFF8E8E93),
                      ),
                          const SizedBox(height: 3),
                          Text(
                            stage.label,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF8E8E93),
                              fontWeight: isSelected
                                  ? FontWeight.w600
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

          // ----------------------------------------------------------------
          // Category info badge
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              borderRadius: 14,
              child: Row(children: [
                // Category icon in frosted pill
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    cat.tagline.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF8E8E93),
                      letterSpacing: 0.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    cat.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.80),
                    ),
                  ),
                ]),
                const Spacer(),
                // Mode pill — no emoji
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.30),
                      width: 0.5,
                    ),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      provider.isMixed
                          ? CupertinoIcons.rectangle_stack
                          : provider.isAiAvailable
                          ? CupertinoIcons.sparkles
                          : CupertinoIcons.infinite,
                      size: 10,
                      color: const Color(0xFF007AFF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      provider.isMixed
                          ? 'Mix'
                          : provider.isAiAvailable
                          ? (provider.lastLineWasAi ? 'AI' : 'AI · offline')
                          : 'Offline',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: const Color(0xFF007AFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
                ),
              ]),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

          // ----------------------------------------------------------------
          // Personalize entry point
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: GestureDetector(
              onTap: () => showPersonalizeSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: provider.isCustomized
                      ? const Color(0xFF007AFF).withValues(alpha: 0.10)
                      : const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: provider.isCustomized
                        ? const Color(0xFF007AFF).withValues(alpha: 0.40)
                        : const Color(0xFF38383A),
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
                        ? const Color(0xFF007AFF)
                        : const Color(0xFF8E8E93),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provider.isCustomized
                          ? _personalizationSummary(provider)
                          : 'Personalize with a name, detail, or vibe',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        color: provider.isCustomized
                            ? Colors.white
                            : const Color(0xFF8E8E93),
                        fontWeight: provider.isCustomized
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    size: 14,
                    color: Color(0xFF636366),
                  ),
                ]),
              ),
            ),
          ),

          // ----------------------------------------------------------------
          // History navigation
          // ----------------------------------------------------------------
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
                      ? 'Generating...'
                      : '#${provider.historyIndex + 1} of ${provider.historyCount}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF8E8E93),
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

          // ----------------------------------------------------------------
          // Message card
          // ----------------------------------------------------------------
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

          // ----------------------------------------------------------------
          // Swipe hint
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(
                CupertinoIcons.arrow_left_right,
                color: Color(0xFF636366),
                size: 12,
              ),
              const SizedBox(width: 6),
              Text(
                'Swipe left for new · Swipe right for previous',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: const Color(0xFF636366),
                ),
              ),
            ]),
          ),

          // ----------------------------------------------------------------
          // Action buttons — row 1
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(children: [
              _ActionBtn(
                icon: CupertinoIcons.sparkles,
                label: provider.state == GeneratorState.loading
                    ? 'Crafting...'
                    : 'New Line',
                gradient: cat.gradientColors,
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
                    ? 'Saved'
                    : 'Save',
                enabled: provider.currentMessage.isNotEmpty &&
                    provider.state == GeneratorState.success,
                onTap: () async {
                  await provider.toggleFavorite();
                  if (context.mounted) {
                    final wasSaved =
                    provider.isFavorited(provider.currentMessage);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(children: [
                          Icon(
                            wasSaved
                                ? CupertinoIcons.heart_slash
                                : CupertinoIcons.heart_fill,
                            color: Colors.white,
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            wasSaved
                                ? 'Removed from favorites'
                                : 'Saved to favorites',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.white),
                          ),
                        ]),
                        duration: 1800.ms,
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        backgroundColor: const Color(0xFF2C2C2E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  }
                },
              ),
            ]),
          ),

          // ----------------------------------------------------------------
          // Action buttons — row 2
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(children: [
              _ActionBtn(
                icon: CupertinoIcons.doc_on_doc,
                label: 'Copy',
                enabled: provider.currentMessage.isNotEmpty &&
                    provider.state == GeneratorState.success,
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: provider.currentMessage));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(children: [
                        const Icon(CupertinoIcons.checkmark_circle,
                            color: Colors.white, size: 15),
                        const SizedBox(width: 8),
                        Text('Copied to clipboard',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.white)),
                      ]),
                      duration: 1800.ms,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      backgroundColor: const Color(0xFF2C2C2E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              _ActionBtn(
                icon: CupertinoIcons.share,
                label: 'Share',
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

// ---------------------------------------------------------------------------
// Message card
// ---------------------------------------------------------------------------

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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xFF1C1C1E),
        border: Border.all(
          color: cat.gradientColors.last.withValues(alpha: 0.28),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: cat.gradientColors.last.withValues(alpha: 0.15),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(children: [
        // Decorative quotation mark — uses category accent color
        Positioned(
          top: 12, left: 16,
          child: Icon(
            CupertinoIcons.quote_bubble,
            size: 52,
            color: cat.gradientColors.last.withValues(alpha: 0.09),
          ),
        ),
        // Subtle radial glow bottom-right
        Positioned(
          bottom: 0, right: 0,
          child: Container(
            width: 140, height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                cat.gradientColors.last.withValues(alpha: 0.07),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        // Content
        Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
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
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 40,
            color: Color(0xFF8E8E93),
          ),
          const SizedBox(height: 14),
          Text(
            'Something went wrong',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.errorMessage,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: const Color(0xFF8E8E93),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "New Line" to try again',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: const Color(0xFF636366),
            ),
          ),
        ]);

      case GeneratorState.success:
        return AnimatedSwitcher(
          duration: 350.ms,
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
            style: GoogleFonts.inter(
              fontSize: 18,
              color: Colors.white,
              height: 1.65,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        );

      default:
        return Text(
          'Tap "New Line" to begin',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: const Color(0xFF8E8E93),
          ),
          textAlign: TextAlign.center,
        );
    }
  }
}

// ---------------------------------------------------------------------------
// History navigation button
// ---------------------------------------------------------------------------

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
        opacity: enabled ? 1.0 : 0.28,
        duration: 200.ms,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            border: Border.all(
              color: const Color(0xFF38383A),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF8E8E93), size: 18),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Action button
// ---------------------------------------------------------------------------

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
          duration: 200.ms,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              gradient: isPrimary && gradient != null
                  ? LinearGradient(colors: gradient!)
                  : null,
              color: isPrimary ? null : const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isPrimary
                    ? Colors.transparent
                    : const Color(0xFF38383A),
                width: 0.5,
              ),
              boxShadow: isPrimary
                  ? [
                BoxShadow(
                  color: (gradient?.last ?? const Color(0xFF007AFF))
                      .withValues(alpha: 0.28),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
                  : null,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                icon,
                color: isPrimary ? Colors.white : const Color(0xFF8E8E93),
                size: 21,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  color: isPrimary ? Colors.white : const Color(0xFF8E8E93),
                  fontWeight:
                  isPrimary ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}