import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flirt_category.dart';
import '../models/vibe.dart';
import '../services/api_service.dart';
import '../data/offline_lines.dart';
import '../data/arc_lines.dart';
import '../services/analytics_service.dart';

enum GeneratorState { idle, loading, success, error }

class FlirtProvider extends ChangeNotifier {
  // Generator state
  GeneratorState _state = GeneratorState.idle;
  String _currentMessage = '';
  String _directVariant = '';
  String _playfulVariant = '';
  String _romanticVariant = '';
  String _confidentVariant = '';
  String _insight = '';
  String _errorMessage = '';
  
  // Advanced features state
  Map<String, dynamic>? _screenshotAnalysis;
  Map<String, dynamic>? _redFlagsAnalysis;
  Map<String, dynamic>? _rizzScoreAnalysis;
  Map<String, dynamic>? _voiceRizzData;
  Map<String, dynamic>? _dailyFeedData;
  
  // Selected category and history
  FlirtCategory? _selectedCategory;
  List<String> _sessionHistory = [];
  int _historyIndex = -1;

  // Mood Mixer sources
  (FlirtCategory, FlirtCategory)? _mixSources;

  // Offline queue
  final Map<String, List<String>> _offlineQueue = {};

  // Core personalization
  String _targetName = '';
  String _targetTrait = '';
  String _incomingMessage = '';
  String _vibeId = kNoVibe.id;
  bool _lastLineWasAi = false;
  ArcStage _arcStage = ArcStage.opener;

  // AI Memory (Advanced Personalization Profiles)
  String _userAge = '';
  String _userCountry = '';
  String _datingApp = 'Tinder';
  String _relationshipStage = 'Just chatting';
  String _communicationStyle = 'Playful';
  String _loveLanguage = 'Words of affirmation';
  String _introvertExtrovert = 'Ambivert';
  String _humorType = 'Witty';

  // Favorites
  List<FavoriteMessage> _favorites = [];

  // Stats
  int _totalGenerated = 0;

  // Getters
  GeneratorState get state => _state;
  String get currentMessage => _currentMessage;
  String get directVariant => _directVariant;
  String get playfulVariant => _playfulVariant;
  String get romanticVariant => _romanticVariant;
  String get confidentVariant => _confidentVariant;
  String get insight => _insight;
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
  String get incomingMessage => _incomingMessage;
  bool get isPersonalized => _targetName.isNotEmpty || _targetTrait.isNotEmpty || _incomingMessage.isNotEmpty;
  Vibe get selectedVibe => vibeById(_vibeId);
  bool get hasVibe => _vibeId != kNoVibe.id;
  bool get isCustomized => isPersonalized || hasVibe;
  bool get lastLineWasAi => _lastLineWasAi;
  ArcStage get arcStage => _arcStage;
  
  // Advanced features getters
  Map<String, dynamic>? get screenshotAnalysis => _screenshotAnalysis;
  Map<String, dynamic>? get redFlagsAnalysis => _redFlagsAnalysis;
  Map<String, dynamic>? get rizzScoreAnalysis => _rizzScoreAnalysis;
  Map<String, dynamic>? get voiceRizzData => _voiceRizzData;
  Map<String, dynamic>? get dailyFeedData => _dailyFeedData;

  // Memory profile getters
  String get userAge => _userAge;
  String get userCountry => _userCountry;
  String get datingApp => _datingApp;
  String get relationshipStage => _relationshipStage;
  String get communicationStyle => _communicationStyle;
  String get loveLanguage => _loveLanguage;
  String get introvertExtrovert => _introvertExtrovert;
  String get humorType => _humorType;

  bool get isAiAvailable => ApiService.isConfigured;

  bool isFavorited(String message) =>
      _favorites.any((f) => f.message == message && f.catId == _selectedCategory?.id);

  FlirtProvider() {
    _loadFavorites();
    _loadPersonalization();
    _loadVibe();
    _loadAdvancedMemory();
  }

