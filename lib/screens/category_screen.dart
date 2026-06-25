import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/flirt_category.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';
import 'generator_screen.dart';
import 'favorites_screen.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favCount = context.watch<FlirtProvider>().favorites.length;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF110D1E), AppTheme.background, Color(0xFF08080F)],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(children: [
                GradientText('FlirtMate',
                  colors: const [AppTheme.primary, AppTheme.primaryLight],
                  style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w700),
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

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Choose Your', style: GoogleFonts.lato(
                  fontSize: 14, color: AppTheme.textMuted, letterSpacing: 1.5,
                  fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Flirt Style', style: GoogleFonts.playfairDisplay(
                  fontSize: 32, fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
                const SizedBox(height: 6),
                Text('AI crafts infinite unique lines for every mood',
                  style: GoogleFonts.lato(fontSize: 13, color: AppTheme.textMuted)),
              ]),
            ),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12,
                  childAspectRatio: 0.88,
                ),
                itemCount: kCategories.length,
                itemBuilder: (ctx, i) => _CategoryCard(
                  category: kCategories[i], index: i,
                ),
              ),
            ),
          ]),
        ),
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

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 150.ms);
    _scale = Tween<double>(begin: 1.0, end: 0.95)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
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
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [BoxShadow(
              color: cat.gradientColors.last.withOpacity(0.35),
              blurRadius: 16, offset: const Offset(0, 6),
            )],
          ),
          child: Stack(children: [
            // Shine overlay
            Positioned(top: 0, left: 0, right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.white.withOpacity(0.12), Colors.transparent],
                  ),
                ),
              ),
            ),
            // AI badge
            Positioned(top: 10, right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('∞ AI', style: GoogleFonts.lato(
                  fontSize: 9, color: Colors.white70, fontWeight: FontWeight.w800,
                  letterSpacing: 0.8)),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat.emoji, style: const TextStyle(fontSize: 34)),
                  const Spacer(),
                  Text(cat.name, style: GoogleFonts.playfairDisplay(
                    fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 3),
                  Text(cat.tagline, style: GoogleFonts.lato(
                    fontSize: 11, color: Colors.white60, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5),
                  Text(cat.description, style: GoogleFonts.lato(
                    fontSize: 10.5, color: Colors.white54, height: 1.3)),
                ],
              ),
            ),
          ]),
        ),
      ),
    ).animate(delay: (widget.index * 40).ms)
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.15, duration: 400.ms, curve: Curves.easeOut);
  }
}
