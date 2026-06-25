import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flirt_category.dart';

/// Uses OpenRouter free tier (no credit card needed)
/// Free models: mistralai/mistral-7b-instruct (completely free)
/// Sign up at: https://openrouter.ai (free, instant)
class ApiService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  
  // Replace with your FREE OpenRouter API key from https://openrouter.ai
  static const String _apiKey = 'YOUR_OPENROUTER_API_KEY_HERE';
  
  // Free model - no credits needed
  static const String _model = 'mistralai/mistral-7b-instruct:free';

  static Future<String> generatePickupLine({
    required FlirtCategory category,
    required List<String> recentLines,
    String? userContext,
  }) async {
    final avoidList = recentLines.take(5).join(' | ');
    
    final prompt = '''Generate exactly ONE sophisticated, high-class flirty pickup line or message for the "${category.name}" style.

Style description: ${category.styleHint}
Tagline: "${category.tagline}"

Rules:
- Output ONLY the line itself — no quotes, no labels, no explanation
- Make it feel genuinely crafted and unique — not generic or clichéd  
- High-class language: witty, charming, intelligent
- Length: 1 to 3 sentences maximum
- Never sound desperate or cheap
${avoidList.isNotEmpty ? '- Do NOT repeat or resemble any of these recent lines: $avoidList' : ''}
${userContext != null ? '- Context hint: $userContext' : ''}

Respond with only the pickup line, nothing else.''';

    try {
      final response = await http.post(
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
              'content': 'You are a master of sophisticated, high-class romantic wit. You craft original, charming pickup lines with elegance and creativity. You respond with only the requested line — nothing else.',
            },
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 150,
          'temperature': 0.92,
          'top_p': 0.95,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = (data['choices'][0]['message']['content'] as String)
            .trim()
            .replaceAll(RegExp("^[\"']|[\"']\$"), '')
            .trim();
        if (text.isNotEmpty) return text;
      }
      throw Exception('API error: ${response.statusCode}');
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}
