import 'dart:convert';
import 'package:http/http.dart' as http;

class TAPIService {
  static const String baseUrl = 'http://44.214.230.69:8000'; // Replace with your API base URL

  static Future<Map<String, dynamic>> signUp(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/signupapi/');
    final body = jsonEncode({'name': name, 'email': email, 'password': password});

    try {
      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 201) {
        return {'success': true};
      } else {
        final responseBody = jsonDecode(response.body);
        return {'success': false, 'error': responseBody['error']};
      }
    } catch (e) {
      print('Error during signup: $e');
      return {'success': false, 'error': 'An error occurred during signup'};
    }
  }
}
