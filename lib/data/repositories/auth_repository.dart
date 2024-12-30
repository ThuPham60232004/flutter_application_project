import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/data/models/user.dart';

class AuthRepository {
  final String apiUrl = 'http://localhost:2000/user/login';

  Future<User?> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Login failed');
    }
  }
}
