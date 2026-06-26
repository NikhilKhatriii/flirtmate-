import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlirtProvider>();
    final favorites = provider.favorites;

    // Group by category
    final Map<String, List<dynamic>> grouped = {};
    for (final f in favorites) {
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
              CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                onPressed: () => Navigator.pop(context),
                child: Icon(
                  CupertinoIcons.chevron_left,
                  color: AppTheme.primary,
                  size: 20,
                ),
              ),
              Text(
                'Favorites',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              if (favorites.isNotEmpty)
                Text(
                  '${favorites.length} SAVED',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
            ]),
          ),

          const SizedBox(height: 8),

          // Content
          Expanded(
            child: favorites.isEmpty
                ? const _EmptyState()
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
                  onDelete: (id) => provider.deleteFavorite(id),
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
    final icon = switch (catIconCodePoint) {
      0xf442 => CupertinoIcons.heart,
      0xf4ac => CupertinoIcons.smiley,
      0xf4b5 => CupertinoIcons.sun_max,
      0xf433 => CupertinoIcons.game_controller,
      0xf3ee => CupertinoIcons.briefcase,
      0xf3d6 => CupertinoIcons.bolt,
      0xf451 => CupertinoIcons.leaf_arrow_circlepath,
      0xf468 => CupertinoIcons.moon,
      0xf42c => CupertinoIcons.flame,
      0xf3fb => CupertinoIcons.envelope,
      0xf495 => CupertinoIcons.square_grid_3x2,
      0xf43c => CupertinoIcons.hand_thumbsup,
      0xf460 => CupertinoIcons.mic,
      0xf4b9 => CupertinoIcons.text_quote,
      0xf480 => CupertinoIcons.rectangle_stack,
      _ => CupertinoIcons.bookmark_fill,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
          child: Row(children: [
            Icon(icon, size: 14, color: AppTheme.primary),
            const SizedBox(width: 8),
            Text(
              catName.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${items.length}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(color: AppTheme.cardBorder, thickness: 0.5),
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
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(
          CupertinoIcons.delete,
          color: Color(0xFFFF3B30),
          size: 20,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppTheme.cardBorder,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(
              CupertinoIcons.text_quote,
              size: 15,
              color: AppTheme.primary,
            ),
            const SizedBox(width: 10),

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2), width: 0.5),
                      ),
                      child: Text(
                        item.arcStageLabel!.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          color: AppTheme.primary,
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
                icon: CupertinoIcons.doc_on_doc,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: item.message));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(children: [
                        const Icon(CupertinoIcons.checkmark_circle,
                            color: AppTheme.background, size: 15),
                        const SizedBox(width: 8),
                        Text('Copied',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: AppTheme.background, fontWeight: FontWeight.w600)),
                      ]),
                      duration: 1500.ms,
                      backgroundColor: AppTheme.primary,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              _IconBtn(
                icon: CupertinoIcons.share,
                onTap: () => Share.share(item.message),
              ),
              const SizedBox(height: 4),
              _IconBtn(
                icon: CupertinoIcons.delete,
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
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.cardBorder),
          ),
          child: const Icon(
            CupertinoIcons.heart_slash,
            size: 38,
            color: AppTheme.textMuted,
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(
            begin: 0.95,
            end: 1.05,
            duration: 1600.ms,
            curve: Curves.easeInOut),

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
          'Generate lines and tap the heart\nto save your favorites here.',
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
