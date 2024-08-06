import 'package:http/http.dart' as http;
import 'package:turnstileuser_v2/globals.dart' as globals;
import '../../../globals.dart';

class APIService {
  static const String baseUrl = 'http://44.214.230.69:8000/loginapi/'; // Replace with your API base URL

  // Example function to make a POST request to login
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl');
    final body = ({'email': email, 'password': password});

    try {
      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        // Add any required headers here
      });

      if (response.statusCode == 200) {
        globals.loggedInUserEmail = email;
        print(loggedInUserEmail);
        // Successful login logic
        return true;
      } else {
        // Handle error responses
        print('Failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }
}
