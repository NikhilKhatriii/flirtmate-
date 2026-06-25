import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flirt_category.dart';
import '../models/vibe.dart';
import '../services/api_service.dart';
import '../data/offline_lines.dart';
import '../data/arc_lines.dart';

enum GeneratorState { idle, loading, success, error }

class FlirtProvider extends ChangeNotifier {
  // Generator state
  GeneratorState _state = GeneratorState.idle;
  String _currentMessage = '';
  String _errorMessage = '';
  FlirtCategory? _selectedCategory;
  List<String> _sessionHistory = [];
  int _historyIndex = -1;

  // Mood Mixer — when set, the two source categories whose lines are being
  // blended together. Null when a single, regular category is active.
  (FlirtCategory, FlirtCategory)? _mixSources;

  // Offline line bank cursor — tracks which shuffled lines have been shown
  // per category so a session doesn't repeat itself until the bank is
  // exhausted, then reshuffles.
  final Map<String, List<String>> _offlineQueue = {};

  // Personalization — both entirely optional. When set, lines are woven
  // around this person's name and/or a short trait/interest you give them
  // (e.g. "loves hiking", "plays guitar").
  String _targetName = '';
  String _targetTrait = '';

  // Vibe — an optional, user-picked situational context (e.g. "just met",
  // "reconnecting"). This is a fixed list the person chooses from; it is
  // never derived from analyzing any pasted-in conversation or message.
  String _vibeId = kNoVibe.id;

  // Tracks whether the most recent successful line came from the AI or
  // the offline fallback, so the UI can be transparent about which mode
  // actually produced the current line (useful when AI mode is configured
  // but a request silently failed and fell back).
  bool _lastLineWasAi = false;

  // Conversation Arc — which stage of a conversation the shown lines are
  // for: opener (the default, same as before), follow-up (what to say
  // after a good reply), or deeper (genuine questions once it's flowing).
  // Switching stages re-keys the offline queue so stages never bleed into
  // each other or exhaust one another's content pool.
  ArcStage _arcStage = ArcStage.opener;

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
  bool get isPersonalized => _targetName.isNotEmpty || _targetTrait.isNotEmpty;
  Vibe get selectedVibe => vibeById(_vibeId);
  bool get hasVibe => _vibeId != kNoVibe.id;
  bool get isCustomized => isPersonalized || hasVibe;
  bool get lastLineWasAi => _lastLineWasAi;
  ArcStage get arcStage => _arcStage;

  /// Whether live AI generation is available (i.e. an API key was configured).
  /// When false, the app transparently uses the offline line bank instead.
  bool get isAiAvailable => ApiService.isConfigured;

  bool isFavorited(String message) =>
      _favorites.any((f) => f.message == message && f.catId == _selectedCategory?.id);

  FlirtProvider() {
    _loadFavorites();
    _loadPersonalization();
    _loadVibe();
  }

  /// Updates the name/trait used to personalize lines. Either can be left
  /// blank. Clears the offline queue for the current category's opener
  /// stage so the new personalization takes effect on the very next
  /// generated line, rather than waiting for the old (unpersonalized)
  /// queue to drain first. Only the opener stage is keyed by
  /// personalization — follow-up/deeper lines don't use it — so only that
  /// queue needs clearing.
  Future<void> setPersonalization({String? name, String? trait}) async {
    _targetName = (name ?? _targetName).trim();
    _targetTrait = (trait ?? _targetTrait).trim();
    if (_selectedCategory != null) {
      _offlineQueue.remove('${_selectedCategory!.id}:${ArcStage.opener.name}');
    }
    notifyListeners();
    await _savePersonalization();
  }

  /// Updates the active vibe (situational context). Pass `kNoVibe.id` (or
  /// call with null) to clear it back to "no specific vibe". This only
  /// affects AI-mode prompting — the offline bank doesn't currently have
  /// vibe-specific lines, so vibe has no effect when running offline.
  Future<void> setVibe(String? vibeId) async {
    _vibeId = vibeId ?? kNoVibe.id;
    notifyListeners();
    await _saveVibe();
  }

