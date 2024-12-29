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

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'leading': const Icon(Icons.home, color: Colors.blue),
        'title': 'Home',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.login, color: Colors.green),
        'title': 'Login',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.app_registration, color: Colors.orange),
        'title': 'Register',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.badge, color: Colors.teal),
        'title': 'Career',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuCareer()),
            ),
      },
      {
        'leading': const Icon(Icons.description, color: Colors.indigo),
        'title': 'Career Details',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CareerDetail()),
            ),
      },
      {
        'leading': const Icon(Icons.business, color: Colors.purple),
        'title': 'Company',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompanyScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.info, color: Colors.deepPurple),
        'title': 'Company Details',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompanyDetail()),
            ),
      },
      {
        'leading': const Icon(Icons.contacts, color: Colors.blueGrey),
        'title': 'Contact',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.person, color: Colors.cyan),
        'title': 'Profile',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.article, color: Colors.amber),
        'title': 'Blog Details',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BlogDetail()),
            ),
      },
      {
        'leading': const Icon(Icons.insert_drive_file, color: Colors.lightGreen),
        'title': 'CV',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CVScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.code, color: Colors.deepOrange),
        'title': 'Enter Code',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EnterCodeScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.lock_open, color: Colors.redAccent),
        'title': 'Forget Password',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgetPassScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.lock_reset, color: Colors.pinkAccent),
        'title': 'Reset Password',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResetPassScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.logout, color: Colors.red),
        'title': 'Logout',
        'onTap': () {},
      },
    ];

    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/icons/nen.png'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Here’s your profile menu',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ...menuItems.map((item) => ListTile(
                leading: item['leading'] as Widget,
                title: Text(item['title'] as String),
                onTap: item['onTap'] as VoidCallback,
              )),
        ],
      ),
    );
  }
}
