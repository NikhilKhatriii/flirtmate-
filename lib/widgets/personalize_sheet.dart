import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/flirt_provider.dart';
import '../models/vibe.dart';
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';

Future<void> showPersonalizeSheet(BuildContext context) {
  final provider = context.read<FlirtProvider>();
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PersonalizeSheet(
      initialName: provider.targetName,
      initialTrait: provider.targetTrait,
      initialVibeId: provider.selectedVibe.id,
    ),
  );
}

class _PersonalizeSheet extends StatefulWidget {
  final String initialName;
  final String initialTrait;
  final String initialVibeId;
  const _PersonalizeSheet({
    required this.initialName,
    required this.initialTrait,
    required this.initialVibeId,
  });

  @override
  State<_PersonalizeSheet> createState() => _PersonalizeSheetState();
}

class _PersonalizeSheetState extends State<_PersonalizeSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _traitCtrl;
  late String _vibeId;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _traitCtrl = TextEditingController(text: widget.initialTrait);
    _vibeId = widget.initialVibeId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _traitCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final lp = context.read<LanguageProvider>();
    final provider = context.read<FlirtProvider>();
    provider.setPersonalization(
      name: _nameCtrl.text,
      trait: _traitCtrl.text,
    );
    provider.setVibe(_vibeId);
    Navigator.pop(context);
    provider.generateLine(languageCode: lp.currentLanguage.name);
  }

  void _clear() {
    final lp = context.read<LanguageProvider>();
    _nameCtrl.clear();
    _traitCtrl.clear();
    setState(() => _vibeId = kNoVibe.id);
    final provider = context.read<FlirtProvider>();
    provider.setPersonalization(name: '', trait: '');
    provider.setVibe(kNoVibe.id);
    Navigator.pop(context);
    provider.generateLine(languageCode: lp.currentLanguage.name);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune_rounded,
                        color: AppTheme.primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text('Make it personal', style: GoogleFonts.cormorantGaramond(
                      fontSize: 26, fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
                ]),
                const SizedBox(height: 6),
                Text(
                  'All optional — add any of these and every line adapts to fit.',
                  style: GoogleFonts.inter(fontSize: 12.5, color: AppTheme.textMuted, height: 1.4),
                ),
                const SizedBox(height: 22),

                Text('THEIR NAME', style: GoogleFonts.inter(
                    fontSize: 11, color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 8),
                _PersonalizeField(
                  controller: _nameCtrl,
                  hint: 'e.g. Maya',
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 18),

                Text('SOMETHING ABOUT THEM', style: GoogleFonts.inter(
                    fontSize: 11, color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 8),
                _PersonalizeField(
                  controller: _traitCtrl,
                  hint: 'e.g. loves hiking, plays guitar, is a nurse',
                  icon: Icons.auto_awesome_outlined,
                ),
                const SizedBox(height: 6),
                Text(
                  'Tip: phrase it so "you ___" reads naturally — like "loves hiking".',
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
                ),

                const SizedBox(height: 20),

                Text('THE VIBE', style: GoogleFonts.inter(
                    fontSize: 11, color: AppTheme.textMuted,
                    fontWeight: FontWeight.w700, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(
                  'Pick the situation — this shapes tone, not the actual words of anyone else.',
                  style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted, height: 1.3),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8, runSpacing: 8,
                  children: kVibes.map((v) {
                    final selected = v.id == _vibeId;
                    return GestureDetector(
                      onTap: () => setState(() => _vibeId = v.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppTheme.primary.withValues(alpha: 0.16)
                              : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected ? AppTheme.primary : AppTheme.cardBorder,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          if (selected)
                            const Padding(
                              padding: EdgeInsets.only(right: 6),
                              child: Icon(Icons.check_rounded,
                                  size: 14, color: AppTheme.primary),
                            ),
                          Text(v.label, style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: selected ? AppTheme.textPrimary : AppTheme.textSecondary,
                            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          )),
                        ]),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clear,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: const BorderSide(color: AppTheme.cardBorder),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Clear', style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppTheme.textSecondary, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text('Save & Generate', style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white, fontWeight: FontWeight.w700)),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonalizeField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const _PersonalizeField({
    required this.controller, required this.hint, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.inter(fontSize: 14.5, color: AppTheme.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
        prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 20),
        filled: true,
        fillColor: AppTheme.surfaceLight,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
