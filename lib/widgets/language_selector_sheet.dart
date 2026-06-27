import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/localization_service.dart';

void showLanguageSelector(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _LanguageSelectorSheet(),
  );
}

class _LanguageSelectorSheet extends StatelessWidget {
  const _LanguageSelectorSheet();

  @override
  Widget build(BuildContext context) {
    final langProvider = context.watch<LanguageProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    final languages = [
      {'id': AppLanguage.en, 'name': 'English', 'native': 'English'},
      {'id': AppLanguage.ne, 'name': 'Nepali', 'native': 'नेपाली'},
      {'id': AppLanguage.hi, 'name': 'Hindi', 'native': 'हिंदी'},
      {'id': AppLanguage.es, 'name': 'Spanish', 'native': 'Español'},
      {'id': AppLanguage.zh, 'name': 'Chinese', 'native': '简体中文'},
      {'id': AppLanguage.ja, 'name': 'Japanese', 'native': '日本語'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14171C), // Matte Charcoal per requirement
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
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 24),
          Text('App Language',
              style: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Select your preferred interface language.', style: TextStyle(color: Color(0xFF8E95A0), fontSize: 13)),
          const SizedBox(height: 24),
          
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (ctx, i) {
                final lang = languages[i];
                final isSelected = langProvider.currentLanguage == lang['id'];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () {
                      langProvider.setLanguage(lang['id'] as AppLanguage);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white.withValues(alpha: 0.03) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFE2E5E9) : Colors.white.withValues(alpha: 0.05),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(lang['native'] as String,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: isSelected ? const Color(0xFFE2E5E9) : const Color(0xFF8E95A0),
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              )),
                          const Spacer(),
                          if (isSelected)
                            const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Color(0xFFE2E5E9), size: 18),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
