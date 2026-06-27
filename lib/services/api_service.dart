import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import '../models/flirt_category.dart';
import '../models/vibe.dart';

/// AI enhancement layer.
class ApiService {
  /// Dynamically resolves the backend host based on the current platform.
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api';
    }
    try {
      if (Platform.isAndroid) {
        // Try Android Emulator or fall back to local IP for physical testing
        return 'http://10.0.2.2:5000/api';
      }
    } catch (_) {}
    return 'http://localhost:5000/api';
  }

  static bool get isConfigured => true;

  static Future<Map<String, dynamic>> generatePickupLineExtended({
    required FlirtCategory category,
    required List<String> recentLines,
    required String languageCode,
    Vibe? vibe,
    String? userContext,
    String? incomingMessage,
    String age = '',
    String country = '',
    String datingApp = '',
    String relationshipStage = '',
    String communicationStyle = '',
    String loveLanguage = '',
    String introvertExtrovert = '',
    String humorType = '',
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'category': {'name': category.name, 'styleHint': category.styleHint, 'tagline': category.tagline},
        'languageCode': languageCode,
        'recentLines': recentLines,
        'vibe': vibe != null && vibe.id != kNoVibe.id ? {'id': vibe.id, 'promptHint': vibe.promptHint} : null,
        'userContext': userContext,
        'incomingMessage': incomingMessage,
        'age': age,
        'country': country,
        'datingApp': datingApp,
        'relationshipStage': relationshipStage,
        'communicationStyle': communicationStyle,
        'loveLanguage': loveLanguage,
        'introvertExtrovert': introvertExtrovert,
        'humorType': humorType,
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data'] ?? {});
    }
    throw Exception(_describeError(response.statusCode, response.body));
  }

  static Future<Map<String, dynamic>> analyzeScreenshot({
    required String base64Image,
    String platform = 'WhatsApp',
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/analyze-screenshot'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'image': base64Image,
        'platform': platform,
      }),
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data'] ?? {});
    }
    throw Exception(_describeError(response.statusCode, response.body));
  }

  static Future<Map<String, dynamic>> analyzeRedFlags({
    required String conversationText,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/redflags'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'incomingMessage': conversationText,
      }),
    ).timeout(const Duration(seconds: 25));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data'] ?? {});
    }
    throw Exception(_describeError(response.statusCode, response.body));
  }

  static Future<Map<String, dynamic>> scoreConversation({
    required String conversationText,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/score'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'incomingMessage': conversationText,
      }),
    ).timeout(const Duration(seconds: 25));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data'] ?? {});
    }
    throw Exception(_describeError(response.statusCode, response.body));
  }

  static Future<Map<String, dynamic>> voiceRizz({
    required String phrase,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/voice-rizz'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'incomingMessage': phrase,
      }),
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data'] ?? {});
    }
    throw Exception(_describeError(response.statusCode, response.body));
  }

  static Future<Map<String, dynamic>> getDailyFeed() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/daily'),
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data['data'] ?? {});
    }
    throw Exception(_describeError(response.statusCode, response.body));
  }

  static Future<bool> submitFeedback({
    required String name,
    required String email,
    required String comments,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/feedback'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'comments': comments,
      }),
    ).timeout(const Duration(seconds: 15));

    return response.statusCode == 200;
  }

  static Future<String> generatePickupLine({
    required FlirtCategory category,
    required List<String> recentLines,
    required String languageCode,
    Vibe? vibe,
    String? userContext,
    String? incomingMessage,
    int maxAttempts = 2,
  }) async {
    Object? lastError;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final line = await _requestOne(
          category: category,
          recentLines: recentLines,
          languageCode: languageCode,
          vibe: vibe,
          userContext: userContext,
          incomingMessage: incomingMessage,
        );
        final isDuplicate = recentLines.any(
          (r) => r.trim().toLowerCase() == line.trim().toLowerCase(),
        );
        if (!isDuplicate || attempt == maxAttempts - 1) return line;
      } catch (e) {
        lastError = e;
        break;
      }
    }
    if (lastError != null) throw lastError;
    throw Exception('Could not generate a line. Please try again.');
  }

  static Future<String> _requestOne({
    required FlirtCategory category,
    required List<String> recentLines,
    required String languageCode,
    Vibe? vibe,
    String? userContext,
    String? incomingMessage,
  }) async {
    http.Response response;
    try {
      response = await http.post(
        Uri.parse('$_baseUrl/generate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'category': {
            'name': category.name,
            'styleHint': category.styleHint,
            'tagline': category.tagline,
          },
          'languageCode': languageCode,
          'recentLines': recentLines,
          'vibe': vibe != null && vibe.id != kNoVibe.id ? {'id': vibe.id, 'promptHint': vibe.promptHint} : null,
          'userContext': userContext,
          'incomingMessage': incomingMessage,
        }),
      ).timeout(const Duration(seconds: 15));
    } on Exception catch (e) {
      throw Exception('Could not connect to the backend server. Make sure it is running. ($e)');
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = (data['data']?['main'] ?? data['line'] ?? data['pickup_line'] ?? '').toString().trim();
      if (text.isNotEmpty) return text;
      throw Exception('The AI returned an empty response. Please try again.');
    }
    throw Exception(_describeError(response.statusCode, response.body));
  }

  static String _describeError(int statusCode, String responseBody) {
    try {
      final data = jsonDecode(responseBody);
      if (data is Map && data.containsKey('error')) {
        return data['error'].toString();
      }
    } catch (_) {}

    switch (statusCode) {
      case 401:
        return 'Groq API key was rejected (401). Double-check the key in backend/.env.';
      case 404:
        return 'The selected Groq model could not be found (404). Check backend/.env.';
      case 429:
        return 'Groq API rate limit reached (429). Wait a short moment and try again.';
      case 500:
        return 'Backend server encountered an internal error (500). Please check backend logs.';
      default:
        return 'Backend request failed with status $statusCode.';
    }
  }
}