  /// Switches which stage of the Conversation Arc is active. Clears the
  /// current line/history so the screen doesn't show an opener line
  /// labeled as a follow-up (or vice versa) right after switching.
  ///
  /// Note: when the Mood Mixer is active, follow-up and deeper stages use
  /// only the first of the two mixed categories — blending two categories'
  /// worth of follow-up lines together reads as confusing rather than
  /// genuinely mixed, so this keeps it simple and predictable instead.
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
    _mixSources = null;
    _sessionHistory = [];
    _historyIndex = -1;
    _currentMessage = '';
    _state = GeneratorState.idle;
    notifyListeners();
  }

  /// Mood Mixer: blends two categories together into one combined style.
  /// Generated lines are pulled alternately from each source category's
  /// offline pool (or, in AI mode, generated from a combined style hint).
  void selectMixedCategories(FlirtCategory a, FlirtCategory b) {
    _mixSources = (a, b);
    _selectedCategory = buildMixedCategory(a, b);
    _sessionHistory = [];
    _historyIndex = -1;
    _currentMessage = '';
    _state = GeneratorState.idle;
    notifyListeners();
  }

  bool get isMixed => _mixSources != null;

  Future<void> generateLine() async {
    if (_selectedCategory == null || _state == GeneratorState.loading) return;

    _state = GeneratorState.loading;
    _errorMessage = '';
    notifyListeners();

    final catId = _selectedCategory!.id;

    try {
      String line;

      // AI generation is only used for the opener stage. Follow-up and
      // "going deeper" lines are served from curated content always, even
      // when an AI key is configured — these are more delicate moments in
      // a conversation, and reliably appropriate pre-written lines are a
      // better fit here than open-ended generation.
      if (ApiService.isConfigured && _arcStage == ArcStage.opener) {
        // AI mode: try live generation, but gracefully fall back to the
        // offline bank if the request fails for any reason (no internet,
        // rate limit, bad key, etc.) instead of showing an error screen.
        try {
          line = await ApiService.generatePickupLine(
            category: _selectedCategory!,
            recentLines: _sessionHistory,
            vibe: hasVibe ? selectedVibe : null,
            userContext: _buildUserContext(),
          );
          _lastLineWasAi = true;
        } catch (_) {
          line = _nextOfflineLine(catId);
          _lastLineWasAi = false;
        }
      } else {
        // Default offline mode — instant, free, works with no setup.
        // Small artificial delay so the loading/shimmer animation still
        // reads as intentional rather than glitchy.
        await Future.delayed(const Duration(milliseconds: 550));
        line = _nextOfflineLine(catId);
        _lastLineWasAi = false;
      }

      // Truncate history if we navigated back before generating new
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

  /// Pulls the next line from a per-category-and-stage shuffled queue,
  /// reshuffling (and avoiding an immediate repeat) once the queue runs
  /// dry. The queue is generated with current name/trait personalization
  /// baked in (opener stage only — see [shuffledArcLinesFor]).
  ///
  /// When the Mood Mixer is active (`_mixSources` set) and the stage is
  /// the opener, the queue instead interleaves shuffled lines from both
  /// source categories. For follow-up/deeper stages, mixing is skipped in
  /// favor of just the first mixed category (see [setArcStage]).
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
    // Avoid showing the exact same line twice in a row if possible.
    if (line == _currentMessage && queue.isNotEmpty) {
      queue.add(line);
      return queue.removeAt(0);
    }
    return line;
  }

  /// Builds a combined, shuffled queue from two categories' offline pools.
  /// Lines are tagged with a small label so it's clear which "half" of
  /// the blend each line is leaning toward, which reads more like an
  /// intentional mix than two unrelated categories taking turns.
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

  /// Builds a short natural-language hint for the AI service describing
  /// the personalization, so AI-generated lines benefit from it too.
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

  // Favorites management
  Future<void> toggleFavorite() async {
    if (_currentMessage.isEmpty || _selectedCategory == null) return;

    final existing = _favorites.indexWhere(
          (f) => f.message == _currentMessage && f.catId == _selectedCategory!.id,
    );

    if (existing >= 0) {
      _favorites.removeAt(existing);
    } else {
      _favorites.insert(
        0,
        FavoriteMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          catId: _selectedCategory!.id,
          catName: _selectedCategory!.name,
          // Store the icon's codePoint rather than an emoji string so it
          // round-trips cleanly through JSON and renders via IconData.
          catIconCodePoint: _selectedCategory!.icon.codePoint,
          message: _currentMessage,
          savedAt: DateTime.now(),
          arcStageLabel:
          _arcStage == ArcStage.opener ? null : _arcStage.label,
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
      // Corrupted or missing local storage — start with an empty list
      // rather than crashing the app on launch.
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
      if (isPersonalized) notifyListeners();
    } catch (_) {
      // No saved personalization yet, or storage unavailable — fine to
      // just start with the defaults (blank/unpersonalized).
    }
  }

  Future<void> _savePersonalization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fm_target_name', _targetName);
    await prefs.setString('fm_target_trait', _targetTrait);
  }

  Future<void> _loadVibe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString('fm_vibe_id');
      if (saved != null) _vibeId = saved;
    } catch (_) {
      // No saved vibe yet, or storage unavailable — default ("no specific
      // vibe") is already set, so there's nothing else to do here.
    }
  }

  Future<void> _saveVibe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fm_vibe_id', _vibeId);
  }
}