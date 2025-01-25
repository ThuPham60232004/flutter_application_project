// sources/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://localhost:2000'});

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
