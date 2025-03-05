import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ZhipuAIService {
  static const String _baseUrl = 'https://open.bigmodel.cn/api/paas/v4/chat/completions';
  static const String _apiKey = '5a7c25521ff4decf32e39782aec49412.fbQw47ylO00bvWgQ';
  static const String _model = 'glm-4-flash';

  // Send a message to Zhipu AI and get a response
  Future<String> sendMessage(String message, List<Map<String, String>> history) async {
    try {
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'model': _model,
        'messages': [
          ...history.map((msg) => {
                'role': msg['role'],
                'content': msg['content'],
              }),
          {
            'role': 'user',
            'content': message,
          },
        ],
        'temperature': 0.7,
        'top_p': 0.8,
        'max_tokens': 1500,
      };

      // Prepare the request headers
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      };

      // Send the request
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Extract the AI's response
        final String aiResponse = responseData['choices'][0]['message']['content'];
        return aiResponse;
      } else {
        // Handle error response
        debugPrint('Error response: ${response.statusCode} - ${response.body}');
        return 'Sorry, I encountered an error while processing your request. Please try again later.';
      }
    } catch (e) {
      // Handle exceptions
      debugPrint('Exception in ZhipuAIService: $e');
      return 'Sorry, I encountered an error while processing your request. Please try again later.';
    }
  }
} 