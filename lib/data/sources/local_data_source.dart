import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  Future<void> saveUserData(String token, String name, String profileImage,String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('profile_image', profileImage);
    await prefs.setString('id', id);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id'); 
  }
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('profile_image');
    await prefs.remove('id');
  }
}
