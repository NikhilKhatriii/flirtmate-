import 'package:flutter/cupertino.dart';

// ---------------------------------------------------------------------------
// Apple-style design system
// ---------------------------------------------------------------------------
//
// Palette — iOS system colors only; no pink, no purple:
//
//   System Blue        #007AFF  — primary actions, romantic/smooth/light
//   System Cyan        #32ADE6  — secondary blue, nerdy/poetic
//   System Teal        #30B0C7  — oldschool/shy
//   System Green       #34C759  — confident/wholesome
//   System Mint        #00C7BE  — playful
//   System Orange      #FF9500  — funny
//   System Yellow      #FFCC00  — spicy (warm, not hot)
//   System Brown       #A2845E  — classy
//   System Indigo      #5856D6  — mysterious (the one blue-adjacent allowed)
//   Label Primary      #000000
//   Label Secondary    #636366
//   Grouped BG         #F2F2F7
//   Card surface       #FFFFFF
//   Separator          #C6C6C8
//
// Icons — CupertinoIcons exclusively. No emoji characters anywhere.
// ---------------------------------------------------------------------------

class FlirtCategory {
  final String id;
  final String name;

  /// SF Symbol / CupertinoIcon for this category. Replaces emoji.
  final IconData icon;

  final String description;
  final String tagline;

  /// Two-stop gradient. Both stops are Apple system colors (see palette above).
  /// No pink (#FF2D55, #FF375F, #FF6B9D, …) and no purple (#BF5AF2, #9B59B6, …).
  final List<Color> gradientColors;

  final String styleHint;

  const FlirtCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.tagline,
    required this.gradientColors,
    required this.styleHint,
  });
}

class FavoriteMessage {
  final String id;
  final String catId;
  final String catName;

  /// Icon replaces catEmoji. Store the codePoint so it survives JSON round-trips.
  final int catIconCodePoint;

  final String message;
  final DateTime savedAt;

  /// Which Conversation Arc stage this was saved from (e.g. "Opener",
  /// "Follow-up", "Going Deeper"). Nullable so favorites saved before this
  /// feature existed still load correctly — they just won't show a stage.
  final String? arcStageLabel;

