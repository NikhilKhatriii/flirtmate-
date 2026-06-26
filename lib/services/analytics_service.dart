import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> screenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  static Future<void> categorySelected(String categoryId) async {
    await _analytics.logEvent(
      name: 'category_selected',
      parameters: {'category_id': categoryId},
    );
  }

  static Future<void> lineGenerated(String categoryId, bool isAiGenerated) async {
    await _analytics.logEvent(
      name: 'line_generated',
      parameters: {
        'category_id': categoryId,
        'is_ai': isAiGenerated ? 1 : 0,
      },
    );
  }

  static Future<void> lineFavorited(String categoryId) async {
    await _analytics.logEvent(
      name: 'line_favorited',
      parameters: {'category_id': categoryId},
    );
  }

  static Future<void> lineShared(String categoryId) async {
    await _analytics.logEvent(
      name: 'line_shared',
      parameters: {'category_id': categoryId},
    );
  }

  static Future<void> lineCopied(String categoryId) async {
    await _analytics.logEvent(
      name: 'line_copied',
      parameters: {'category_id': categoryId},
    );
  }

  static Future<void> moodMixerUsed(String categoryIdA, String categoryIdB) async {
    await _analytics.logEvent(
      name: 'mood_mixer_used',
      parameters: {
        'category_id_a': categoryIdA,
        'category_id_b': categoryIdB,
      },
    );
  }

  static Future<void> vibeSelected(String vibeId) async {
    await _analytics.logEvent(
      name: 'vibe_selected',
      parameters: {'vibe_id': vibeId},
    );
  }

  static Future<void> personalizationUsed() async {
    await _analytics.logEvent(name: 'personalization_used');
  }

  static Future<void> languageChanged(String languageCode) async {
    await _analytics.logEvent(
      name: 'language_changed',
      parameters: {'language_code': languageCode},
    );
  }

  static Future<void> themeChanged(String presetOrHex) async {
    await _analytics.logEvent(
      name: 'theme_changed',
      parameters: {'theme_value': presetOrHex},
    );
  }
}
