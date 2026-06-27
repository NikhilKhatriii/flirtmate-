import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../providers/flirt_provider.dart';
import '../models/vibe.dart';
import '../theme/app_theme.dart';
import '../providers/language_provider.dart';
import 'animated_gradient_button.dart';

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
  const _PersonalizeSheet({required this.initialName, required this.initialTrait, required this.initialVibeId});
  @override State<_PersonalizeSheet> createState() => _PersonalizeSheetState();
}

class _PersonalizeSheetState extends State<_PersonalizeSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _traitCtrl;
  late final TextEditingController _incomingCtrl;
  late final TextEditingController _ageCtrl;
  late final TextEditingController _countryCtrl;
  
  late String _vibeId;
  late String _datingApp;
  late String _relStage;
  late String _commStyle;
  late String _loveLang;
  late String _personality;
  late String _humor;

  @override
  void initState() {
    super.initState();
    final p = context.read<FlirtProvider>();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _traitCtrl = TextEditingController(text: widget.initialTrait);
    _incomingCtrl = TextEditingController(text: p.incomingMessage);
    _ageCtrl = TextEditingController(text: p.userAge);
    _countryCtrl = TextEditingController(text: p.userCountry);

    _vibeId = widget.initialVibeId;
    _datingApp = p.datingApp;
    _relStage = p.relationshipStage;
    _commStyle = p.communicationStyle;
    _loveLang = p.loveLanguage;
    _personality = p.introvertExtrovert;
    _humor = p.humorType;
  }

  @override 
  void dispose() { 
    _nameCtrl.dispose(); 
    _traitCtrl.dispose(); 
    _incomingCtrl.dispose(); 
    _ageCtrl.dispose(); 
    _countryCtrl.dispose(); 
    super.dispose(); 
  }

  void _save() {
    HapticFeedback.mediumImpact();
    final lp = context.read<LanguageProvider>();
    final provider = context.read<FlirtProvider>();
    
    // Save standard profile fields
    provider.setPersonalization(
      name: _nameCtrl.text, 
      trait: _traitCtrl.text, 
      incoming: _incomingCtrl.text,
    );
    provider.setVibe(_vibeId);

    // Save advanced memory parameters
    provider.updateAdvancedMemory(
      age: _ageCtrl.text,
      country: _countryCtrl.text,
      datingApp: _datingApp,
      relationshipStage: _relStage,
      communicationStyle: _commStyle,
      loveLanguage: _loveLang,
      introvertExtrovert: _personality,
      humorType: _humor,
    );

    Navigator.pop(context);
    provider.generateLine(languageCode: lp.currentLanguage.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.background, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      height: MediaQuery.of(context).size.height * 0.85,
      child: SafeArea(
        child: Column(
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Conversation Context', style: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                IconButton(
                  icon: const Icon(LucideIcons.x, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Configure context to match their exact social signature.', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary)),
                    
                    const SizedBox(height: 24),
                    _sectionLabel("Core Details"),
                    _PersonalizeField(controller: _nameCtrl, hint: 'e.g. Maya', icon: LucideIcons.user, label: "Name"),
                    
                    const SizedBox(height: 14),
                    _sectionLabel("Reply Context"),
                    _PersonalizeField(controller: _incomingCtrl, hint: 'Paste message they sent here...', icon: LucideIcons.cornerDownLeft, isPasteable: true, label: "Their message"),
                    
                    const SizedBox(height: 14),
                    _sectionLabel("Interests / Quirks"),
                    _PersonalizeField(controller: _traitCtrl, hint: 'e.g. loves hiking, plays guitar', icon: LucideIcons.sparkles, label: "Interests / Quirks"),
                    
                    const SizedBox(height: 20),
                    _sectionLabel("Desired Vibe / Mood"),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: kVibes.map((v) {
                        final sel = v.id == _vibeId;
                        return GestureDetector(
                          onTap: () { HapticFeedback.selectionClick(); setState(() => _vibeId = v.id); },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? AppTheme.royalPurple.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: sel ? AppTheme.royalPurple : Colors.white.withValues(alpha: 0.08)),
                            ),
                            child: Text(v.label, style: GoogleFonts.inter(fontSize: 12, color: sel ? Colors.white : AppTheme.textSecondary, fontWeight: sel ? FontWeight.w700 : FontWeight.w500)),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),
                    Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: Text(
                          "Advanced AI Options",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        iconColor: Theme.of(context).primaryColor,
                        collapsedIconColor: Colors.white54,
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(top: 8),
                        children: [
                          _PersonalizeField(controller: _ageCtrl, hint: 'e.g. 24', icon: LucideIcons.calendar, label: "Age", inputType: TextInputType.number),
                          const SizedBox(height: 14),
                          _PersonalizeField(controller: _countryCtrl, hint: 'e.g. United Kingdom', icon: LucideIcons.mapPin, label: "Country / Location"),
                          const SizedBox(height: 20),
                          _sectionLabel("Dating Platform"),
                          _buildDropdown(
                            value: _datingApp,
                            items: ["Tinder", "Bumble", "Hinge", "Grindr", "Offline / Face-to-Face", "Instagram", "WhatsApp"],
                            onChanged: (val) => setState(() => _datingApp = val!),
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel("Stage of Connection"),
                          _buildDropdown(
                            value: _relStage,
                            items: ["Strangers", "Just chatting", "First date planned", "Dating"],
                            onChanged: (val) => setState(() => _relStage = val!),
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel("Communication Style"),
                          _buildDropdown(
                            value: _commStyle,
                            items: ["Direct", "Playful", "Witty", "Sarcastic", "Sweet"],
                            onChanged: (val) => setState(() => _commStyle = val!),
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel("Love Language"),
                          _buildDropdown(
                            value: _loveLang,
                            items: ["Words of affirmation", "Quality time", "Physical touch", "Acts of service", "Receiving gifts"],
                            onChanged: (val) => setState(() => _loveLang = val!),
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel("Personality Matrix"),
                          _buildDropdown(
                            value: _personality,
                            items: ["Introverted", "Extroverted", "Ambivert"],
                            onChanged: (val) => setState(() => _personality = val!),
                          ),
                          const SizedBox(height: 20),
                          _sectionLabel("Humor Signature"),
                          _buildDropdown(
                            value: _humor,
                            items: ["Dry / Sarcastic", "Witty", "Goofy", "Dark"],
                            onChanged: (val) => setState(() => _humor = val!),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16), 
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Cancel', style: GoogleFonts.inter(color: AppTheme.textSecondary, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AnimatedGradientButton(
                  onTap: _save,
                  borderRadius: 16,
                  height: 52,
                  child: Text(
                    'Save and Craft Rizz',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        child: Text(text, style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
      );

  Widget _buildDropdown({required String value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.surface,
          style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
          icon: const Icon(LucideIcons.chevronDown, color: AppTheme.textSecondary, size: 16),
          onChanged: onChanged,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        ),
      ),
    );
  }
}

class _PersonalizeField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPasteable;
  final String label;
  final TextInputType inputType;

  const _PersonalizeField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPasteable = false,
    required this.label,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: AppTheme.textMuted, fontSize: 13),
        floatingLabelStyle: TextStyle(color: Theme.of(context).primaryColor),
        hintText: hint,
        hintStyle: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
        prefixIcon: Icon(icon, color: AppTheme.textMuted, size: 16),
        suffixIcon: isPasteable
            ? IconButton(
                icon: const Icon(LucideIcons.clipboard, size: 16),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  final d = await Clipboard.getData(Clipboard.kTextPlain);
                  if (d != null && d.text != null) {
                    HapticFeedback.lightImpact();
                    controller.text = d.text!;
                  }
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white10)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.royalPurple, width: 1.2)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.white10)),
      ),
    );
  }
}
