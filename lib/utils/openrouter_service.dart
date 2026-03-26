import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OpenRouterService { final String apiKey = dotenv.env['OPENROUTER_API_KEY']!;

  Future<Map<String, dynamic>> generateQuestion() async {
    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content":
                "Return ONLY valid JSON. No text.\n\nGenerate a logic question in Arabic like this EXACT format:\n{\n\"question\": \"...\",\n\"options\": [\"A\",\"B\",\"C\",\"D\"],\n\"correctIndex\": 0\n}"
          }
        ],
        "temperature": 0.7,
        "max_tokens": 200,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['choices'][0]['message']['content'];

      print("RAW AI RESPONSE:\n$text");
      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");
      /// 🔥 Extract JSON safely
      final start = text.indexOf('{');
      final end = text.lastIndexOf('}') + 1;

      if (start == -1 || end == -1) {
        throw Exception("Invalid AI response format");
      }

      final jsonString = text.substring(start, end);

      final parsed = jsonDecode(jsonString);

      return parsed;
    } else {
      throw Exception('API Error: ${response.body}');
    }
  }
  
}