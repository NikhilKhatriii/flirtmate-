import 'package:flutter/cupertino.dart';

class FlirtCategory {
  final String id;
  
  /// English name for AI prompting
  final String name;
  
  final IconData icon;

  /// English tagline for AI prompting
  final String tagline;

  final List<Color> gradientColors;
  final String styleHint;

  const FlirtCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.tagline,
    required this.gradientColors,
    required this.styleHint,
  });
}

class FavoriteMessage {
  final String id;
  final String catId;
  final String catName;
  final int catIconCodePoint;
  final String message;
  final DateTime savedAt;
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
        CupertinoIcons.bookmark_fill.codePoint,
    message: j['message'],
    savedAt: DateTime.parse(j['savedAt']),
    arcStageLabel: j['arcStageLabel'] as String?,
  );

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

FlirtCategory buildMixedCategory(FlirtCategory a, FlirtCategory b) {
  final ids = [a.id, b.id]..sort();
  return FlirtCategory(
    id: 'mix:${ids[0]}+${ids[1]}',
    name: '${a.name} + ${b.name}',
    icon: CupertinoIcons.rectangle_stack,
    tagline: 'Mixed mood',
    gradientColors: [a.gradientColors.first, b.gradientColors.last],
    styleHint: '${a.styleHint}; also blended with: ${b.styleHint}',
  );
}

final List<FlirtCategory> kCategories = [
  const FlirtCategory(
    id: 'romantic',
    name: 'Romantic',
    icon: CupertinoIcons.heart,
    tagline: 'Touch the heart',
    gradientColors: [Color(0xFF2C3039), Color(0xFFE5C07B)],
    styleHint: 'deeply romantic, poetic, heartfelt, uses beautiful metaphors about love',
  ),
  const FlirtCategory(
    id: 'funny',
    name: 'Funny',
    icon: CupertinoIcons.smiley,
    tagline: 'Make them laugh',
    gradientColors: [Color(0xFF2C3039), Color(0xFFA2845E)],
    styleHint: 'genuinely funny, uses clever wordplay and puns, witty',
  ),
  const FlirtCategory(
    id: 'light',
    name: 'Light',
    icon: CupertinoIcons.sun_max,
    tagline: 'Keep it sweet',
    gradientColors: [Color(0xFF2C3039), Color(0xFF8A909A)],
    styleHint: 'light, sweet, innocent, casual and warm compliments',
  ),
  const FlirtCategory(
    id: 'playful',
    name: 'Playful',
    icon: CupertinoIcons.game_controller,
    tagline: 'Fun & teasing',
    gradientColors: [Color(0xFF1F2229), Color(0xFFD4AF37)],
    styleHint: 'playfully teasing, witty banter, confident yet fun',
  ),
  const FlirtCategory(
    id: 'classy',
    name: 'Classy',
    icon: CupertinoIcons.briefcase,
    tagline: 'Effortless elegance',
    gradientColors: [Color(0xFF121418), Color(0xFFE5C07B)],
    styleHint: 'highly sophisticated, elegant, uses refined vocabulary, old-world charm',
  ),
  const FlirtCategory(
    id: 'confident',
    name: 'Confident',
    icon: CupertinoIcons.bolt,
    tagline: 'Own the room',
    gradientColors: [Color(0xFF1F2229), Color(0xFFE0E3E8)],
    styleHint: 'boldly confident, self-assured, direct and strong without arrogance',
  ),
  const FlirtCategory(
    id: 'shy',
    name: 'Shy',
    icon: CupertinoIcons.leaf_arrow_circlepath,
    tagline: 'Adorably real',
    gradientColors: [Color(0xFF1F2229), Color(0xFF636971)],
    styleHint: 'nervously sweet, adorably awkward, genuine and vulnerable',
  ),
  const FlirtCategory(
    id: 'mysterious',
    name: 'Mysterious',
    icon: CupertinoIcons.moon,
    tagline: 'Leave them curious',
    gradientColors: [Color(0xFF0B0B0D), Color(0xFF8A909A)],
    styleHint: 'deeply intriguing, mysterious and enigmatic, pulls them closer',
  ),
  const FlirtCategory(
    id: 'spicy',
    name: 'Spicy',
    icon: CupertinoIcons.flame,
    tagline: 'Turn up the heat',
    gradientColors: [Color(0xFF1F2229), Color(0xFFD4AF37)],
    styleHint: 'passionately intense, bold and fiery, tastefully forward',
  ),
  const FlirtCategory(
    id: 'oldschool',
    name: 'Old-School',
    icon: CupertinoIcons.envelope,
    tagline: 'Timeless romance',
    gradientColors: [Color(0xFF1F2229), Color(0xFFE5C07B)],
    styleHint: 'vintage and classic, letter-writing style, old-fashioned romantic charm',
  ),
  const FlirtCategory(
    id: 'nerdy',
    name: 'Nerdy',
    icon: CupertinoIcons.square_grid_3x2,
    tagline: 'Geek is chic',
    gradientColors: [Color(0xFF1F2229), Color(0xFF8A909A)],
    styleHint: 'uses science, math, tech or pop-culture geek references cleverly',
  ),
  const FlirtCategory(
    id: 'wholesome',
    name: 'Wholesome',
    icon: CupertinoIcons.hand_thumbsup,
    tagline: 'Warm the soul',
    gradientColors: [Color(0xFF1F2229), Color(0xFFE0E3E8)],
    styleHint: 'genuinely wholesome, kind, uplifting and feel-good',
  ),
  const FlirtCategory(
    id: 'smooth',
    name: 'Smooth',
    icon: CupertinoIcons.mic,
    tagline: 'Ice cold delivery',
    gradientColors: [Color(0xFF121418), Color(0xFFD4AF37)],
    styleHint: 'ultra-smooth and cool, effortless charm, James Bond confidence',
  ),
  const FlirtCategory(
    id: 'poetic',
    name: 'Poetic',
    icon: CupertinoIcons.text_quote,
    tagline: 'Pure artistry',
    gradientColors: [Color(0xFF121418), Color(0xFFE5C07B)],
    styleHint: 'lyrical and poetic, uses verse-like rhythm and vivid imagery',
  ),
];
