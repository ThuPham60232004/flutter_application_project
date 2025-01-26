import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('role', details['role'] ?? '');
        return User(
          id: details['_id'] ?? '',
          token: data['token'] ?? '',
          name: details['name'] ?? '',
          profileImage: details['profile_image'] ?? '',
          email: details['email'] ?? '',
          role: details['role'] ?? '',
          
          isEmployee: details['isEmployee'] ?? false,
        );
      } else {
        final errorMessage = json.decode(response.body)['message'] ?? 'Login failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // Register API
  Future<User?> registerUser(String email, String password, String name) async {
    try {
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
        final errorMessage = json.decode(response.body)['message'] ?? 'Registration failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }
}
