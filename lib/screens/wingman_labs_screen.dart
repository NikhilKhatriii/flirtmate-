
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/flirt_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_gradient_button.dart';
import '../widgets/satisfying_copy_button.dart';

class WingmanLabsScreen extends StatefulWidget {
  const WingmanLabsScreen({super.key});

  @override
  State<WingmanLabsScreen> createState() => _WingmanLabsScreenState();
}

class _WingmanLabsScreenState extends State<WingmanLabsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _redFlagsCtrl = TextEditingController();
  final TextEditingController _scoreCtrl = TextEditingController();
  final TextEditingController _voiceCtrl = TextEditingController();

  // Vision scanner animation state
  bool _isScanning = false;
  bool _scanComplete = false;
  String _selectedPlatform = 'WhatsApp';

  // Waveform animation control
  late AnimationController _waveformController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _redFlagsCtrl.dispose();
    _scoreCtrl.dispose();
    _voiceCtrl.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlirtProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildScreenshotTab(provider),
                  _buildRizzScorerTab(provider),
                  _buildRedFlagsTab(provider),
                  _buildVoiceRizzTab(provider),
                ],
              ),
            ),
            const SizedBox(height: 100), // Push content clear of bottom tab bar
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.neonPink, AppTheme.royalPurple],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(LucideIcons.beaker, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "WINGMAN LABS",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textMuted,
                  letterSpacing: 2.0,
                ),
              ),
              Text(
                "AI Social Chemistry Experiments",
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
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.royalPurple, AppTheme.electricBlue],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 0.5),
        tabs: const [
          Tab(text: "Visuals"),
          Tab(text: "Rate Rizz"),
          Tab(text: "Flags"),
          Tab(text: "Voice"),
        ],
      ),
    );
  }

  // --- TAB 1: SCREENSHOT ANALYZER (FLAGSHIP FEATURE) ---
  Widget _buildScreenshotTab(FlirtProvider provider) {
    final platforms = [
      {'name': 'WhatsApp', 'icon': LucideIcons.messageCircle, 'color': Color(0xFF25D366)},
      {'name': 'Instagram', 'icon': LucideIcons.camera, 'color': Color(0xFFE1306C)},
      {'name': 'Messenger', 'icon': LucideIcons.send, 'color': Color(0xFF0084FF)},
      {'name': 'Tinder', 'icon': LucideIcons.flame, 'color': Color(0xFFFE3C72)},
      {'name': 'iMessage', 'icon': LucideIcons.messageSquare, 'color': Color(0xFF34C759)},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.neonPink, AppTheme.royalPurple]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "🔥 HERO FEATURE",
                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "AI VISION MATRIX",
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.5),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Select chat app & upload screenshot. AI instantly decodes Interest, Mood, Flags & Best Reply.",
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),

          // Platform Selector Horizontal List
          Text(
            "SELECT CHAT PLATFORM",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: AppTheme.textMuted, letterSpacing: 1.0),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: platforms.map((p) {
                final isSel = _selectedPlatform == p['name'];
                final color = p['color'] as Color;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedPlatform = p['name'] as String);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSel ? color.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSel ? color : Colors.white.withValues(alpha: 0.08),
                        width: isSel ? 1.8 : 1.0,
                      ),
                      boxShadow: isSel ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, spreadRadius: 1)] : [],
                    ),
                    child: Row(
                      children: [
                        Icon(p['icon'] as IconData, size: 16, color: isSel ? Colors.white : AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          p['name'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                            color: isSel ? Colors.white : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // Upload Container / Scanner
          GestureDetector(
            onTap: _isScanning ? null : () => _simulateScan(provider),
            child: AspectRatio(
              aspectRatio: 1.7,
              child: GlassCard(
                borderRadius: 24,
                opacity: 0.05,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (!_isScanning && !_scanComplete) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.electricBlue.withValues(alpha: 0.1),
                              border: Border.all(color: AppTheme.electricBlue.withValues(alpha: 0.3)),
                            ),
                            child: const Icon(LucideIcons.uploadCloud, color: AppTheme.electricBlue, size: 36),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Upload $_selectedPlatform Screenshot",
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text("Tap to simulate instant vision analysis", style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                    ],
                    if (_isScanning) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CupertinoActivityIndicator(radius: 14, color: AppTheme.neonPink),
                          const SizedBox(height: 16),
                          Text(
                            "Analyzing $_selectedPlatform Chat Matrix...",
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text("Decoding interest, mood & flirt chemistry", style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
                        ],
                      ),
                      // Scanner Radar Line Animate
                      Positioned.fill(
                        child: Container().animate(onPlay: (c) => c.repeat()).shimmer(
                          duration: 1.5.seconds,
                          color: AppTheme.electricBlue.withValues(alpha: 0.25),
                          angle: 0.0,
                        ),
                      ),
                    ],
                    if (_scanComplete && provider.screenshotAnalysis != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.checkCircle, color: AppTheme.emeraldGreen, size: 28),
                          const SizedBox(width: 12),
                          Text(
                            "ANALYSIS COMPLETE ($_selectedPlatform)",
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          if (_scanComplete && provider.screenshotAnalysis != null) ...[
            _buildVisionResultsCard(provider.screenshotAnalysis!),
          ],
        ],
      ),
    );
  }

  void _simulateScan(FlirtProvider provider) async {
    HapticFeedback.heavyImpact();
    setState(() {
      _isScanning = true;
      _scanComplete = false;
    });

    // Simulate short network vision upload delay
    await Future.delayed(const Duration(milliseconds: 2000));
    await provider.runScreenshotAnalysis("dummy_base64_chat_data", platform: _selectedPlatform);

    if (mounted) {
      HapticFeedback.mediumImpact();
      setState(() {
        _isScanning = false;
        _scanComplete = true;
      });
    }
  }

  Widget _buildVisionResultsCard(Map<String, dynamic> data) {
    final interest = data['interest'] ?? 92;
    final confidence = data['confidence'] ?? 85;
    final mood = data['mood'] ?? "Playful & Interested";
    final flirtingLevel = data['flirting_level'] ?? "High / Spicy";
    final doubleText = data['double_text'] ?? false;
    final replyTime = data['reply_time'] ?? "Reply within 1-2 hours";
    final replyText = data['suggested_reply'] ?? data['best_response'] ?? "";
    final insight = data['insight'] ?? "";
    final platformName = data['platform'] ?? _selectedPlatform;

    final List greenFlags = data['green_flags'] is List ? data['green_flags'] : [
      {"title": "Fast Energy Matching", "desc": "Responded quickly with double emojis."},
      {"title": "Open-Ended Engagement", "desc": "Asked a question back to keep the dialogue flowing."}
    ];

    final List redFlags = data['red_flags'] is List ? data['red_flags'] : [
      {"title": "Slight Delay on Plans", "desc": "Hesitated slightly when mentioning weekend availability."}
    ];

    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform Header Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.royalPurple.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.royalPurple.withValues(alpha: 0.5)),
                ),
                child: Text(
                  "$platformName ANALYSIS",
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.0),
                ),
              ),
              const Spacer(),
              _buildMetricBadge(doubleText ? "🚩 DOUBLE TEXT RISK" : "💚 SAFE TO REPLY", doubleText ? Colors.red : AppTheme.emeraldGreen),
            ],
          ),
          const SizedBox(height: 20),

          // Dual Gauges: Interest & Confidence
          Row(
            children: [
              Expanded(child: _buildGaugeCard("INTEREST LEVEL", "$interest%", interest / 100, AppTheme.neonPink)),
              const SizedBox(width: 12),
              Expanded(child: _buildGaugeCard("CONFIDENCE", "$confidence%", confidence / 100, AppTheme.electricBlue)),
            ],
          ),
          const SizedBox(height: 16),

          // Badges: Mood & Flirting Level
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("MOOD DETECTED", style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.textMuted)),
                      const SizedBox(height: 4),
                      Text(mood, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),
                Container(height: 24, width: 1, color: Colors.white10),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("FLIRTING LEVEL", style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.textMuted)),
                      const SizedBox(height: 4),
                      Text(flirtingLevel, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.champagneGold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 32, color: Colors.white10),

          // Green Flags & Red Flags breakdown
          Text("GREEN FLAGS 💚", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.emeraldGreen, letterSpacing: 1.0)),
          const SizedBox(height: 8),
          ...greenFlags.map((f) {
            final Map item = f is Map ? f : {"title": f.toString(), "desc": ""};
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.emeraldGreen.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.emeraldGreen.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.checkCircle2, color: AppTheme.emeraldGreen, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] ?? '', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                        if ((item['desc'] ?? '').toString().isNotEmpty)
                          Text(item['desc'] ?? '', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 12),
          Text("RED FLAGS 🚩", style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.redAccent, letterSpacing: 1.0)),
          const SizedBox(height: 8),
          ...redFlags.map((f) {
            final Map item = f is Map ? f : {"title": f.toString(), "desc": ""};
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.alertTriangle, color: Colors.redAccent, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] ?? '', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white)),
                        if ((item['desc'] ?? '').toString().isNotEmpty)
                          Text(item['desc'] ?? '', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 32, color: Colors.white10),
          _buildResultRow("TIMING RECOMMENDATION", replyTime, LucideIcons.clock),
          const SizedBox(height: 14),
          _buildResultRow("STRATEGIC COACH INSIGHT", insight, LucideIcons.compass),
          const SizedBox(height: 24),

          // Suggested Reply Section
          Text(
            "RECOMMENDED MAGNETIC REPLY",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AppTheme.royalPurple.withValues(alpha: 0.2), AppTheme.electricBlue.withValues(alpha: 0.1)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.electricBlue.withValues(alpha: 0.3)),
            ),
            child: Text(
              replyText,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
          const SizedBox(height: 12),
          SatisfyingCopyButton(
            textToCopy: replyText,
            label: "Copy Reply to Clipboard",
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.05);
  }

  Widget _buildGaugeCard(String label, String valueStr, double percent, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w900, color: AppTheme.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(valueStr, style: GoogleFonts.cormorantGaramond(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
              const Spacer(),
              Icon(LucideIcons.trendingUp, size: 18, color: color),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              color: color,
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: color),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.electricBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 1.0),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 2: RIZZ SCORER (RATE MY RIZZ) ---
  Widget _buildRizzScorerTab(FlirtProvider provider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RATE MY RIZZ",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            "Paste your conversation transcript to evaluate your charm, mystery levels, and get custom pointers.",
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _scoreCtrl,
            maxLines: 4,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintText: "Me: Hey\nHer: Hey, what's up?...",
              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
              contentPadding: const EdgeInsets.all(18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppTheme.royalPurple, width: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedGradientButton(
            onTap: () {
              if (_scoreCtrl.text.isNotEmpty) {
                HapticFeedback.mediumImpact();
                provider.runRizzScorer(_scoreCtrl.text);
              }
            },
            child: provider.state == GeneratorState.loading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : Text(
                    "ANALYZE RIZZ SCORE",
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5),
                  ),
          ),
          const SizedBox(height: 24),
          if (provider.rizzScoreAnalysis != null) ...[
            _buildRizzScoreResults(provider.rizzScoreAnalysis!),
          ],
        ],
      ),
    );
  }

  Widget _buildRizzScoreResults(Map<String, dynamic> data) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "YOUR RIZZ CARD",
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 20),
          _buildScoreBar("Charm", data['charm'] ?? 50, AppTheme.neonPink),
          const SizedBox(height: 14),
          _buildScoreBar("Confidence", data['confidence'] ?? 50, AppTheme.royalPurple),
          const SizedBox(height: 14),
          _buildScoreBar("Humor", data['humor'] ?? 50, AppTheme.electricBlue),
          const SizedBox(height: 14),
          _buildScoreBar("Mystery", data['mystery'] ?? 50, AppTheme.champagneGold),
          const SizedBox(height: 14),
          _buildScoreBar("Overthinking Risk", data['overthinking'] ?? 50, Colors.redAccent),
          const Divider(height: 36, color: Colors.white10),
          Text(
            "COACH DEBRIEF",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 1.0),
          ),
          const SizedBox(height: 6),
          Text(
            data['feedback'] ?? "",
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.5, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildScoreBar(String label, int val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            Text("$val%", style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 6,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: val / 100.0,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 4)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- TAB 3: RED FLAG DETECTOR ---
  Widget _buildRedFlagsTab(FlirtProvider provider) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RED FLAG DETECTOR",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            "Analyze replies to search for warning flags or alignment metrics.",
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _redFlagsCtrl,
            maxLines: 4,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintText: "Paste recent conversation snippets here...",
              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
              contentPadding: const EdgeInsets.all(18),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: AppTheme.royalPurple, width: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedGradientButton(
            onTap: () {
              if (_redFlagsCtrl.text.isNotEmpty) {
                HapticFeedback.mediumImpact();
                provider.runRedFlagsAnalysis(_redFlagsCtrl.text);
              }
            },
            child: provider.state == GeneratorState.loading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : Text(
                    "DETECT RADAR FLAGS",
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5),
                  ),
          ),
          const SizedBox(height: 24),
          if (provider.redFlagsAnalysis != null) ...[
            _buildRedFlagsResults(provider.redFlagsAnalysis!),
          ],
        ],
      ),
    );
  }

  Widget _buildRedFlagsResults(Map<String, dynamic> data) {
    final list = data['flags'] as List? ?? [];
    final matchEnergy = data['match_energy'] ?? 50;
    final summary = data['summary'] ?? "";

    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ENERGY MATCHING",
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 1.0),
              ),
              Text(
                "$matchEnergy%",
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: AppTheme.emeraldGreen),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(3)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: matchEnergy / 100.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.royalPurple, AppTheme.emeraldGreen]),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
          const Divider(height: 36, color: Colors.white10),
          Text(
            "DETECTED SIGNALS",
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 12),
          ...list.map((item) => _buildFlagTile(item)),
          const Divider(height: 32, color: Colors.white10),
          Text(
            "SUMMARY VIBE CHECK",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 1.0),
          ),
          const SizedBox(height: 6),
          Text(
            summary,
            style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms);
  }

  Widget _buildFlagTile(dynamic flag) {
    final type = flag['type'] ?? 'yellow';
    final icon = flag['icon'] ?? '⚠️';
    final title = flag['message'] ?? 'Signal';
    final desc = flag['description'] ?? '';

    Color indicatorColor = AppTheme.champagneGold;
    if (type == 'red') indicatorColor = Colors.redAccent;
    if (type == 'green') indicatorColor = AppTheme.emeraldGreen;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: indicatorColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: indicatorColor),
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 4: VOICE RIZZ ---
  Widget _buildVoiceRizzTab(FlirtProvider provider) {
    final data = provider.voiceRizzData;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "VOICE FLIRTING",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 6),
          Text(
            "Enter what you wanted to say (or talk) and let AI polish it into a highly-attractive smooth variant.",
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 24),

          // Speech Visualizer Container
          GlassCard(
            height: 130,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            borderRadius: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _toggleVoiceWaveform,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: _waveformController.isAnimating
                            ? [Colors.redAccent, AppTheme.neonPink]
                            : [AppTheme.royalPurple, AppTheme.electricBlue],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_waveformController.isAnimating ? Colors.redAccent : AppTheme.royalPurple).withValues(alpha: 0.3),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Icon(
                      _waveformController.isAnimating ? LucideIcons.stopCircle : LucideIcons.mic,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _waveformController.isAnimating
                        ? _buildWaveformAnimation()
                        : Text(
                            "Tap to record speech input",
                            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          TextField(
            controller: _voiceCtrl,
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
            decoration: InputDecoration(
              hintText: "Or type your draft message here...",
              hintStyle: GoogleFonts.inter(fontSize: 14, color: AppTheme.textMuted),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.03),
              contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.royalPurple, width: 1.5)),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedGradientButton(
            onTap: () {
              if (_voiceCtrl.text.isNotEmpty) {
                HapticFeedback.mediumImpact();
                provider.runVoiceRizz(_voiceCtrl.text);
              }
            },
            child: provider.state == GeneratorState.loading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : Text(
                    "RIZZ UP MY SPEECH",
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5),
                  ),
          ),
          const SizedBox(height: 24),

          if (data != null) ...[
            _buildVoiceResults(data),
          ],
        ],
      ),
    );
  }

  void _toggleVoiceWaveform() {
    HapticFeedback.lightImpact();
    if (_waveformController.isAnimating) {
      _waveformController.stop();
      _voiceCtrl.text = "I want to invite her to get coffee this Friday.";
    } else {
      _waveformController.repeat(reverse: true);
    }
    setState(() {});
  }

  Widget _buildWaveformAnimation() {
    return AnimatedBuilder(
      animation: _waveformController,
      builder: (ctx, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(8, (i) {
            final scale = (0.2 + (0.8 * _waveformController.value) + (i % 3) * 0.1).clamp(0.2, 1.0);
            return Container(
              width: 3.5,
              height: 48 * scale,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.electricBlue, AppTheme.neonPink]),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildVoiceResults(Map<String, dynamic> data) {
    final rizz = data['rizz'] ?? "";
    final explanation = data['explanation'] ?? "";

    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "RIZZED UP VERSION",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.champagneGold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 12),
          Text(
            rizz,
            style: GoogleFonts.cormorantGaramond(fontSize: 22, color: Colors.white, height: 1.4, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
          ),
          const Divider(height: 32, color: Colors.white10),
          Text(
            "COACH EXPLANATION",
            style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w900, color: AppTheme.textMuted, letterSpacing: 1.0),
          ),
          const SizedBox(height: 4),
          Text(
            explanation,
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Clipboard.setData(ClipboardData(text: rizz));
                  },
                  icon: const Icon(LucideIcons.copy, size: 14),
                  label: const Text("Copy to clipboard"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}
