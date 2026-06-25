import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flirt_category.dart';
import '../models/vibe.dart';
import '../services/api_service.dart';
import '../data/offline_lines.dart';

enum GeneratorState { idle, loading, success, error }

class FlirtProvider extends ChangeNotifier {
  // Generator state
  GeneratorState _state = GeneratorState.idle;
  String _currentMessage = '';
  String _errorMessage = '';
  FlirtCategory? _selectedCategory;
  List<String> _sessionHistory = [];
  int _historyIndex = -1;

  // Personalization
  String _targetName = '';
  String _targetTrait = '';
  Vibe _selectedVibe = kNoVibe;

  // Track if the last line was AI-generated
  bool _lastLineWasAi = false;

  // Favorites
  List<FavoriteMessage> _favorites = [];

  // Stats
  int _totalGenerated = 0;

  GeneratorState get state => _state;
  String get currentMessage => _currentMessage;
  String get errorMessage => _errorMessage;
  FlirtCategory? get selectedCategory => _selectedCategory;
  List<FavoriteMessage> get favorites => List.unmodifiable(_favorites);
  int get totalGenerated => _totalGenerated;
  bool get hasPrev => _historyIndex > 0;
  bool get hasNext => _historyIndex < _sessionHistory.length - 1;
  int get historyIndex => _historyIndex;
  int get historyCount => _sessionHistory.length;

  String get targetName => _targetName;
  String get targetTrait => _targetTrait;
  Vibe get selectedVibe => _selectedVibe;
  bool get isAiAvailable => ApiService.isConfigured;
  bool get lastLineWasAi => _lastLineWasAi;
  bool get isMixed => _selectedCategory?.id.startsWith('mix:') ?? false;
  bool get hasVibe => _selectedVibe.id != kNoVibe.id;
  bool get isCustomized => _targetName.isNotEmpty || _targetTrait.isNotEmpty || hasVibe;

  FlirtProvider() {
    _loadFavorites();
  }

  void selectCategory(FlirtCategory cat) {
    _selectedCategory = cat;
    _sessionHistory = [];
    _historyIndex = -1;
    _currentMessage = '';
    _state = GeneratorState.idle;
    notifyListeners();
  }

  void selectMixedCategories(FlirtCategory cat1, FlirtCategory cat2) {
    _selectedCategory = buildMixedCategory(cat1, cat2);
    _sessionHistory = [];
    _historyIndex = -1;
    _currentMessage = '';
    _state = GeneratorState.idle;
    notifyListeners();
  }

  void setPersonalization({required String name, required String trait}) {
    _targetName = name.trim();
    _targetTrait = trait.trim();
    notifyListeners();
  }

  void setVibe(String vibeId) {
    _selectedVibe = vibeById(vibeId);
    notifyListeners();
  }

  Future<void> generateLine() async {
    if (_selectedCategory == null || _state == GeneratorState.loading) return;

    _state = GeneratorState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      String line;
      if (isAiAvailable) {
        line = await ApiService.generatePickupLine(
          category: _selectedCategory!,
          recentLines: _sessionHistory,
          vibe: _selectedVibe,
          userContext: _targetTrait.isNotEmpty ? 'About them: $_targetTrait' : null,
        );
        // Simple name injection if model didn't do it (mostly for safety)
        if (_targetName.isNotEmpty && !line.contains(_targetName)) {
          line = _injectName(line, _targetName);
        }
        _lastLineWasAi = true;
      } else {
        line = _generateOfflineLine();
        _lastLineWasAi = false;
      }

      if (_historyIndex < _sessionHistory.length - 1) {
        _sessionHistory = _sessionHistory.sublist(0, _historyIndex + 1);
      }

      _sessionHistory.add(line);
      _historyIndex = _sessionHistory.length - 1;
      _currentMessage = line;
      _state = GeneratorState.success;
      _totalGenerated++;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = GeneratorState.error;
      notifyListeners();
    }
  }

  String _generateOfflineLine() {
    final cat = _selectedCategory!;
    List<String> pool = [];

    if (isMixed) {
      final ids = cat.id.replaceFirst('mix:', '').split('+');
      pool.addAll(kOfflineLines[ids[0]] ?? []);
      pool.addAll(kOfflineLines[ids[1]] ?? []);
    } else {
      pool.addAll(kOfflineLines[cat.id] ?? []);
    }

    if (pool.isEmpty) return "You're amazing.";

    // Filter out recent
    var filtered = pool.where((l) => !_sessionHistory.contains(l)).toList();
    if (filtered.isEmpty) filtered = pool;

    String line = filtered[Random().nextInt(filtered.length)];

    // Inject trait if available
    if (_targetTrait.isNotEmpty) {
      // Small chance to use a trait-specific template if we had them,
      // but for now let's just use the selected line.
    }

    // Inject name
    if (_targetName.isNotEmpty) {
      line = _injectName(line, _targetName);
    }

    return line;
  }

  String _injectName(String line, String name) {
    final templates = [
      '$name, {line}',
      '{line} I mean that, $name.',
      'Hey $name — {line}',
      '{line} That\'s just how I see it, $name.',
    ];
    final template = templates[Random().nextInt(templates.length)];
    
    // Lowercase the first letter of the line if it's being preceded by a name
    if (template.startsWith('$name,') || template.startsWith('Hey $name')) {
      line = line[0].toLowerCase() + line.substring(1);
    }
    
    return template.replaceAll('{line}', line);
  }

  void navigateHistory(int direction) {
    final newIdx = _historyIndex + direction;
    if (newIdx >= 0 && newIdx < _sessionHistory.length) {
      _historyIndex = newIdx;
      _currentMessage = _sessionHistory[newIdx];
      _state = GeneratorState.success;
      notifyListeners();
    }
  }

  bool isFavorited(String message) =>
      _favorites.any((f) => f.message == message);

  // Favorites management
  Future<void> toggleFavorite() async {
    if (_currentMessage.isEmpty || _selectedCategory == null) return;

    final existing = _favorites.indexWhere(
      (f) => f.message == _currentMessage,
    );

    if (existing >= 0) {
      _favorites.removeAt(existing);
    } else {
      _favorites.insert(0, FavoriteMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        catId: _selectedCategory!.id,
        catName: _selectedCategory!.name,
        catEmoji: _selectedCategory!.emoji,
        message: _currentMessage,
        savedAt: DateTime.now(),
      ));
    }

    notifyListeners();
    await _saveFavorites();
  }

  Future<void> deleteFavorite(String id) async {
    _favorites.removeWhere((f) => f.id == id);
    notifyListeners();
    await _saveFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('fm_favorites');
    if (data != null) {
      final list = jsonDecode(data) as List;
      _favorites = list.map((e) => FavoriteMessage.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'fm_favorites',
      jsonEncode(_favorites.map((f) => f.toJson()).toList()),
    );
  }
}
