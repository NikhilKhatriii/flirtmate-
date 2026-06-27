import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import '../services/analytics_service.dart';
import '../widgets/glass_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String _selectedCollection = 'ALL';

  @override
  void initState() {
    super.initState();
    AnalyticsService.screenView('favorites_screen');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlirtProvider>();
    final allFavorites = provider.favorites;

    final collections = [
      {'id': 'ALL', 'name': '✨ All Saved'},
      {'id': 'romantic', 'name': '❤️ Romantic'},
      {'id': 'funny', 'name': '😂 Funny'},
      {'id': 'confident', 'name': '🔥 Confident'},
    ];

    final filteredFavorites = allFavorites.where((f) {
      if (_selectedCollection == 'ALL') return true;
      final catId = f.catId.toLowerCase();
      final catName = f.catName.toLowerCase();
      if (_selectedCollection == 'romantic') {
        return catId.contains('romantic') || catName.contains('romantic') || catId.contains('deep') || catId.contains('sweet');
      }
      if (_selectedCollection == 'funny') {
        return catId.contains('funny') || catName.contains('funny') || catId.contains('playful') || catId.contains('witty') || catId.contains('cheesy');
      }
      if (_selectedCollection == 'confident') {
        return catId.contains('confident') || catName.contains('confident') || catId.contains('bold') || catId.contains('smooth');
      }
      return true;
    }).toList();

    // Group by category
    final Map<String, List<dynamic>> grouped = {};
    for (final f in filteredFavorites) {
      grouped.putIfAbsent(f.catId, () => []).add(f);
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(children: [
          // Navigation bar
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
            child: Row(children: [
              if (Navigator.canPop(context))
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    LucideIcons.chevronLeft,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              else
                const SizedBox(width: 16),
              Text(
                'Collections',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              if (allFavorites.isNotEmpty)
                Text(
                  '${allFavorites.length} SAVED',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
            ]),
          ),

          const SizedBox(height: 12),

          // Categorization Collection Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: collections.map((col) {
                final isSel = _selectedCollection == col['id'];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedCollection = col['id'] as String);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSel ? Theme.of(context).primaryColor : Colors.white10,
                        width: isSel ? 1.5 : 1.0,
                      ),
                    ),
                    child: Text(
                      col['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                        color: isSel ? Colors.white : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          // Content
          Expanded(
            child: allFavorites.isEmpty
                ? const _EmptyState()
                : filteredFavorites.isEmpty
                    ? Center(
                        child: Text(
                          "No saved lines in this collection yet.",
                          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: grouped.keys.length,
                        itemBuilder: (ctx, i) {
                          final catId = grouped.keys.elementAt(i);
                          final items = grouped[catId]!;
                          final first = items.first;
                          return _FavoriteGroup(
                            catIconCodePoint: first.catIconCodePoint,
                            catName: first.catName,
                            items: items.cast(),
                            groupIndex: i,
                            onDelete: (id) {
                              HapticFeedback.mediumImpact();
                              provider.deleteFavorite(id);
                            },
                          );
                        },
                      ),
          ),
        ]),
      ),
    );
  }
}

class _FavoriteGroup extends StatelessWidget {
  final int catIconCodePoint;
  final String catName;
  final List<dynamic> items;
  final int groupIndex;
  final Function(String) onDelete;

  const _FavoriteGroup({
    required this.catIconCodePoint,
    required this.catName,
    required this.items,
    required this.groupIndex,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: non_const_argument_for_const_parameter
    final icon = IconData(catIconCodePoint, fontFamily: 'LucideIcons', fontPackage: 'lucide_icons');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
          child: Row(children: [
            Icon(icon, size: 14, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              catName.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${items.length}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(color: Colors.white10, thickness: 0.5),
            ),
          ]),
        ),

        // Items
        ...items.asMap().entries.map((e) => _FavoriteItem(
              item: e.value,
              index: e.key,
              groupIndex: groupIndex,
              onDelete: onDelete,
            )),
      ],
    ).animate(delay: (groupIndex * 60).ms).fadeIn(duration: 350.ms).slideY(begin: 0.1);
  }
}

class _FavoriteItem extends StatelessWidget {
  final dynamic item;
  final int index, groupIndex;
  final Function(String) onDelete;

  const _FavoriteItem({
    required this.item,
    required this.index,
    required this.groupIndex,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          LucideIcons.trash2,
          color: Color(0xFFFF3B30),
          size: 20,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(
              LucideIcons.quote,
              size: 14,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),

            // Message text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.message,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                      height: 1.55,
                    ),
                  ),
                  if (item.arcStageLabel != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.royalPurple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.royalPurple.withValues(alpha: 0.2), width: 0.5),
                      ),
                      child: Text(
                        item.arcStageLabel!.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: AppTheme.royalPurple,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action buttons
            Column(children: [
              _IconBtn(
                icon: LucideIcons.copy,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Clipboard.setData(ClipboardData(text: item.message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(children: [
                        const Icon(LucideIcons.checkCircle2, color: AppTheme.background, size: 15),
                        const SizedBox(width: 8),
                        Text('Copied to Clipboard',
                            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.background, fontWeight: FontWeight.w600)),
                      ]),
                      duration: const Duration(milliseconds: 1500),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              _IconBtn(
                icon: LucideIcons.share2,
                onTap: () {
                  HapticFeedback.lightImpact();
                  SharePlus.instance.share(ShareParams(text: item.message));
                },
              ),
              const SizedBox(height: 4),
              _IconBtn(
                icon: LucideIcons.trash2,
                color: const Color(0xFFFF3B30).withValues(alpha: 0.7),
                onTap: () => onDelete(item.id),
              ),
            ]),
          ]),
        ),
      ),
    )
        .animate(delay: ((groupIndex * 60) + (index * 40)).ms)
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.08);
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _IconBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) => CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size.square(28),
        onPressed: onTap,
        child: Icon(
          icon,
          size: 17,
          color: color ?? AppTheme.textSecondary,
        ),
      );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.02),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: const Icon(
            LucideIcons.heartCrack,
            size: 32,
            color: AppTheme.textMuted,
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(begin: 0.95, end: 1.05, duration: 1600.ms, curve: Curves.easeInOut),
        const SizedBox(height: 24),
        Text(
          'No favorites yet',
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '💬 Save your best AI lines here.\nGenerate lines and tap the heart icon.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
