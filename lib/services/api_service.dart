import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import '../models/flirt_category.dart';
import '../models/vibe.dart';

/// AI enhancement layer.
///
/// FlirtMate generates fresh, never-before-seen lines on demand using a local
/// Python backend integrated with the Groq API.
///
/// If the backend is not running or encounters an error, the app will
/// gracefully fallback to the built-in offline line bank.
class ApiService {
  /// Dynamically resolves the backend host based on the current platform.
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5000/api/generate';
    }
    try {
      if (Platform.isAndroid) {
        // Android emulator sees your local machine at 10.0.2.2
        return 'http://10.0.2.2:5000/api/generate';
      }
    } catch (_) {}
    return 'http://localhost:5000/api/generate';
  }

  /// Whether AI generation is configured/enabled.
  /// Since the API key is secured on the backend, we assume it is configured
  /// and let the backend return an error if it lacks a key.
  static bool get isConfigured => true;

  /// Generates one line, optionally retrying if the model returns a duplicate.
  static Future<String> generatePickupLine({
    required FlirtCategory category,
    required List<String> recentLines,
    Vibe? vibe,
    String? userContext,
    int maxAttempts = 2,
  }) async {
    Object? lastError;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        final line = await _requestOne(
          category: category,
          recentLines: recentLines,
          vibe: vibe,
          userContext: userContext,
        );
        final isDuplicate = recentLines.any(
          (r) => r.trim().toLowerCase() == line.trim().toLowerCase(),
        );
        if (!isDuplicate || attempt == maxAttempts - 1) return line;
      } catch (e) {
        lastError = e;
        break; // Don't retry on a hard failure (no internet, server offline, etc.)
      }
    }
    if (lastError != null) throw lastError;
    throw Exception('Could not generate a line. Please try again.');
  }

  static Future<String> _requestOne({
    required FlirtCategory category,
    required List<String> recentLines,
    Vibe? vibe,
    String? userContext,
  }) async {
    http.Response response;
    try {
      response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'category': {
                'name': category.name,
                'styleHint': category.styleHint,
                'tagline': category.tagline,
              },
              'recentLines': recentLines,
              'vibe': vibe != null && vibe.id != kNoVibe.id
                  ? {
                      'id': vibe.id,
                      'promptHint': vibe.promptHint,
                    }
                  : null,
              'userContext': userContext,
            }),
          )
          .timeout(const Duration(seconds: 15));
    } on Exception catch (e) {
      throw Exception(
        'Could not connect to the backend server. Make sure it is running. ($e)',
      );
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = (data['line'] as String).trim();
      if (text.isNotEmpty) return text;
      throw Exception('The AI returned an empty response. Please try again.');
    }

    throw Exception(_describeError(response.statusCode, response.body));
  }

  /// Translates backend error messages and status codes.
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

