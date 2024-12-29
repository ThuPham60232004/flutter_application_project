import 'package:flutter/material.dart';
import 'package:flutter_application_project/presentation/screens/home_screen.dart';
import 'package:flutter_application_project/presentation/screens/login_screen.dart';
import 'package:flutter_application_project/presentation/screens/menu_career.dart';
import 'package:flutter_application_project/presentation/screens/careerdetail_screen.dart';
import 'package:flutter_application_project/presentation/screens/company_screen.dart';
import 'package:flutter_application_project/presentation/screens/signup_screen.dart';
import 'package:flutter_application_project/presentation/screens/companydetail_screen.dart';
import 'package:flutter_application_project/presentation/screens/profile_screen.dart';
import 'package:flutter_application_project/presentation/screens/contact_screen.dart';
import 'package:flutter_application_project/presentation/screens/blogdetail_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    RouteNames.home: (context) => const HomeScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.signup: (context) => const SignUpScreen(),
    RouteNames.menucareer: (context) => const MenuCareer(),
    RouteNames.careerdetail: (context) => const CareerDetail(),
    RouteNames.company: (context) => const CompanyScreen(),
    RouteNames.companydetail: (context) => const CompanyDetail(),
    RouteNames.profile: (context) => const ProfileScreen(),
    RouteNames.contact: (context) => const ContactScreen(),
    RouteNames.blogdetail: (context) => const BlogDetail(),
  };
}
