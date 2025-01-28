import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/data/models/application.dart';

class ApplicationRepository {
  final String apiUrl = 'https://backend-findjob.onrender.com/application';
  Future<Application?> createApplication(
      Map<String, dynamic> applicationData) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(applicationData),
      );

      if (response.statusCode == 201) {
        return Application.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create application');
      }
    } catch (e) {
      print('Error creating application: $e');
      throw Exception('Error creating application');
    }
  }

  Future<Application?> updateApplicationById(
      String id, Map<String, dynamic> updateData) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        return Application.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update application by ID');
      }
    } catch (e) {
      print('Error updating application by ID: $e');
      throw Exception('Error updating application by ID');
    }
  }

  Future<bool> updateAllApplications(Map<String, dynamic> updateData) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update all applications');
      }
    } catch (e) {
      print('Error updating all applications: $e');
      throw Exception('Error updating all applications');
    }
  }

  Future<Application?> getApplicationById(String id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        return Application.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch application by ID');
      }
    } catch (e) {
      print('Error fetching application by ID: $e');
      throw Exception('Error fetching application by ID');
    }
  }

  Future<List<Application>> getAllApplications() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Application.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch all applications');
      }
    } catch (e) {
      print('Error fetching all applications: $e');
      throw Exception('Error fetching all applications');
    }
  }

  Future<bool> deleteApplicationById(String id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete application by ID');
      }
    } catch (e) {
      print('Error deleting application by ID: $e');
      throw Exception('Error deleting application by ID');
    }
  }

  Future<bool> deleteAllApplications() async {
    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete all applications');
      }
    } catch (e) {
      print('Error deleting all applications: $e');
      throw Exception('Error deleting all applications');
    }
  }

  Future<int> countApplications() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/count'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      } else {
        throw Exception('Failed to count applications');
      }
    } catch (e) {
      print('Error counting applications: $e');
      throw Exception('Error counting applications');
    }
  }
}
