import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flirt_category.dart';
import '../models/vibe.dart';

/// Optional AI enhancement layer.
///
/// FlirtMate works fully offline out of the box using the curated line bank
/// in `data/offline_lines.dart`. This service is an *optional* upgrade for
/// users who add their own free OpenRouter API key — it generates fresh,
/// never-before-seen lines on demand instead of pulling from the offline bank.
///
/// To enable it:
///   1. Go to https://openrouter.ai → sign up (free, no card required)
///   2. Create a key under the "Keys" tab
///   3. Paste it below, replacing `_apiKey`
///
/// If no key is set, [isConfigured] returns false and the app will simply
/// use the offline line bank — no errors, no broken UI.
///
/// IMPORTANT — what "personalization" means here: every input this service
/// accepts (category, vibe, name, trait) is something the user explicitly
/// typed or picked themselves. This service never reads, imports, or
/// analyzes another person's actual messages/chat history to generate a
/// line aimed at them — that's a deliberate boundary, not a missing feature.
class ApiService {
  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  // Optional: paste your free OpenRouter API key here to enable live AI
  // generation. Leave as-is to use the built-in offline content instead.
  static const String _apiKey = 'YOUR_OPENROUTER_API_KEY_HERE';

  static const String _model = 'mistralai/mistral-7b-instruct:free';

  /// Whether a real API key has been configured.
  static bool get isConfigured =>
      _apiKey.isNotEmpty && _apiKey != 'YOUR_OPENROUTER_API_KEY_HERE';

  /// Generates one line, optionally retrying a small number of times if the
  /// model returns something that's an exact or near-exact repeat of a
  /// recent line — this matters more now that the avoid-list is part of a
  /// richer prompt that the model might otherwise latch onto too literally.
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
        // Otherwise loop and try once more for a fresher line.
      } catch (e) {
        lastError = e;
        break; // Don't retry on a hard failure (bad key, no internet, etc.)
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
    // Up to 8 recent lines in the avoid-list, not just 5 — meaningfully
    // cuts down on repeats over a longer swiping session.
    final avoidList = recentLines.take(8).join(' | ');
    final activeVibe = (vibe == null || vibe.id == kNoVibe.id) ? null : vibe;

    final prompt = '''Generate exactly ONE sophisticated, high-class flirty pickup line or message for the "${category.name}" style.

Style description: ${category.styleHint}
Tagline: "${category.tagline}"
${activeVibe != null ? '\nSituation: ${activeVibe.promptHint}' : ''}

Rules:
- Output ONLY the line itself — no quotes, no labels, no explanation
- Make it feel genuinely crafted and unique — not generic or clichéd
- High-class language: witty, charming, intelligent
- Length: 1 to 3 sentences maximum
- Never sound desperate or cheap
${avoidList.isNotEmpty ? '- Do NOT repeat or closely resemble any of these recent lines: $avoidList' : ''}
${userContext != null ? '- Context hint: $userContext' : ''}

Respond with only the pickup line, nothing else.''';

    http.Response response;
    try {
      response = await http
          .post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://flirtmate.app',
          'X-Title': 'FlirtMate',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content':
              'You are a master of sophisticated, high-class romantic wit. '
                  'You craft original, charming pickup lines with elegance and '
                  'creativity. You respond with only the requested line — nothing else.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 150,
          'temperature': 0.95,
          'top_p': 0.95,
        }),
      )
          .timeout(const Duration(seconds: 20));
    } on Exception catch (e) {
      throw Exception(
        'Could not reach the AI service. Check your internet connection. ($e)',
      );
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = (data['choices'][0]['message']['content'] as String)
          .trim()
          .replaceAll(RegExp(r'^["\u201c]|["\u201d]$'), '')
          .trim();
      if (text.isNotEmpty) return text;
      throw Exception('The AI returned an empty response. Please try again.');
    }

    throw Exception(_describeError(response.statusCode));
  }

  /// Translates an HTTP status code into a message that actually tells the
  /// person what's wrong, instead of a bare "API error: 401" — the kind of
  /// thing that otherwise takes a support conversation to decode.
  static String _describeError(int statusCode) {
    switch (statusCode) {
      case 401:
        return 'Your API key was rejected (401). Double-check the key in '
            'api_service.dart — it may be missing, mistyped, or expired.';
      case 402:
        return 'OpenRouter reports insufficient credit (402) for this key. '
            'Free models should not require credit — check your account.';
      case 404:
        return 'The selected model could not be found (404). It may have '
            'been renamed or retired — check openrouter.ai/models for the '
            'current free model name.';
      case 429:
        return 'Rate limit reached (429). Wait a short moment and try again.';
      case 500:
      case 502:
      case 503:
        return 'The AI service is temporarily unavailable ($statusCode). '
            'Please try again shortly.';
      default:
        return 'AI request failed with status $statusCode.';
    }
  }
}
