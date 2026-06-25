import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';

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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF150D20), AppTheme.background],
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  color: AppTheme.textSecondary,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 4),
                GradientText('❤️ Favorites',
                  colors: const [AppTheme.primary, AppTheme.primaryLight],
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22, fontWeight: FontWeight.w700)),
                const Spacer(),
                if (favorites.isNotEmpty)
                  Text('${favorites.length} saved',
                    style: GoogleFonts.lato(fontSize: 12, color: AppTheme.textMuted)),
              ]),
            ),

            const SizedBox(height: 8),

            // Content
            Expanded(
              child: favorites.isEmpty
                  ? _EmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: grouped.keys.length,
                      itemBuilder: (ctx, i) {
                        final catId = grouped.keys.elementAt(i);
                        final items = grouped[catId]!;
                        final first = items.first;
                        return _FavoriteGroup(
                          catEmoji: first.catEmoji,
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
      ),
    );
  }
}

class _FavoriteGroup extends StatelessWidget {
  final String catEmoji, catName;
  final List<dynamic> items;
  final int groupIndex;
  final Function(String) onDelete;

  const _FavoriteGroup({
    required this.catEmoji, required this.catName, required this.items,
    required this.groupIndex, required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          child: Row(children: [
            Text(catEmoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(catName, style: GoogleFonts.lato(
              fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textMuted,
              letterSpacing: 0.5)),
            const SizedBox(width: 8),
            Text('(${items.length})', style: GoogleFonts.lato(
              fontSize: 11, color: AppTheme.textMuted)),
            const Expanded(child: Divider(color: Color(0xFF2A2A4A), indent: 10)),
          ]),
        ),
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
    required this.item, required this.index,
    required this.groupIndex, required this.onDelete,
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
          color: Colors.red.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.redAccent),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('💬', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(item.message,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 14, color: AppTheme.textPrimary,
                  height: 1.55, fontStyle: FontStyle.italic)),
            ),
            const SizedBox(width: 8),
            Column(children: [
              _IconBtn(
                icon: Icons.copy_rounded,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: item.message));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('📋 Copied!'),
                    duration: 1500.ms,
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  ));
                },
              ),
              const SizedBox(height: 4),
              _IconBtn(
                icon: Icons.share_rounded,
                onTap: () => Share.share(item.message),
              ),
              const SizedBox(height: 4),
              _IconBtn(
                icon: Icons.delete_outline_rounded,
                color: Colors.redAccent.withOpacity(0.6),
                onTap: () => onDelete(item.id),
              ),
            ]),
          ]),
        ),
      ),
    ).animate(delay: ((groupIndex * 60) + (index * 40)).ms)
        .fadeIn(duration: 300.ms).slideX(begin: 0.1);
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _IconBtn({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Icon(icon, size: 18,
      color: color ?? AppTheme.textMuted.withOpacity(0.7)),
  );
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('💔', style: TextStyle(fontSize: 64))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(begin: 0.9, end: 1.1, duration: 1500.ms, curve: Curves.easeInOut),
        const SizedBox(height: 24),
        Text('No favorites yet', style: GoogleFonts.playfairDisplay(
          fontSize: 24, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Text('Generate pickup lines and tap\n🤍 to save your favorites here',
          style: GoogleFonts.lato(fontSize: 14, color: AppTheme.textMuted, height: 1.6),
          textAlign: TextAlign.center),
      ]),
    );
  }
}
