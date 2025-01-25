import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/data/models/user.dart';

class AuthRepository {
final String apiUrl = 'http://192.168.1.213:2000/user';

  Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final details = data['details'] ?? {};
        return User(
          id: details['_id'] ?? 'Unknown Name',
          token: data['token'] ?? 'Unknown Token',
          name: details['name'] ?? 'Unknown Name',
          profileImage: details['profile_image'] ?? '',
          email: details['email'] ?? '',
          role: details['role'] ?? '',
          isEmployee: details['isEmployee'] ?? false,
        );
      } else {
        print('Login failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Login error');
    }
  }

  Future<User?> registerUser(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'role': 'job_seeker',
        'resume': '',
        'companyId': '',
        'phone': '',
        'isEmployee': false,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Đăng ký thất bại');
    }
  }
}