import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/localization_service.dart';
import '../services/analytics_service.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _langKey = 'fm_user_language';
  
  AppLanguage _currentLanguage = AppLanguage.en;
  AppLanguage get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
  }

  String translate(String key) => LocalizationService.translate(key);

  Future<void> setLanguage(AppLanguage lang) async {
    if (_currentLanguage == lang) return;
    _currentLanguage = lang;
    AnalyticsService.languageChanged(lang.name);
    LocalizationService.setLanguage(lang);
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_langKey, lang.index);
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_langKey);
    if (index != null) {
      _currentLanguage = AppLanguage.values[index];
      LocalizationService.setLanguage(_currentLanguage);
      notifyListeners();
    }
  }
}
