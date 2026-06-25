import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import 'generator_screen.dart';
import 'favorites_screen.dart';
import 'mood_mixer_screen.dart';

// ---------------------------------------------------------------------------
// Apple-style design tokens (local — mirrors app_theme.dart conventions)
//
//   Background       #000000 / #1C1C1E   iOS primary / elevated surface
//   Label primary    #FFFFFF
//   Label secondary  #EBEBF5 @ 60% → #8E8E93
//   Separator        #38383A
//   System blue      #007AFF             primary action / tint
//   System blue dark #0051A8             gradient deep stop
//   Card surface     #1C1C1E
// ---------------------------------------------------------------------------

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favCount = context.watch<FlirtProvider>().favorites.length;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(children: [
          // ----------------------------------------------------------------
          // Navigation bar — Apple large-title style
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
            child: Row(children: [
              Text(
                'FlirtMate',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
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
          // Large title block
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Choose Your',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF8E8E93),
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Flirt Style',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.8,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'A fresh line for every mood, every time',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ]),
          ),

          // ----------------------------------------------------------------
          // Mood Mixer entry point — system blue, no pink/purple
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MoodMixerScreen())),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0051A8), Color(0xFF007AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withValues(alpha: 0.30),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      CupertinoIcons.slider_horizontal_3,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(
                        'Mood Mixer',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        'Blend any 2 styles into something new',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.70),
                        ),
                      ),
                    ]),
                  ),
                  const Icon(
                    CupertinoIcons.chevron_right,
                    color: Colors.white54,
                    size: 16,
                  ),
                ]),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05),

          // ----------------------------------------------------------------
          // Category grid
          // ----------------------------------------------------------------
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.88,
              ),
              itemCount: kCategories.length,
              itemBuilder: (ctx, i) => _CategoryCard(
                category: kCategories[i],
                index: i,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category card
// ---------------------------------------------------------------------------

class _CategoryCard extends StatefulWidget {
  final FlirtCategory category;
  final int index;
  const _CategoryCard({required this.category, required this.index});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 150.ms);
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final isAi = context.watch<FlirtProvider>().isAiAvailable;

    return AnimatedBuilder(
      animation: _scale,
      builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) {
          _ctrl.reverse();
          context.read<FlirtProvider>().selectCategory(cat);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const GeneratorScreen()));
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: cat.gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.07),
            ),
            boxShadow: [
              BoxShadow(
                color: cat.gradientColors.last.withValues(alpha: 0.28),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(children: [
            // Subtle top-edge shine (Apple card convention)
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.10),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Mode badge — SF-style pill, honest about AI availability
            Positioned(
              top: 10, right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(
                    isAi
                        ? CupertinoIcons.sparkles
                        : CupertinoIcons.infinite,
                    color: Colors.white70,
                    size: 9,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    isAi ? 'AI' : '∞',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ]),
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon in a frosted pill — replaces emoji
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      cat.icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    cat.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cat.tagline,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.60),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.description,
                    style: GoogleFonts.inter(
                      fontSize: 10.5,
                      color: Colors.white.withValues(alpha: 0.50),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    ).animate(delay: (widget.index * 40).ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.12, duration: 400.ms, curve: Curves.easeOut);
  }
}