  FavoriteMessage({
    required this.id,
    required this.catId,
    required this.catName,
    required this.catIconCodePoint,
    required this.message,
    required this.savedAt,
    this.arcStageLabel,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'catId': catId,
    'catName': catName,
    'catIconCodePoint': catIconCodePoint,
    'message': message,
    'savedAt': savedAt.toIso8601String(),
    'arcStageLabel': arcStageLabel,
  };

  factory FavoriteMessage.fromJson(Map<String, dynamic> j) => FavoriteMessage(
    id: j['id'],
    catId: j['catId'],
    catName: j['catName'],
    catIconCodePoint: j['catIconCodePoint'] as int? ??
        // Legacy records stored catEmoji; fall back to a neutral bookmark icon.
        CupertinoIcons.bookmark_fill.codePoint,
    message: j['message'],
    savedAt: DateTime.parse(j['savedAt']),
    arcStageLabel: j['arcStageLabel'] as String?,
  );

  /// Convenience getter — reconstructs the IconData from the stored code point.
  /// Font family must match CupertinoIcons (CupertinoIcons.iconFont).
  /// Convenience getter — reconstructs the IconData from the stored code point.
  /// Uses a switch to return constants, which satisfies icon tree-shaking
  /// requirements in some build environments.
  IconData get catIcon {
    return switch (catIconCodePoint) {
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
  }
}

/// Builds a synthetic "mixed" category by blending two real categories —
/// used by the Mood Mixer feature. The id is deterministic and
/// order-independent (sorted) so picking A+B or B+A reuses the same
/// offline-queue cache slot.
FlirtCategory buildMixedCategory(FlirtCategory a, FlirtCategory b) {
  final ids = [a.id, b.id]..sort();
  return FlirtCategory(
    id: 'mix:${ids[0]}+${ids[1]}',
    name: '${a.name} + ${b.name}',
    icon: CupertinoIcons.rectangle_stack, // represents a blend/mix
    description:
    'A blend of ${a.name.toLowerCase()} and ${b.name.toLowerCase()}',
    tagline: 'Mixed mood',
    gradientColors: [a.gradientColors.first, b.gradientColors.last],
    styleHint: '${a.styleHint}; also blended with: ${b.styleHint}',
  );
}

// ---------------------------------------------------------------------------
// Category definitions — Apple system palette, CupertinoIcons, no emoji
// ---------------------------------------------------------------------------

final List<FlirtCategory> kCategories = [
  // Romantic — system blue; heart as universal "care" signal
  const FlirtCategory(
    id: 'romantic',
    name: 'Romantic',
    icon: CupertinoIcons.heart,
    description: 'Deep, heartfelt, poetic love lines',
    tagline: 'Touch the heart',
    gradientColors: [Color(0xFF0051A8), Color(0xFF007AFF)], // deep blue → system blue
    styleHint: 'deeply romantic, poetic, heartfelt, uses beautiful metaphors about love',
  ),

  // Funny — system orange; face with laugh lines
  const FlirtCategory(
    id: 'funny',
    name: 'Funny',
    icon: CupertinoIcons.smiley,
    description: 'Humorous, punny, laugh-inducing pickup lines',
    tagline: 'Make them laugh',
    gradientColors: [Color(0xFFCC7700), Color(0xFFFF9500)], // deep orange → system orange
    styleHint: 'genuinely funny, uses clever wordplay and puns, witty',
  ),

  // Light — system cyan (lighter blue-family, airy)
  const FlirtCategory(
    id: 'light',
    name: 'Light',
    icon: CupertinoIcons.sun_max,
    description: 'Soft, innocent, casual sweet compliments',
    tagline: 'Keep it sweet',
    gradientColors: [Color(0xFF1E8FA8), Color(0xFF32ADE6)], // deep cyan → system cyan
    styleHint: 'light, sweet, innocent, casual and warm compliments',
  ),

  // Playful — system mint (distinct from blue, energetic)
  const FlirtCategory(
    id: 'playful',
    name: 'Playful',
    icon: CupertinoIcons.game_controller,
    description: 'Teasing, witty banter-style flirts',
    tagline: 'Fun & teasing',
    gradientColors: [Color(0xFF009490), Color(0xFF00C7BE)], // deep mint → system mint
    styleHint: 'playfully teasing, witty banter, confident yet fun',
  ),

  // Classy — system brown; top hat is unavailable in Cupertino, use suit-case
  const FlirtCategory(
    id: 'classy',
    name: 'Classy',
    icon: CupertinoIcons.briefcase,
    description: 'Elegant, sophisticated, refined charm lines',
    tagline: 'Effortless elegance',
    gradientColors: [Color(0xFF7A5C3A), Color(0xFFA2845E)], // deep brown → system brown
    styleHint: 'highly sophisticated, elegant, uses refined vocabulary, old-world charm',
  ),

  // Confident — system green; bolt for energy and decisiveness
  const FlirtCategory(
    id: 'confident',
    name: 'Confident',
    icon: CupertinoIcons.bolt,
    description: 'Bold, self-assured, alpha openers',
    tagline: 'Own the room',
    gradientColors: [Color(0xFF248A3D), Color(0xFF34C759)], // deep green → system green
    styleHint: 'boldly confident, self-assured, direct and strong without arrogance',
  ),

  // Shy — system teal; leaf = quiet, organic, understated
  const FlirtCategory(
    id: 'shy',
    name: 'Shy',
    icon: CupertinoIcons.leaf_arrow_circlepath,
    description: 'Nervous, cute, adorably awkward messages',
    tagline: 'Adorably real',
    gradientColors: [Color(0xFF1E808F), Color(0xFF30B0C7)], // deep teal → system teal
    styleHint: 'nervously sweet, adorably awkward, genuine and vulnerable',
  ),

  // Mysterious — system indigo; moon for night / intrigue
  const FlirtCategory(
    id: 'mysterious',
    name: 'Mysterious',
    icon: CupertinoIcons.moon,
    description: 'Dark, intriguing, pull-them-closer vibes',
    tagline: 'Leave them curious',
    gradientColors: [Color(0xFF3634A3), Color(0xFF5856D6)], // deep indigo → system indigo
    styleHint: 'deeply intriguing, mysterious and enigmatic, pulls them closer',
  ),

  // Spicy — system yellow (warm/fiery without red aggression)
  const FlirtCategory(
    id: 'spicy',
    name: 'Spicy',
    icon: CupertinoIcons.flame,
    description: 'Hot, passionate, intense messages',
    tagline: 'Turn up the heat',
    gradientColors: [Color(0xFFCC9900), Color(0xFFFFCC00)], // amber → system yellow
    styleHint: 'passionately intense, bold and fiery, tastefully forward',
  ),

  // Old-School — system brown (warm, aged); envelope for letter-writing
  const FlirtCategory(
    id: 'oldschool',
    name: 'Old-School',
    icon: CupertinoIcons.envelope,
    description: 'Vintage, letter-style, classic romantic charm',
    tagline: 'Timeless romance',
    gradientColors: [Color(0xFF6B4226), Color(0xFFA2845E)], // dark brown → system brown
    styleHint: 'vintage and classic, letter-writing style, old-fashioned romantic charm',
  ),

  // Nerdy — system cyan; cpu chip for tech
  const FlirtCategory(
    id: 'nerdy',
    name: 'Nerdy',
    icon: CupertinoIcons.square_grid_3x2,
    description: 'Clever science, tech and geek-themed flirts',
    tagline: 'Geek is chic',
    gradientColors: [Color(0xFF1E8FA8), Color(0xFF30B0C7)], // deep cyan → system teal
    styleHint: 'uses science, math, tech or pop-culture geek references cleverly',
  ),

  // Wholesome — system green; hands-heart for kindness
  const FlirtCategory(
    id: 'wholesome',
    name: 'Wholesome',
    icon: CupertinoIcons.hand_thumbsup,
    description: 'Pure, kind, affirming feel-good messages',
    tagline: 'Warm the soul',
    gradientColors: [Color(0xFF1D6B2E), Color(0xFF34C759)], // dark green → system green
    styleHint: 'genuinely wholesome, kind, uplifting and feel-good',
  ),

  // Smooth — system blue (cooler shade); microphone for delivery
  const FlirtCategory(
    id: 'smooth',
    name: 'Smooth',
    icon: CupertinoIcons.mic,
    description: 'Ultra-cool, James Bond-style one-liners',
    tagline: 'Ice cold delivery',
    gradientColors: [Color(0xFF003F8A), Color(0xFF0066CC)], // navy → mid-blue
    styleHint: 'ultra-smooth and cool, effortless charm, James Bond confidence',
  ),

  // Poetic — system indigo (artistic without purple); text-quote mark
  const FlirtCategory(
    id: 'poetic',
    name: 'Poetic',
    icon: CupertinoIcons.text_quote,
    description: 'Lyrical, verse-inspired, beautiful messages',
    tagline: 'Pure artistry',
    gradientColors: [Color(0xFF2D2B8F), Color(0xFF5856D6)], // deep indigo → system indigo
    styleHint: 'lyrical and poetic, uses verse-like rhythm and vivid imagery',
  ),
];
