import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';

// ---------------------------------------------------------------------------
// Apple-style design tokens
//   Background        #000000
//   Elevated surface  #1C1C1E
//   Card border       #38383A
//   Label primary     #FFFFFF
//   Label secondary   #8E8E93
//   Separator         #38383A
//   System blue       #007AFF
//   Destructive red   #FF3B30  (iOS system red — delete only)
// ---------------------------------------------------------------------------

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
      backgroundColor: const Color(0xFF000000),
      body: SafeArea(
        child: Column(children: [
          // ----------------------------------------------------------------
          // Navigation bar
          // ----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 20, 0),
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
              Text(
                'Favorites',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
              const Spacer(),
              if (favorites.isNotEmpty)
                Text(
                  '${favorites.length} saved',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
            ]),
          ),

          const SizedBox(height: 8),

          // ----------------------------------------------------------------
          // Content
          // ----------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// Group header + list of items for one category
// ---------------------------------------------------------------------------

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
            Icon(icon, size: 15, color: const Color(0xFF8E8E93)),
            const SizedBox(width: 6),
            Text(
              catName.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8E8E93),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${items.length}',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: const Color(0xFF636366),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Divider(color: Color(0xFF38383A), thickness: 0.5),
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

// ---------------------------------------------------------------------------
// Individual favorite card — swipe-to-delete + action buttons
// ---------------------------------------------------------------------------

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
          color: const Color(0xFFFF3B30).withValues(alpha: 0.15),
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
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF38383A),
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 10, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Quote icon — replaces 💬 emoji
            const Icon(
              CupertinoIcons.text_quote,
              size: 15,
              color: Color(0xFF636366),
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
                      color: Colors.white,
                      height: 1.55,
                    ),
                  ),
                  // Arc stage label (e.g. "Follow-up") if present
                  if (item.arcStageLabel != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.arcStageLabel!,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: const Color(0xFF007AFF),
                          fontWeight: FontWeight.w500,
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
                            color: Colors.white, size: 15),
                        const SizedBox(width: 8),
                        Text('Copied',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: Colors.white)),
                      ]),
                      duration: 1500.ms,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      backgroundColor: const Color(0xFF2C2C2E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
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
                color: const Color(0xFFFF3B30).withValues(alpha: 0.55),
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

// ---------------------------------------------------------------------------
// Tappable icon button
// ---------------------------------------------------------------------------

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
      color: color ?? const Color(0xFF8E8E93),
    ),
  );
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Animated heart icon — replaces 💔 emoji
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            CupertinoIcons.heart_slash,
            size: 38,
            color: Color(0xFF636366),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(
            begin: 0.92,
            end: 1.05,
            duration: 1600.ms,
            curve: Curves.easeInOut),

        const SizedBox(height: 24),

        Text(
          'No favorites yet',
          style: GoogleFonts.inter(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Generate lines and tap the heart\nto save your favorites here.',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF8E8E93),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}