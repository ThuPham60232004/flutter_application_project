import 'package:flutter/material.dart';
import 'package:flutter_application_project/presentation/screens/home_screen.dart';
import 'package:flutter_application_project/presentation/screens/login_screen.dart';
import 'package:flutter_application_project/presentation/screens/menu_career.dart';
import 'package:flutter_application_project/presentation/screens/company_screen.dart';
import 'package:flutter_application_project/presentation/screens/signup_screen.dart';
import 'package:flutter_application_project/presentation/screens/account_screen.dart';
import 'package:flutter_application_project/presentation/screens/contact_screen.dart';
import 'package:flutter_application_project/presentation/screens/blogdetail_screen.dart';
import 'package:flutter_application_project/presentation/screens/profile_screen.dart';
import 'package:flutter_application_project/presentation/screens/forgetpass_screen.dart';
import 'package:flutter_application_project/presentation/screens/resetpass_screen.dart';
import 'package:flutter_application_project/presentation/modal/filter_modal.dart';
import 'route_names.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    RouteNames.home: (context) => const HomeScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.signup: (context) => SignUpScreen(),
    RouteNames.menucareer: (context) => const MenuCareer(),
    RouteNames.company: (context) => const CompanyScreen(),
    RouteNames.accout: (context) =>  AccoutScreen(),
    RouteNames.contact: (context) => const ContactScreen(),
    RouteNames.blogdetail: (context) => const BlogDetail(),
    RouteNames.profile: (context) =>  ProfileScreen(),
    RouteNames.forgetpassscreen: (context) => const ForgetPassScreen(),
    RouteNames.resetpassscreen: (context) => const ResetPassScreen(),
    RouteNames.filter_modal: (context) => const FilterModal(),
  };
}
