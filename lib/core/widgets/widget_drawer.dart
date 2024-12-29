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
class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'leading': const Icon(Icons.home),
        'title': 'Home',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.login),
        'title': 'Login',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.app_registration),
        'title': 'Register',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            ),
      },
      {
        'leading': const Icon(Icons.badge),
        'title': 'Carrer',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuCareer()),
            ),
      },
      {
        'leading': const Icon(Icons.border_right_sharp),
        'title': 'CarrerDetail',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CareerDetail()),
            ),
      },
      {
        'leading': const Icon(Icons.people),
        'title': 'Company',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompanyScreen()),
        ),
      },
      {
        'leading': const Icon(Icons.people_alt_sharp),
        'title': 'Company Details',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompanyDetail()),
        ),
      },
      {
        'leading': const Icon(Icons.contact_emergency),
        'title': 'Contact',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactScreen()),
        ),
      },
      {
        'leading': const Icon(Icons.person_off_outlined),
        'title': 'Profile',
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
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
