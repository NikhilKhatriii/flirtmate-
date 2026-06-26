import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import '../providers/language_provider.dart';
import '../theme/app_theme.dart';
import 'generator_screen.dart';

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
        _picked.removeAt(0);
        _picked.add(cat);
      }
    });
  }

  void _confirm() {
    if (_picked.length != 2) return;
    context
        .read<FlirtProvider>()
        .selectMixedCategories(_picked[0], _picked[1]);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const GeneratorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final lp = context.watch<LanguageProvider>();
    final readyToMix = _picked.length == 2;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          // Navigation bar
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
            child: Row(children: [
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () => Navigator.pop(context),
                child: Icon(
                  CupertinoIcons.chevron_left,
                  color: AppTheme.primaryPlatinum,
                  size: 20,
                ),
              ),
              Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryDark, AppTheme.primaryPlatinum],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: AppTheme.background,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  lp.translate('mood_mixer'),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
              ]),
            ]),
          ),

          // Status line
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Text(
                _picked.isEmpty
                    ? lp.translate('pick_2')
                    : _picked.length == 1
                    ? '${lp.translate('picked')} ${lp.translate(_picked[0].id)} — ${lp.translate('choose_more')}'
                    : '${lp.translate(_picked[0].id)} + ${lp.translate(_picked[1].id)} — ${lp.translate('ready_mix')}',
                key: ValueKey(_picked.length),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
            child: Text(
              lp.translate('mood_mixer_desc'),
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ),

          // Adaptive Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.95,
              ),
              itemCount: kCategories.length,
              itemBuilder: (ctx, i) {
                final cat = kCategories[i];
                final selectedIndex = _picked.indexOf(cat);
                return _MixCard(
                  category: cat,
                  index: i,
                  selectedOrder:
                  selectedIndex == -1 ? null : selectedIndex + 1,
                  onTap: () => _toggle(cat),
                );
              },
            ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: readyToMix
                    ? LinearGradient(
                  colors: [AppTheme.primaryDark, AppTheme.primaryPlatinum],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: readyToMix ? null : AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: readyToMix ? Colors.transparent : AppTheme.cardBorder,
                  width: 0.5,
                ),
                boxShadow: readyToMix
                    ? [
                  BoxShadow(
                    color: AppTheme.primaryDark.withValues(alpha: 0.30),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ]
                    : null,
              ),
              child: CupertinoButton(
                onPressed: readyToMix ? _confirm : null,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      readyToMix
                          ? CupertinoIcons.sparkles
                          : CupertinoIcons.hand_point_right,
                      size: 16,
                      color: readyToMix
                          ? AppTheme.background
                          : AppTheme.textMuted,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      readyToMix
                          ? lp.translate('mix_generate')
                          : lp.translate('pick_2_short'),
                      style: GoogleFonts.inter(
                        color: readyToMix
                            ? AppTheme.background
                            : AppTheme.textMuted,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate(target: readyToMix ? 1 : 0)
             .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.2))
             .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02), duration: 600.ms, curve: Curves.easeInOutSine),

          ),
        ]),
      ),
    );
  }
}

class _MixCard extends StatefulWidget {
  final FlirtCategory category;
  final int index;
  final int? selectedOrder;
  final VoidCallback onTap;

  const _MixCard({
    required this.category,
    required this.index,
    required this.selectedOrder,
    required this.onTap,
    super.key,
  });

  @override
  State<_MixCard> createState() => _MixCardState();
}

class _MixCardState extends State<_MixCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween<double>(begin: 1.0, end: 0.94).animate(
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
    final isSelected = widget.selectedOrder != null;

    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Theme.of(context).colorScheme.primary : AppTheme.cardBorder,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected 
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.25) 
                    : Colors.black.withValues(alpha: 0.1),
                blurRadius: isSelected ? 20 : 8,
                offset: isSelected ? const Offset(0, 8) : const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.category.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  widget.category.icon,
                  color: AppTheme.textPrimary,
                  size: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    lp.translate(widget.category.id),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lp.translate('${widget.category.id}_tagline'),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: isSelected ? Theme.of(context).colorScheme.primary : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 10, right: 10,
                child: Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.selectedOrder}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
          ]),
        ),
      ),
    ).animate(delay: (widget.index * 30).ms).fadeIn(duration: 350.ms).slideY(begin: 0.08);
  }
}
