import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/data/models/user.dart';

class UserRepository {
  Future<User> fetchUserData(String userId, String token) async {
    final response = await http.get(
      Uri.parse('https://backend-findjob.onrender.com/user/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
