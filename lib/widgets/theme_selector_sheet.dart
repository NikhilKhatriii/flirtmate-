import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

void showThemeSelector(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _ThemeSelectorSheet(),
  );
}

class _ThemeSelectorSheet extends StatefulWidget {
  const _ThemeSelectorSheet();

  @override
  State<_ThemeSelectorSheet> createState() => _ThemeSelectorSheetState();
}

class _ThemeSelectorSheetState extends State<_ThemeSelectorSheet> {
  late final TextEditingController _hexCtrl;

  @override
  void initState() {
    super.initState();
    final current = context.read<ThemeProvider>().customAccent;
    _hexCtrl = TextEditingController(
        text: current.toARGB32().toRadixString(16).substring(2).toUpperCase());
  }

  void _applyHex() {
    final text = _hexCtrl.text.replaceAll('#', '');
    if (text.length == 6) {
      try {
        final color = Color(int.parse('FF$text', radix: 16));
        context.read<ThemeProvider>().setCustomColor(color);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Theme Palette',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Select a luxury preset or define your own signature.',
              style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 24),
          
          // Presets
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PresetCard(
                label: 'Platinum',
                accent: const Color(0xFFE2E5E9),
                isSelected: themeProvider.currentPreset == ThemePreset.platinum,
                onTap: () => themeProvider.setPreset(ThemePreset.platinum),
              ),
              _PresetCard(
                label: 'Champagne',
                accent: const Color(0xFFE5C07B),
                isSelected: themeProvider.currentPreset == ThemePreset.champagne,
                onTap: () => themeProvider.setPreset(ThemePreset.champagne),
              ),
              _PresetCard(
                label: 'Teal',
                accent: const Color(0xFF00E5FF),
                isSelected: themeProvider.currentPreset == ThemePreset.teal,
                onTap: () => themeProvider.setPreset(ThemePreset.teal),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          const Text('CUSTOM ACCENT HEX',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white38)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _hexCtrl,
                  maxLength: 6,
                  style: GoogleFonts.firaCode(color: Colors.white),
                  decoration: InputDecoration(
                    prefixText: '# ',
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (_) => _applyHex(),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  color: themeProvider.customAccent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final String label;
  final Color accent;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetCard({required this.label, required this.accent, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 64, height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF14171C),
              border: Border.all(
                color: isSelected ? accent : Colors.white10,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected ? [BoxShadow(color: accent.withValues(alpha: 0.3), blurRadius: 12)] : null,
            ),
            child: Center(
              child: Container(
                width: 24, height: 24,
                decoration: BoxDecoration(shape: BoxShape.circle, color: accent),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.white38, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
