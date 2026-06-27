import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/typewriter_text.dart';
import 'dart:async';
import '../providers/flirt_provider.dart';
import '../providers/language_provider.dart';
import '../services/analytics_service.dart';
import '../theme/app_theme.dart';
import '../data/arc_lines.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_gradient_button.dart';
import '../widgets/personalize_sheet.dart';
import 'favorites_screen.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});
  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> with TickerProviderStateMixin {
  late AnimationController _msgCtrl;
  String _thinkingMsg = "✨ Reading the conversation...";
  Timer? _thinkingTimer;
  final List<String> _thinkingMessages = [
    "✨ Reading the conversation...",
    "🧠 Understanding their personality...",
    "💬 Crafting something natural...",
    "❤️ Adding a little charm...",
  ];

  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView('generator_screen');
    _msgCtrl = AnimationController(vsync: this, duration: 400.ms);
    _startThinking();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final lp = context.read<LanguageProvider>();
      context.read<FlirtProvider>().generateLine(languageCode: lp.currentLanguage.name);
    });
  }

  void _startThinking() {
    int i = 0;
    _thinkingTimer = Timer.periodic(1500.ms, (timer) {
      if (!mounted) return;
      setState(() => _thinkingMsg = _thinkingMessages[i % _thinkingMessages.length]);
      i++;
    });
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    _thinkingTimer?.cancel();
    super.dispose();
  }

  void _generate() {
    HapticFeedback.mediumImpact();
    final lp = context.read<LanguageProvider>();
    _msgCtrl.forward(from: 0).then((_) {
      context.read<FlirtProvider>().generateLine(languageCode: lp.currentLanguage.name);
      _msgCtrl.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    final provider = context.watch<FlirtProvider>();
    final cat = provider.selectedCategory;
    if (cat == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, provider, lp),
            _buildArcStageSelector(provider, lp),
            _buildPersonalizationBar(provider, lp),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: provider.state == GeneratorState.loading
                    ? _buildThinkingState()
                    : _buildMainContent(provider, lp, cat),
              ),
            ),
            _buildBottomActions(provider, lp),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, FlirtProvider provider, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(12),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: const Icon(LucideIcons.chevronLeft, color: Colors.white, size: 24),
          ),
          const Spacer(),
          Column(
            children: [
              Text(lp.translate(provider.selectedCategory!.id).toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 2.0)),
              Text("PREMIUM SELECTION", style: GoogleFonts.inter(fontSize: 10, color: Theme.of(context).primaryColor.withValues(alpha: 0.5))),
            ],
          ),
          const Spacer(),
          CupertinoButton(
            padding: const EdgeInsets.all(12),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
            child: const Icon(LucideIcons.heart, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildArcStageSelector(FlirtProvider provider, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: ArcStage.values.map((stage) {
          final sel = provider.arcStage == stage;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                provider.setArcStage(stage);
              },
              child: AnimatedContainer(
                duration: 200.ms,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: sel ? Theme.of(context).primaryColor.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: sel ? Theme.of(context).primaryColor.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05)),
                ),
                child: Column(
                  children: [
                    Icon(
                      stage == ArcStage.opener
                          ? LucideIcons.messageSquare
                          : stage == ArcStage.followUp
                              ? LucideIcons.arrowUpRight
                              : LucideIcons.heart,
                      size: 16,
                      color: sel ? Theme.of(context).primaryColor : AppTheme.textMuted,
                    ),
                    const SizedBox(height: 4),
                    Text(lp.translate('stage_${stage.name}'),
                        style: GoogleFonts.inter(fontSize: 10, color: sel ? Colors.white : AppTheme.textSecondary, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPersonalizationBar(FlirtProvider provider, LanguageProvider lp) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          showPersonalizeSheet(context);
        },
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 16,
          child: Row(
            children: [
              Icon(LucideIcons.sliders, size: 16, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  provider.isCustomized ? _personalizationSummary(provider, lp) : "Personalize for better accuracy",
                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 14, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThinkingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(radius: 14, color: Theme.of(context).primaryColor),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: 400.ms,
            child: Text(
              _thinkingMsg,
              key: ValueKey(_thinkingMsg),
              style: GoogleFonts.inter(fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(FlirtProvider provider, LanguageProvider lp, dynamic cat) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildVariantTabs(provider),
          const SizedBox(height: 20),
          _buildCoachInsight(provider),
        ],
      ),
    );
  }

  Widget _buildVariantTabs(FlirtProvider provider) {
    final Map<String, String> variants = {
      "MAIN": provider.currentMessage,
      if (provider.directVariant.isNotEmpty) "SHORT": provider.directVariant,
      if (provider.romanticVariant.isNotEmpty) "ROMANTIC": provider.romanticVariant,
      if (provider.playfulVariant.isNotEmpty) "PLAYFUL": provider.playfulVariant,
      if (provider.confidentVariant.isNotEmpty) "CONFIDENT": provider.confidentVariant,
    };

    if (variants.length <= 1) {
      // If offline/fallback yields only one string, render single view
      return GlassCard(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        borderRadius: 32,
        child: SingleChildScrollView(
          child: TypewriterText(
            text: provider.currentMessage,
            style: GoogleFonts.cormorantGaramond(fontSize: 28, color: Colors.white, height: 1.35, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05);
    }

    return DefaultTabController(
      length: variants.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Colors.white,
            unselectedLabelColor: AppTheme.textMuted,
            labelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.0),
            tabs: variants.keys.map((title) => Tab(text: title)).toList(),
          ),
          const SizedBox(height: 12),
          GlassCard(
            width: double.infinity,
            borderRadius: 32,
            child: SizedBox(
              height: 200,
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: variants.values.map((text) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: SingleChildScrollView(
                        child: TypewriterText(
                          text: text,
                          style: GoogleFonts.cormorantGaramond(fontSize: 24, color: Colors.white, height: 1.35, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildCoachInsight(FlirtProvider provider) {
    final insight = provider.insight.isNotEmpty
        ? provider.insight
        : "This line leverages subtle intrigue. It shows high-status curiosity without sounding desperate, perfect for the ${provider.selectedCategory!.name} dynamic.";

    final List<String> bulletPoints = [];
    if (insight.contains('•')) {
      bulletPoints.addAll(insight.split('•').map((e) => e.trim()).where((e) => e.isNotEmpty));
    } else if (insight.contains('\n')) {
      bulletPoints.addAll(insight.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty));
    } else {
      // Split by sentence (periods followed by space, or end of string)
      final regExp = RegExp(r'(?<=[.!?])\s+');
      bulletPoints.addAll(insight.split(regExp).map((e) => e.trim()).where((e) => e.isNotEmpty));
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.compass, size: 14, color: AppTheme.champagneGold),
              const SizedBox(width: 8),
              Text("WHY THIS WORKS", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.0)),
            ],
          ),
          const SizedBox(height: 14),
          ...bulletPoints.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.checkCircle2, size: 14, color: AppTheme.emeraldGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      point,
                      style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildBottomActions(FlirtProvider provider, LanguageProvider lp) {
    final bool ok = provider.state == GeneratorState.success;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          AnimatedGradientButton(
            onTap: provider.state == GeneratorState.loading ? null : _generate,
            child: Center(
              child: Text(
                provider.state == GeneratorState.loading ? "CRAFTING..." : "NEW LINE",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSmallAction(LucideIcons.copy, "COPY", () {
                HapticFeedback.lightImpact();
                Clipboard.setData(ClipboardData(text: provider.currentMessage));
              }, enabled: ok),
              const SizedBox(width: 8),
              _buildSmallAction(LucideIcons.heart, "SAVE", () {
                HapticFeedback.mediumImpact();
                provider.toggleFavorite();
              }, enabled: ok),
              const SizedBox(width: 8),
              _buildSmallAction(LucideIcons.share, "SHARE", () {
                HapticFeedback.lightImpact();
                SharePlus.instance.share(ShareParams(text: provider.currentMessage));
              }, enabled: ok),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAction(IconData icon, String label, VoidCallback onTap, {bool enabled = true}) {
    return Expanded(
      child: Opacity(
        opacity: enabled ? 1.0 : 0.3,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: enabled ? onTap : null,
          child: GlassCard(
            height: 50,
            borderRadius: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
  if (provider.hasVibe) {
    parts.add(provider.selectedVibe.label);
  }
  return parts.join(' · ');
}
