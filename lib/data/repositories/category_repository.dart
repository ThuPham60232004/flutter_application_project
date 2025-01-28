import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/data/models/category.dart';

class CategoryRepository {
  final String apiUrl = 'https://backend-findjob.onrender.com/category';
  Future<Category?> createCategory(
      String name, String description, String icon) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'icon': icon,
        }),
      );

      if (response.statusCode == 201) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create category');
      }
    } catch (e) {
      print('Error creating category: $e');
      throw Exception('Error creating category');
    }
  }

  Future<Category?> updateCategory(
      String id, String name, String description, String icon) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'icon': icon,
        }),
      );

      if (response.statusCode == 200) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update category');
      }
    } catch (e) {
      print('Error updating category: $e');
      throw Exception('Error updating category');
    }
  }

  Future<Category?> getCategoryById(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch category by ID');
      }
    } catch (e) {
      print('Error fetching category by ID: $e');
      throw Exception('Error fetching category by ID');
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Error fetching categories');
    }
  }

  Future<bool> deleteCategoryById(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete category by ID');
      }
    } catch (e) {
      print('Error deleting category by ID: $e');
      throw Exception('Error deleting category by ID');
    }
  }

  Future<bool> deleteAllCategories() async {
    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete all categories');
      }
    } catch (e) {
      print('Error deleting all categories: $e');
      throw Exception('Error deleting all categories');
    }
  }

  Future<int> countCategories() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/count'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      } else {
        throw Exception('Failed to count categories');
      }
    } catch (e) {
      print('Error counting categories: $e');
      throw Exception('Error counting categories');
    }
  }
}
