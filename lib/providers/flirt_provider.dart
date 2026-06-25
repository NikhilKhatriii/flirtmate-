import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flirt_category.dart';
import '../services/api_service.dart';

enum GeneratorState { idle, loading, success, error }

class FlirtProvider extends ChangeNotifier {
  // Generator state
  GeneratorState _state = GeneratorState.idle;
  String _currentMessage = '';
  String _errorMessage = '';
  FlirtCategory? _selectedCategory;
  List<String> _sessionHistory = [];
  int _historyIndex = -1;

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

  bool isFavorited(String message) =>
      _favorites.any((f) => f.message == message && f.catId == _selectedCategory?.id);

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

  Future<void> generateLine() async {
    if (_selectedCategory == null || _state == GeneratorState.loading) return;

    _state = GeneratorState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final line = await ApiService.generatePickupLine(
        category: _selectedCategory!,
        recentLines: _sessionHistory,
      );

      // Truncate history if we navigated back
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

  void navigateHistory(int direction) {
    final newIdx = _historyIndex + direction;
    if (newIdx >= 0 && newIdx < _sessionHistory.length) {
      _historyIndex = newIdx;
      _currentMessage = _sessionHistory[newIdx];
      _state = GeneratorState.success;
      notifyListeners();
    }
  }

  // Favorites management
  Future<void> toggleFavorite() async {
    if (_currentMessage.isEmpty || _selectedCategory == null) return;

    final existing = _favorites.indexWhere(
      (f) => f.message == _currentMessage && f.catId == _selectedCategory!.id,
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