  Future<void> setPersonalization({String? name, String? trait, String? incoming}) async {
    _targetName = (name ?? _targetName).trim();
    _targetTrait = (trait ?? _targetTrait).trim();
    _incomingMessage = (incoming ?? _incomingMessage).trim();
    AnalyticsService.personalizationUsed();
    if (_selectedCategory != null) {
      _offlineQueue.remove('${_selectedCategory!.id}:${ArcStage.opener.name}');
    }
    notifyListeners();
    await _savePersonalization();
  }

  Future<void> setVibe(String? vibeId) async {
    _vibeId = vibeId ?? kNoVibe.id;
    AnalyticsService.vibeSelected(_vibeId);
    notifyListeners();
    await _saveVibe();
  }

  Future<void> updateAdvancedMemory({
    String? age,
    String? country,
    String? datingApp,
    String? relationshipStage,
    String? communicationStyle,
    String? loveLanguage,
    String? introvertExtrovert,
    String? humorType,
  }) async {
    _userAge = age ?? _userAge;
    _userCountry = country ?? _userCountry;
    _datingApp = datingApp ?? _datingApp;
    _relationshipStage = relationshipStage ?? _relationshipStage;
    _communicationStyle = communicationStyle ?? _communicationStyle;
    _loveLanguage = loveLanguage ?? _loveLanguage;
    _introvertExtrovert = introvertExtrovert ?? _introvertExtrovert;
    _humorType = humorType ?? _humorType;
    notifyListeners();
    await _saveAdvancedMemory();
  }

  void setArcStage(ArcStage stage) {
    if (_arcStage == stage) return;
    _arcStage = stage;
    _sessionHistory = [];
    _historyIndex = -1;
    _currentMessage = '';
    _state = GeneratorState.idle;
    notifyListeners();
  }

  void selectCategory(FlirtCategory cat) {
    _selectedCategory = cat;
    AnalyticsService.categorySelected(cat.id);
    _mixSources = null;
    _sessionHistory = [];
    _historyIndex = -1;
    _currentMessage = '';
    _state = GeneratorState.idle;
    notifyListeners();
  }

  void selectMixedCategories(FlirtCategory a, FlirtCategory b) {
    _mixSources = (a, b);
    AnalyticsService.moodMixerUsed(a.id, b.id);
    _selectedCategory = buildMixedCategory(a, b);
    _sessionHistory = [];
    _historyIndex = -1;
    _currentMessage = '';
    _state = GeneratorState.idle;
    notifyListeners();
  }

  bool get isMixed => _mixSources != null;

  Future<void> generateLine({String languageCode = 'en'}) async {
    if (_selectedCategory == null || _state == GeneratorState.loading) return;

    _state = GeneratorState.loading;
    _errorMessage = '';
    notifyListeners();

    final catId = _selectedCategory!.id;

    try {
      if (ApiService.isConfigured && _arcStage == ArcStage.opener) {
        try {
          final result = await ApiService.generatePickupLineExtended(
            category: _selectedCategory!,
            recentLines: _sessionHistory,
            languageCode: languageCode,
            vibe: hasVibe ? selectedVibe : null,
            userContext: _buildUserContext(),
            incomingMessage: _incomingMessage.isNotEmpty ? _incomingMessage : null,
            age: _userAge,
            country: _userCountry,
            datingApp: _datingApp,
            relationshipStage: _relationshipStage,
            communicationStyle: _communicationStyle,
            loveLanguage: _loveLanguage,
            introvertExtrovert: _introvertExtrovert,
            humorType: _humorType,
          );
          _currentMessage = result['main'] ?? '';
          _directVariant = result['direct'] ?? result['short'] ?? '';
          _playfulVariant = result['playful'] ?? '';
          _romanticVariant = result['romantic'] ?? '';
          _confidentVariant = result['confident'] ?? '';
          _insight = result['insight'] ?? '';
          _lastLineWasAi = true;
        } catch (_) {
          _currentMessage = _nextOfflineLine(catId);
          _directVariant = '';
          _playfulVariant = '';
          _romanticVariant = '';
          _confidentVariant = '';
          _insight = '';
          _lastLineWasAi = false;
        }
      } else {
        await Future.delayed(const Duration(milliseconds: 1200));
        _currentMessage = _nextOfflineLine(catId);
        _directVariant = '';
        _playfulVariant = '';
        _romanticVariant = '';
        _confidentVariant = '';
        _insight = '';
        _lastLineWasAi = false;
      }

      if (_historyIndex < _sessionHistory.length - 1) {
        _sessionHistory = _sessionHistory.sublist(0, _historyIndex + 1);
      }

      _sessionHistory.add(_currentMessage);
      _historyIndex = _sessionHistory.length - 1;
      AnalyticsService.lineGenerated(_selectedCategory!.id, _lastLineWasAi);
      _state = GeneratorState.success;
      _totalGenerated++;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = GeneratorState.error;
      notifyListeners();
    }
  }

