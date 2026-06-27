import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';
import 'animated_gradient_button.dart';
import 'theme_selector_sheet.dart';
import 'language_selector_sheet.dart';

Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _SettingsSheet(),
  );
}

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet();

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  final TextEditingController _feedbackNameCtrl = TextEditingController();
  final TextEditingController _feedbackEmailCtrl = TextEditingController();
  final TextEditingController _feedbackCommentsCtrl = TextEditingController();
  bool _feedbackSubmitted = false;

  @override
  void dispose() {
    _feedbackNameCtrl.dispose();
    _feedbackEmailCtrl.dispose();
    _feedbackCommentsCtrl.dispose();
    super.dispose();
  }

  void _submitFeedback(FlirtProvider provider) async {
    if (_feedbackCommentsCtrl.text.trim().isNotEmpty) {
      HapticFeedback.mediumImpact();
      await provider.sendAppFeedback(
        _feedbackNameCtrl.text.isNotEmpty ? _feedbackNameCtrl.text : "Anonymous",
        _feedbackEmailCtrl.text.isNotEmpty ? _feedbackEmailCtrl.text : "N/A",
        _feedbackCommentsCtrl.text,
      );
      if (mounted) {
        setState(() {
          _feedbackSubmitted = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlirtProvider>();

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
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Settings',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
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
                    Text(
                      'Manage preferences, feedback, and guidelines.',
                      style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),

                    // --- GENERAL CONFIGS ---
                    _sectionLabel("PREFERENCES"),
                    const SizedBox(height: 8),
                    _buildSettingsRow(
                      context,
                      label: "Change Theme",
                      icon: LucideIcons.palette,
                      onTap: () {
                        Navigator.pop(context);
                        showThemeSelector(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingsRow(
                      context,
                      label: "Change Language",
                      icon: LucideIcons.globe,
                      onTap: () {
                        Navigator.pop(context);
                        showLanguageSelector(context);
                      },
                    ),
                    const SizedBox(height: 24),

                    // --- THE WINGMAN'S CODE ---
                    _sectionLabel("THE WINGMAN'S CODE"),
                    const SizedBox(height: 8),
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCodeRow("Authentic Connections", "FlirtMate is designed to spark genuine interactions. Use lines to break tension, but speak with your own voice."),
                          const SizedBox(height: 12),
                          _buildCodeRow("Respect Boundaries", "Always adapt generation settings respectfully. Stop messaging immediately if the other party suggests discomfort."),
                          const SizedBox(height: 12),
                          _buildCodeRow("No Deceptive Rizz", "Avoid manipulative strategies. Social chemistry works best when founded on honesty and fun."),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- FEEDBACK SECTION ---
                    _sectionLabel("FEEDBACK"),
                    const SizedBox(height: 8),
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      borderRadius: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Found a bug or have an idea to improve the AI's personality? Send it directly to our dev team.",
                            style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                          ),
                          const SizedBox(height: 16),
                          if (!_feedbackSubmitted) ...[
                            TextField(
                              controller: _feedbackNameCtrl,
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                              decoration: _inputDecoration("Your name (Optional)"),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _feedbackEmailCtrl,
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                              decoration: _inputDecoration("Your email address (Optional)"),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _feedbackCommentsCtrl,
                              maxLines: 3,
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                              decoration: _inputDecoration("What can we build next?..."),
                            ),
                            const SizedBox(height: 16),
                            AnimatedGradientButton(
                              height: 48,
                              onTap: () => _submitFeedback(provider),
                              child: provider.state == GeneratorState.loading
                                  ? const CupertinoActivityIndicator(color: Colors.white)
                                  : Text(
                                      "SUBMIT FEEDBACK",
                                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
                                    ),
                            ),
                          ] else ...[
                            Row(
                              children: [
                                const Icon(LucideIcons.checkCircle, color: AppTheme.emeraldGreen, size: 20),
                                const SizedBox(width: 10),
                                Text(
                                  "Feedback sent. Thank you!",
                                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.emeraldGreen, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppTheme.textMuted,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      );

  Widget _buildSettingsRow(BuildContext context, {required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        borderRadius: 16,
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 18),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(LucideIcons.chevronRight, color: Colors.white24, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeRow(String title, String body) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("•", style: TextStyle(color: AppTheme.neonPink, fontSize: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 2),
              Text(body, style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.02),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0)),
    );
  }
}
