import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static FirebaseAnalytics? get _analytics {
    try {
      return FirebaseAnalytics.instance;
    } catch (_) {
      return null;
    }
  }

  static Future<void> screenView(String screenName) async {
    try {
      await _analytics?.logScreenView(screenName: screenName);
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> categorySelected(String categoryId) async {
    try {
      await _analytics?.logEvent(
        name: 'category_selected',
        parameters: {'category_id': categoryId},
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> lineGenerated(String categoryId, bool isAiGenerated) async {
    try {
      await _analytics?.logEvent(
        name: 'line_generated',
        parameters: {
          'category_id': categoryId,
          'is_ai': isAiGenerated ? 1 : 0,
        },
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> lineFavorited(String categoryId) async {
    try {
      await _analytics?.logEvent(
        name: 'line_favorited',
        parameters: {'category_id': categoryId},
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> lineShared(String categoryId) async {
    try {
      await _analytics?.logEvent(
        name: 'line_shared',
        parameters: {'category_id': categoryId},
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> lineCopied(String categoryId) async {
    try {
      await _analytics?.logEvent(
        name: 'line_copied',
        parameters: {'category_id': categoryId},
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> moodMixerUsed(String categoryIdA, String categoryIdB) async {
    try {
      await _analytics?.logEvent(
        name: 'mood_mixer_used',
        parameters: {
          'category_id_a': categoryIdA,
          'category_id_b': categoryIdB,
        },
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> vibeSelected(String vibeId) async {
    try {
      await _analytics?.logEvent(
        name: 'vibe_selected',
        parameters: {'vibe_id': vibeId},
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> personalizationUsed() async {
    try {
      await _analytics?.logEvent(name: 'personalization_used');
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> languageChanged(String languageCode) async {
    try {
      await _analytics?.logEvent(
        name: 'language_changed',
        parameters: {'language_code': languageCode},
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }

  static Future<void> themeChanged(String presetOrHex) async {
    try {
      await _analytics?.logEvent(
        name: 'theme_changed',
        parameters: {'theme_value': presetOrHex},
      );
    } catch (e) {
      debugPrint('Analytics error: $e');
    }
  }
}