  // Visual Screenshot Analyzer
  Future<void> runScreenshotAnalysis(String base64Image, {String platform = 'WhatsApp'}) async {
    _state = GeneratorState.loading;
    _errorMessage = '';
    _screenshotAnalysis = null;
    notifyListeners();

    try {
      final res = await ApiService.analyzeScreenshot(base64Image: base64Image, platform: platform);
      _screenshotAnalysis = res;
      _state = GeneratorState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = GeneratorState.error;
      notifyListeners();
    }
  }

  // Red Flags analysis
  Future<void> runRedFlagsAnalysis(String text) async {
    _state = GeneratorState.loading;
    _errorMessage = '';
    _redFlagsAnalysis = null;
    notifyListeners();

    try {
      final res = await ApiService.analyzeRedFlags(conversationText: text);
      _redFlagsAnalysis = res;
      _state = GeneratorState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = GeneratorState.error;
      notifyListeners();
    }
  }

  // Rate My Rizz Scorer
  Future<void> runRizzScorer(String text) async {
    _state = GeneratorState.loading;
    _errorMessage = '';
    _rizzScoreAnalysis = null;
    notifyListeners();

    try {
      final res = await ApiService.scoreConversation(conversationText: text);
      _rizzScoreAnalysis = res;
      _state = GeneratorState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = GeneratorState.error;
      notifyListeners();
    }
  }

  // Voice Flirting
  Future<void> runVoiceRizz(String text) async {
    _state = GeneratorState.loading;
    _errorMessage = '';
    _voiceRizzData = null;
    notifyListeners();

    try {
      final res = await ApiService.voiceRizz(phrase: text);
      _voiceRizzData = res;
      _state = GeneratorState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = GeneratorState.error;
      notifyListeners();
    }
  }

