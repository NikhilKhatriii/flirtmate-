import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

enum ThemePreset { platinum, champagne, teal, custom }

class ThemeProvider extends ChangeNotifier {
  static const String _presetKey = 'fm_theme_preset_v2';
  static const String _customColorKey = 'fm_custom_color_v2';
  static const String _modeKey = 'fm_theme_mode';

  ThemePreset _currentPreset = ThemePreset.platinum;
  Color _customAccent = const Color(0xFFE2E5E9);
  ThemeMode _themeMode = ThemeMode.system;

  ThemePreset get currentPreset => _currentPreset;
  Color get customAccent => _customAccent;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadSettings();
  }

  ThemeData get themeData {
    return AppTheme.buildTheme(
      mode: _themeMode,
      accent: _getActiveAccent(),
    );
  }

  Color _getActiveAccent() {
    switch (_currentPreset) {
      case ThemePreset.platinum:
        return const Color(0xFFE2E5E9);
      case ThemePreset.champagne:
        return const Color(0xFFE5C07B);
      case ThemePreset.teal:
        return const Color(0xFF00E5FF);
      case ThemePreset.custom:
        return _customAccent;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_modeKey, mode.index);
  }

  Future<void> setPreset(ThemePreset preset) async {
    _currentPreset = preset;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_presetKey, preset.index);
  }

  Future<void> setCustomColor(Color color) async {
    _customAccent = color;
    _currentPreset = ThemePreset.custom;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_presetKey, ThemePreset.custom.index);
    await prefs.setInt(_customColorKey, color.toARGB32());
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final modeIdx = prefs.getInt(_modeKey);
    if (modeIdx != null) _themeMode = ThemeMode.values[modeIdx];

    final presetIdx = prefs.getInt(_presetKey);
    if (presetIdx != null) _currentPreset = ThemePreset.values[presetIdx];

    final colorVal = prefs.getInt(_customColorKey);
    if (colorVal != null) _customAccent = Color(colorVal);

    notifyListeners();
  }
}
