import 'package:flutter/material.dart';

class FlirtCategory {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String tagline;
  final List<Color> gradientColors;
  final String styleHint;

  const FlirtCategory({
    required this.id,
    required this.name,
    required this.emoji,
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
  final String catEmoji;
  final String message;
  final DateTime savedAt;

  FavoriteMessage({
    required this.id,
    required this.catId,
    required this.catName,
    required this.catEmoji,
    required this.message,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'catId': catId, 'catName': catName,
    'catEmoji': catEmoji, 'message': message,
    'savedAt': savedAt.toIso8601String(),
  };

  factory FavoriteMessage.fromJson(Map<String, dynamic> j) => FavoriteMessage(
    id: j['id'], catId: j['catId'], catName: j['catName'],
    catEmoji: j['catEmoji'], message: j['message'],
    savedAt: DateTime.parse(j['savedAt']),
  );
}

final List<FlirtCategory> kCategories = [
  FlirtCategory(
    id: 'romantic', name: 'Romantic', emoji: '🌹',
    description: 'Deep, heartfelt, poetic love lines',
    tagline: 'Touch the heart',
    gradientColors: [const Color(0xFF6B0F1A), const Color(0xFFB91372)],
    styleHint: 'deeply romantic, poetic, heartfelt, uses beautiful metaphors about love',
  ),
  FlirtCategory(
    id: 'funny', name: 'Funny', emoji: '😄',
    description: 'Humorous, punny, laugh-inducing pickup lines',
    tagline: 'Make them laugh',
    gradientColors: [const Color(0xFF7A3700), const Color(0xFFE07B00)],
    styleHint: 'genuinely funny, uses clever wordplay and puns, witty',
  ),
  FlirtCategory(
    id: 'light', name: 'Light', emoji: '💫',
    description: 'Soft, innocent, casual sweet compliments',
    tagline: 'Keep it sweet',
    gradientColors: [const Color(0xFF0A2070), const Color(0xFF4A7BE0)],
    styleHint: 'light, sweet, innocent, casual and warm compliments',
  ),
  FlirtCategory(
    id: 'playful', name: 'Playful', emoji: '😏',
    description: 'Teasing, witty banter-style flirts',
    tagline: 'Fun & teasing',
    gradientColors: [const Color(0xFF4A006E), const Color(0xFF9C27B0)],
    styleHint: 'playfully teasing, witty banter, confident yet fun',
  ),
  FlirtCategory(
    id: 'classy', name: 'Classy', emoji: '🎩',
    description: 'Elegant, sophisticated, refined charm lines',
    tagline: 'Effortless elegance',
    gradientColors: [const Color(0xFF1A2226), const Color(0xFF4A6572)],
    styleHint: 'highly sophisticated, elegant, uses refined vocabulary, old-world charm',
  ),
  FlirtCategory(
    id: 'confident', name: 'Confident', emoji: '💪',
    description: 'Bold, self-assured, alpha openers',
    tagline: 'Own the room',
    gradientColors: [const Color(0xFF0A2E10), const Color(0xFF2E7D32)],
    styleHint: 'boldly confident, self-assured, direct and strong without arrogance',
  ),
  FlirtCategory(
    id: 'shy', name: 'Shy', emoji: '🥺',
    description: 'Nervous, cute, adorably awkward messages',
    tagline: 'Adorably real',
    gradientColors: [const Color(0xFF6E0030), const Color(0xFFD81B60)],
    styleHint: 'nervously sweet, adorably awkward, genuine and vulnerable',
  ),
  FlirtCategory(
    id: 'mysterious', name: 'Mysterious', emoji: '🌙',
    description: 'Dark, intriguing, pull-them-closer vibes',
    tagline: 'Leave them curious',
    gradientColors: [const Color(0xFF07070F), const Color(0xFF1A237E)],
    styleHint: 'deeply intriguing, mysterious and enigmatic, pulls them closer',
  ),
  FlirtCategory(
    id: 'spicy', name: 'Spicy', emoji: '🌶️',
    description: 'Hot, passionate, intense messages',
    tagline: 'Turn up the heat',
    gradientColors: [const Color(0xFF7A0000), const Color(0xFFD32F2F)],
    styleHint: 'passionately intense, bold and fiery, tastefully forward',
  ),
  FlirtCategory(
    id: 'oldschool', name: 'Old-School', emoji: '💌',
    description: 'Vintage, letter-style, classic romantic charm',
    tagline: 'Timeless romance',
    gradientColors: [const Color(0xFF3E2723), const Color(0xFF795548)],
    styleHint: 'vintage and classic, letter-writing style, old-fashioned romantic charm',
  ),
  FlirtCategory(
    id: 'nerdy', name: 'Nerdy', emoji: '🤓',
    description: 'Clever science, tech and geek-themed flirts',
    tagline: 'Geek is chic',
    gradientColors: [const Color(0xFF003D36), const Color(0xFF00796B)],
    styleHint: 'uses science, math, tech or pop-culture geek references cleverly',
  ),
  FlirtCategory(
    id: 'wholesome', name: 'Wholesome', emoji: '🌈',
    description: 'Pure, kind, affirming feel-good messages',
    tagline: 'Warm the soul',
    gradientColors: [const Color(0xFF1B4700), const Color(0xFF558B2F)],
    styleHint: 'genuinely wholesome, kind, uplifting and feel-good',
  ),
  FlirtCategory(
    id: 'smooth', name: 'Smooth', emoji: '🎤',
    description: 'Ultra-cool, James Bond-style one-liners',
    tagline: 'Ice cold delivery',
    gradientColors: [const Color(0xFF001A5E), const Color(0xFF1565C0)],
    styleHint: 'ultra-smooth and cool, effortless charm, James Bond confidence',
  ),
  FlirtCategory(
    id: 'poetic', name: 'Poetic', emoji: '📜',
    description: 'Lyrical, verse-inspired, beautiful messages',
    tagline: 'Pure artistry',
    gradientColors: [const Color(0xFF4A0040), const Color(0xFF880E4F)],
    styleHint: 'lyrical and poetic, uses verse-like rhythm and vivid imagery',
  ),
];
