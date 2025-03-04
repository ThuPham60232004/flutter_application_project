import 'package:flutter/material.dart';
import 'package:flutter_application_project/presentation/screens/client/home_screen.dart';
import 'package:flutter_application_project/hello.dart';
import 'package:flutter_application_project/presentation/screens/jobpath_screen.dart';
import 'package:flutter_application_project/presentation/screens/register_jobseeker.dart';
import 'package:flutter_application_project/presentation/screens/login_screen.dart';
import 'package:flutter_application_project/presentation/screens/client/menu_career.dart';
import 'package:flutter_application_project/presentation/screens/client/company_screen.dart';
import 'package:flutter_application_project/presentation/screens/signup_screen.dart';
import 'package:flutter_application_project/presentation/screens/account_screen.dart';
import 'package:flutter_application_project/presentation/screens/contact_screen.dart';
import 'package:flutter_application_project/presentation/screens/client/blogdetail_screen.dart';
import 'package:flutter_application_project/presentation/screens/client/profile_screen.dart';
import 'package:flutter_application_project/presentation/screens/forgetpass_screen.dart';
import 'package:flutter_application_project/presentation/screens/resetpass_screen.dart';
import 'package:flutter_application_project/presentation/modal/filter_modal.dart';
import 'package:flutter_application_project/presentation/screens/admin/home_a.dart';
import 'package:flutter_application_project/presentation/screens/post_job/home_p.dart';
import 'package:flutter_application_project/presentation/screens/admin/job_screen.dart';
import 'package:flutter_application_project/presentation/screens/confirm_screen.dart';
import 'package:flutter_application_project/presentation/screens/companyregister_screen.dart';
import 'route_names.dart';

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    RouteNames.hello: (context) => const Hello(),
    RouteNames.home: (context) => const HomeScreen(),
    RouteNames.login: (context) => const LoginScreen(),
    RouteNames.signup: (context) => SignUpScreen(),
    RouteNames.menucareer: (context) => const MenuCareer(),
    RouteNames.company: (context) => const CompanyScreen(),
    RouteNames.accout: (context) => AccoutScreen(),
    RouteNames.contact: (context) => const ContactScreen(),
    RouteNames.blogdetail: (context) => const BlogDetail(),
    RouteNames.profile: (context) => ProfileScreen(),
    RouteNames.forgetpassscreen: (context) => const ForgetPassScreen(),
    RouteNames.resetpassscreen: (context) => const ResetPassScreen(),
    RouteNames.filter_modal: (context) => const FilterModal(),
    RouteNames.home_a: (context) => AdminDashboard(),
    RouteNames.home_p: (context) => EmployerHomePage(),
    RouteNames.job_manager: (context) => JobListScreen(),
    RouteNames.jobpath: (context) => JobPathScreen(),
    RouteNames.jobseeker: (context) => JobSeekerScreen(),
    RouteNames.confirm: (context) => ConfirmScreen(),
    RouteNames.companyregister: (context) => CompanyRegistrationScreen(),
  };
}
