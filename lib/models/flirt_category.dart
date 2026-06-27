import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FlirtCategory {
  final String id;
  final String name;
  final IconData icon;
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
        LucideIcons.bookmark.codePoint,
    message: j['message'],
    savedAt: DateTime.parse(j['savedAt']),
    arcStageLabel: j['arcStageLabel'] as String?,
  );

  IconData get catIcon {
    // Look up based on common Lucide icon code points, or fall back to bookmark
    // ignore: non_const_argument_for_const_parameter
    return IconData(catIconCodePoint, fontFamily: 'LucideIcons', fontPackage: 'lucide_icons');
  }
}

FlirtCategory buildMixedCategory(FlirtCategory a, FlirtCategory b) {
  final ids = [a.id, b.id]..sort();
  return FlirtCategory(
    id: 'mix:${ids[0]}+${ids[1]}',
    name: '${a.name} + ${b.name}',
    icon: LucideIcons.layers,
    tagline: 'Mixed mood',
    gradientColors: [a.gradientColors.first, b.gradientColors.last],
    styleHint: '${a.styleHint}; also blended with: ${b.styleHint}',
  );
}

final List<FlirtCategory> kCategories = [
  const FlirtCategory(
    id: 'romantic',
    name: 'Romantic',
    icon: LucideIcons.heart,
    tagline: 'Touch the heart',
    gradientColors: [Color(0xFF2C3039), Color(0xFFE5C07B)],
    styleHint: 'deeply romantic, poetic, heartfelt, uses beautiful metaphors about love',
  ),
  const FlirtCategory(
    id: 'funny',
    name: 'Funny',
    icon: LucideIcons.smile,
    tagline: 'Make them laugh',
    gradientColors: [Color(0xFF2C3039), Color(0xFFA2845E)],
    styleHint: 'genuinely funny, uses clever wordplay and puns, witty',
  ),
  const FlirtCategory(
    id: 'light',
    name: 'Light',
    icon: LucideIcons.sun,
    tagline: 'Keep it sweet',
    gradientColors: [Color(0xFF2C3039), Color(0xFF8A909A)],
    styleHint: 'light, sweet, innocent, casual and warm compliments',
  ),
  const FlirtCategory(
    id: 'playful',
    name: 'Playful',
    icon: LucideIcons.gamepad2,
    tagline: 'Fun & teasing',
    gradientColors: [Color(0xFF1F2229), Color(0xFFD4AF37)],
    styleHint: 'playfully teasing, witty banter, confident yet fun',
  ),
  const FlirtCategory(
    id: 'classy',
    name: 'Classy',
    icon: LucideIcons.briefcase,
    tagline: 'Effortless elegance',
    gradientColors: [Color(0xFF121418), Color(0xFFE5C07B)],
    styleHint: 'highly sophisticated, elegant, uses refined vocabulary, old-world charm',
  ),
  const FlirtCategory(
    id: 'confident',
    name: 'Confident',
    icon: LucideIcons.bolt,
    tagline: 'Own the room',
    gradientColors: [Color(0xFF1F2229), Color(0xFFE0E3E8)],
    styleHint: 'boldly confident, self-assured, direct and strong without arrogance',
  ),
  const FlirtCategory(
    id: 'shy',
    name: 'Shy',
    icon: LucideIcons.helpCircle,
    tagline: 'Adorably real',
    gradientColors: [Color(0xFF1F2229), Color(0xFF636971)],
    styleHint: 'nervously sweet, adorably awkward, genuine and vulnerable',
  ),
  const FlirtCategory(
    id: 'mysterious',
    name: 'Mysterious',
    icon: LucideIcons.moon,
    tagline: 'Leave them curious',
    gradientColors: [Color(0xFF0B0B0D), Color(0xFF8A909A)],
    styleHint: 'deeply intriguing, mysterious and enigmatic, pulls them closer',
  ),
  const FlirtCategory(
    id: 'spicy',
    name: 'Spicy',
    icon: LucideIcons.flame,
    tagline: 'Turn up the heat',
    gradientColors: [Color(0xFF1F2229), Color(0xFFD4AF37)],
    styleHint: 'passionately intense, bold and fiery, tastesfully forward',
  ),
  const FlirtCategory(
    id: 'oldschool',
    name: 'Old-School',
    icon: LucideIcons.mail,
    tagline: 'Timeless romance',
    gradientColors: [Color(0xFF1F2229), Color(0xFFE5C07B)],
    styleHint: 'vintage and classic, letter-writing style, old-fashioned romantic charm',
  ),
  const FlirtCategory(
    id: 'nerdy',
    name: 'Nerdy',
    icon: LucideIcons.binary,
    tagline: 'Geek is chic',
    gradientColors: [Color(0xFF1F2229), Color(0xFF8A909A)],
    styleHint: 'uses science, math, tech or pop-culture geek references cleverly',
  ),
  const FlirtCategory(
    id: 'wholesome',
    name: 'Wholesome',
    icon: LucideIcons.thumbsUp,
    tagline: 'Warm the soul',
    gradientColors: [Color(0xFF1F2229), Color(0xFFE0E3E8)],
    styleHint: 'genuinely wholesome, kind, uplifting and feel-good',
  ),
  const FlirtCategory(
    id: 'smooth',
    name: 'Smooth',
    icon: LucideIcons.mic,
    tagline: 'Ice cold delivery',
    gradientColors: [Color(0xFF121418), Color(0xFFD4AF37)],
    styleHint: 'ultra-smooth and cool, effortless charm, James Bond confidence',
  ),
  const FlirtCategory(
    id: 'poetic',
    name: 'Poetic',
    icon: LucideIcons.quote,
    tagline: 'Pure artistry',
    gradientColors: [Color(0xFF121418), Color(0xFFE5C07B)],
    styleHint: 'lyrical and poetic, uses verse-like rhythm and vivid imagery',
  ),
];
