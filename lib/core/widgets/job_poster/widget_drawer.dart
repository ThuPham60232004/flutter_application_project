import 'package:flutter/material.dart';
import 'package:flutter_application_project/presentation/screens/client/home_screen.dart';
import 'package:flutter_application_project/presentation/screens/login_screen.dart';
import 'package:flutter_application_project/presentation/screens/signup_screen.dart';
import 'package:flutter_application_project/presentation/screens/account_screen.dart';
import 'package:flutter_application_project/presentation/screens/contact_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_project/presentation/screens/post_job/job_screen.dart';
import 'package:flutter_application_project/presentation/screens/post_job/company_profile.dart';
import 'package:flutter_application_project/presentation/screens/post_job/application.dart';
class PosterDrawer extends StatefulWidget {
  @override
  _PosterDrawerState createState() => _PosterDrawerState();
}

class _PosterDrawerState extends State<PosterDrawer> {
  String? name;
  String? profileImage;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
    _checkLoginStatus();
  }

  Future<void> _initializeDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('name') == null) {
      await prefs.setString('name', 'Guest');
      await prefs.setString('profile_image', '');
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      profileImage = prefs.getString('img');
      isLoggedIn = name != null;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      name = null;
      profileImage = null;
      isLoggedIn = false;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _buildMenuItem(Icons.home, 'Trang chủ', HomeScreen(), Colors.blue),
  _buildMenuItem(
      isLoggedIn ? Icons.logout : Icons.login,
      isLoggedIn ? 'Đăng xuất' : 'Đăng nhập',
      LoginScreen(),
      isLoggedIn ? Colors.red : Colors.green),
  if (!isLoggedIn)
    _buildMenuItem(Icons.person_add, 'Đăng ký', SignUpScreen(), Colors.orange),
    _buildMenuItem(Icons.contact_mail, 'Liên hệ', ContactScreen(), Colors.blueGrey),
    _buildMenuItem(Icons.account_circle, 'Tài khoản', AccoutScreen(), Colors.deepPurple),
    _buildMenuItem(Icons.work, 'Quản lý thông tin công việc', JobListPage(), Colors.amber),
    _buildMenuItem(Icons.business, 'Quản lý thông tin công ty', CompanyProfilePage(), Colors.cyan),
    _buildMenuItem(Icons.assignment, 'Quản lý đơn ứng tuyển', JobApplicationPage(), Colors.pinkAccent),
    // _buildMenuItem(Icons.article, 'Chi tiết blog', BlogDetail(), Colors.amber),
    ];
    return Drawer(
      child: ListView(
        children: [
          _buildUserProfile(),
          const Divider(),
          ...menuItems,
        ],
      ),
    );
  }

  ListTile _buildMenuItem(
      IconData icon, String title, Widget screen, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: title == 'Đăng xuất'
          ? _logout
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 40,
            backgroundImage: profileImage != null && profileImage!.isNotEmpty
                ? NetworkImage(profileImage!)
                : const AssetImage('assets/icons/nen.png') as ImageProvider,
          ),
          const SizedBox(height: 20),
          Text(
            'Xin chào, ${name ?? "Khách"}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Người đăng tin',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
