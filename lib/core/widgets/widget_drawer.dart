import 'package:flutter/material.dart';
import 'package:flutter_application_project/presentation/screens/home_screen.dart';
import 'package:flutter_application_project/presentation/screens/login_screen.dart';
import 'package:flutter_application_project/presentation/screens/signup_screen.dart';
import 'package:flutter_application_project/presentation/screens/menu_career.dart';
import 'package:flutter_application_project/presentation/screens/careerdetail_screen.dart';
import 'package:flutter_application_project/presentation/screens/company_screen.dart';
import 'package:flutter_application_project/presentation/screens/companydetail_screen.dart';
import 'package:flutter_application_project/presentation/screens/profile_screen.dart';
import 'package:flutter_application_project/presentation/screens/contact_screen.dart';
import 'package:flutter_application_project/presentation/screens/blogdetail_screen.dart';
import 'package:flutter_application_project/presentation/screens/cv_screen.dart';
import 'package:flutter_application_project/presentation/screens/entercode_screen.dart';
import 'package:flutter_application_project/presentation/screens/forgetpass_screen.dart';
import 'package:flutter_application_project/presentation/screens/resetpass_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? name;
  String? profileImage;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name');
      profileImage = prefs.getString('profile_image');
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
      _buildMenuItem(Icons.home, 'Home', HomeScreen(), Colors.blue),
      _buildMenuItem(Icons.login, isLoggedIn ? 'Logout' : 'Login', LoginScreen(), Colors.green),
      if (!isLoggedIn) _buildMenuItem(Icons.app_registration, 'Register', SignUpScreen(), Colors.orange),
      _buildMenuItem(Icons.badge, 'Career', MenuCareer(), Colors.teal),
      _buildMenuItem(Icons.description, 'Career Details', CareerDetail(), Colors.indigo),
      _buildMenuItem(Icons.business, 'Company', CompanyScreen(), Colors.purple),
      _buildMenuItem(Icons.info, 'Company Details', CompanyDetail(), Colors.deepPurple),
      _buildMenuItem(Icons.contacts, 'Contact', ContactScreen(), Colors.blueGrey),
      _buildMenuItem(Icons.person, 'Profile', ProfileScreen(), Colors.cyan),
      _buildMenuItem(Icons.article, 'Blog Details', BlogDetail(), Colors.amber),
      _buildMenuItem(Icons.insert_drive_file, 'CV', CVScreen(), Colors.lightGreen),
      _buildMenuItem(Icons.code, 'Enter Code', EnterCodeScreen(), Colors.deepOrange),
      _buildMenuItem(Icons.lock_open, 'Forget Password', ForgetPassScreen(), Colors.redAccent),
      _buildMenuItem(Icons.lock_reset, 'Reset Password', ResetPassScreen(), Colors.pinkAccent),
    ];

    return Drawer(
      child: isLoggedIn
          ? ListView(
              children: [
                _buildUserProfile(),
                const Divider(),
                ...menuItems,  // Directly using the ListTile widgets
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
  ListTile _buildMenuItem(IconData icon, String title, Widget screen, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: title == 'Logout' ? _logout : () => Navigator.push(
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
                : AssetImage('assets/icons/nen.png') as ImageProvider,
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome, ${name ?? "Guest"}!',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            name ?? 'Guest',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