  // Daily Feed Load
  Future<void> runDailyFeedLoad() async {
    _state = GeneratorState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final res = await ApiService.getDailyFeed();
      _dailyFeedData = res;
      _state = GeneratorState.success;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = GeneratorState.error;
      notifyListeners();
    }
  }

  // Submit Feedback
  Future<bool> sendAppFeedback(String name, String email, String comments) async {
    try {
      return await ApiService.submitFeedback(name: name, email: email, comments: comments);
    } catch (_) {
      return false;
    }
  }

  String _nextOfflineLine(String catId) {
    final queueKey = '$catId:${_arcStage.name}';
    var queue = _offlineQueue[queueKey];
    if (queue == null || queue.isEmpty) {
      queue = (_mixSources != null && _arcStage == ArcStage.opener)
          ? _buildMixedQueue(_mixSources!.$1, _mixSources!.$2)
          : shuffledArcLinesFor(
              _arcStage,
              _mixSources != null ? _mixSources!.$1.id : catId,
              name: _targetName.isEmpty ? null : _targetName,
              trait: _targetTrait.isEmpty ? null : _targetTrait,
            );
      _offlineQueue[queueKey] = queue;
    }
    final line = queue.removeAt(0);
    if (line == _currentMessage && queue.isNotEmpty) {
      queue.add(line);
      return queue.removeAt(0);
    }
    return line;
  }

  List<String> _buildMixedQueue(FlirtCategory a, FlirtCategory b) {
    final name = _targetName.isEmpty ? null : _targetName;
    final trait = _targetTrait.isEmpty ? null : _targetTrait;
    final poolA = shuffledLinesFor(a.id, name: name, trait: trait);
    final poolB = shuffledLinesFor(b.id, name: name, trait: trait);

    final combined = <String>[];
    final maxLen = poolA.length > poolB.length ? poolA.length : poolB.length;
    for (var i = 0; i < maxLen; i++) {
      if (i < poolA.length) combined.add(poolA[i]);
      if (i < poolB.length) combined.add(poolB[i]);
    }
    combined.shuffle();
    return combined;
  }

  String? _buildUserContext() {
    if (!isPersonalized) return null;
    final parts = <String>[];
    if (_targetName.isNotEmpty) parts.add('their name is $_targetName');
    if (_targetTrait.isNotEmpty) parts.add('they $_targetTrait');
    return 'Personalize the line: ${parts.join(' and ')}.';
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

  Future<void> toggleFavorite() async {
    if (_currentMessage.isEmpty || _selectedCategory == null) return;

    final existing = _favorites.indexWhere(
      (f) => f.message == _currentMessage && f.catId == _selectedCategory!.id,
    );

    if (existing >= 0) {
      _favorites.removeAt(existing);
    } else {
      AnalyticsService.lineFavorited(_selectedCategory!.id);
      _favorites.insert(
        0,
        FavoriteMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          catId: _selectedCategory!.id,
          catName: _selectedCategory!.name,
          catIconCodePoint: _selectedCategory!.icon.codePoint,
          message: _currentMessage,
          savedAt: DateTime.now(),
          arcStageLabel: _arcStage == ArcStage.opener ? null : _arcStage.label,
        ),
      );
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
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('fm_favorites');
      if (data != null) {
        final list = jsonDecode(data) as List;
        _favorites = list
            .map((e) => FavoriteMessage.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (_) {
      _favorites = [];
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'fm_favorites',
      jsonEncode(_favorites.map((f) => f.toJson()).toList()),
    );
  }

  Future<void> _loadPersonalization() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _targetName = prefs.getString('fm_target_name') ?? '';
      _targetTrait = prefs.getString('fm_target_trait') ?? '';
      _incomingMessage = prefs.getString('fm_incoming_msg') ?? '';
      if (isPersonalized) notifyListeners();
    } catch (_) {}
  }

  Future<void> _savePersonalization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fm_target_name', _targetName);
    await prefs.setString('fm_target_trait', _targetTrait);
    await prefs.setString('fm_incoming_msg', _incomingMessage);
  }

  Future<void> _loadVibe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('fm_vibe_id');
      if (saved != null) _vibeId = saved;
    } catch (_) {}
  }

  Future<void> _saveVibe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fm_vibe_id', _vibeId);
  }

  Future<void> _loadAdvancedMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userAge = prefs.getString('fm_user_age') ?? '';
      _userCountry = prefs.getString('fm_user_country') ?? '';
      _datingApp = prefs.getString('fm_dating_app') ?? 'Tinder';
      _relationshipStage = prefs.getString('fm_rel_stage') ?? 'Just chatting';
      _communicationStyle = prefs.getString('fm_comm_style') ?? 'Playful';
      _loveLanguage = prefs.getString('fm_love_lang') ?? 'Words of affirmation';
      _introvertExtrovert = prefs.getString('fm_personality') ?? 'Ambivert';
      _humorType = prefs.getString('fm_humor_type') ?? 'Witty';
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveAdvancedMemory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fm_user_age', _userAge);
    await prefs.setString('fm_user_country', _userCountry);
    await prefs.setString('fm_dating_app', _datingApp);
    await prefs.setString('fm_rel_stage', _relationshipStage);
    await prefs.setString('fm_comm_style', _communicationStyle);
    await prefs.setString('fm_love_lang', _loveLanguage);
    await prefs.setString('fm_personality', _introvertExtrovert);
    await prefs.setString('fm_humor_type', _humorType);
  }
}