import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  Future<void> saveUserData(String token, String name, String profileImage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('name', name);
    await prefs.setString('profile_image', profileImage);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
