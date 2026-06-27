import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/satisfying_copy_button.dart';

class DailyFeedScreen extends StatefulWidget {
  const DailyFeedScreen({super.key});

  @override
  State<DailyFeedScreen> createState() => _DailyFeedScreenState();
}

class _DailyFeedScreenState extends State<DailyFeedScreen> {
  bool _challengeCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FlirtProvider>();
      if (provider.dailyFeedData == null) {
        provider.runDailyFeedLoad();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlirtProvider>();
    final data = provider.dailyFeedData;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(provider),
            Expanded(
              child: provider.state == GeneratorState.loading && data == null
                  ? _buildLoader()
                  : data == null
                      ? _buildErrorState(provider)
                      : _buildFeedList(data),
            ),
            const SizedBox(height: 100), // clear navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(FlirtProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.emeraldGreen, AppTheme.electricBlue],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.calendar, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DAILY RIZZ FEED",
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textMuted,
                      letterSpacing: 2.0,
                    ),
                  ),
                  Text(
                    "Today's Wingman Directives",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(LucideIcons.refreshCw, size: 18, color: AppTheme.textSecondary),
            onPressed: () {
              HapticFeedback.lightImpact();
              provider.runDailyFeedLoad();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.electricBlue),
          SizedBox(height: 20),
          Text(
            "Fetching today's social directives...",
            style: TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(FlirtProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.wifiOff, size: 48, color: AppTheme.textMuted),
            const SizedBox(height: 16),
            Text(
              "Offline Mode",
              style: GoogleFonts.cormorantGaramond(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "Connect to internet or click below to pull cached offline daily directives.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => provider.runDailyFeedLoad(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.royalPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Retry Connection"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedList(Map<String, dynamic> data) {
    final icebreaker = data['icebreaker'] ?? "";
    final tip = data['tip'] ?? "";
    final challenge = data['challenge'] ?? "";
    final line = data['line'] ?? "";
    final compliment = data['compliment'] ?? "";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // 1. Daily Challenge (Interactive)
          _buildChallengeCard(challenge),
          const SizedBox(height: 16),

          // 2. Daily Flirting Tip
          _buildFeedCard("FLIRTING TIP OF THE DAY", tip, LucideIcons.lightbulb, AppTheme.champagneGold),
          const SizedBox(height: 16),

          // 3. Daily Icebreaker
          _buildFeedCard("DAILY ICEBREAKER QUESTION", icebreaker, LucideIcons.messageSquare, AppTheme.electricBlue),
          const SizedBox(height: 16),

          // 4. Line of the Day
          _buildCopyableFeedCard("PICKUP LINE OF THE DAY", line, LucideIcons.heart, AppTheme.neonPink),
          const SizedBox(height: 16),

          // 5. Compliment of the Day
          _buildCopyableFeedCard("COMPLIMENT OF THE DAY", compliment, LucideIcons.smile, AppTheme.royalPurple),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(String text) {
    final challengeText = text.isNotEmpty ? text : "Compliment someone today without mentioning their physical appearance.";

    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      borderColor: _challengeCompleted ? AppTheme.emeraldGreen : AppTheme.electricBlue,
      borderOpacity: _challengeCompleted ? 0.35 : 0.15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.electricBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "🔥 DAILY DIRECTIVE",
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.electricBlue, letterSpacing: 1.0),
                ),
              ),
              const Spacer(),
              if (_challengeCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.emeraldGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "✓ COMPLETED",
                    style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.emeraldGreen, letterSpacing: 1.0),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  HapticFeedback.heavyImpact();
                  setState(() => _challengeCompleted = !_challengeCompleted);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _challengeCompleted ? AppTheme.emeraldGreen.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: _challengeCompleted ? AppTheme.emeraldGreen : Colors.white30,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _challengeCompleted ? LucideIcons.check : LucideIcons.flame,
                    color: _challengeCompleted ? AppTheme.emeraldGreen : AppTheme.electricBlue,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TODAY'S CHALLENGE",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        color: _challengeCompleted ? AppTheme.emeraldGreen : AppTheme.champagneGold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      challengeText,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _challengeCompleted ? Colors.white70 : Colors.white,
                        fontWeight: _challengeCompleted ? FontWeight.w500 : FontWeight.w700,
                        height: 1.4,
                        decoration: _challengeCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05);
  }

  Widget _buildFeedCard(String label, String content, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: color, letterSpacing: 1.0),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05);
  }

  Widget _buildCopyableFeedCard(String label, String content, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: color, letterSpacing: 1.0),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              color: Colors.white,
              height: 1.35,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          SatisfyingCopyButton(
            textToCopy: content,
            label: "Copy Line",
            height: 44,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.05);
  }
}
