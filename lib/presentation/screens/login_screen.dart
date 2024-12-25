import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/customAppbar.dart';
import 'package:flutter_application_project/app.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: Center(
        child: const Text('Welcome to Login Screen'),
      ),
    );
  }
}
