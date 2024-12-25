import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/custom_appbar.dart';
import 'package:flutter_application_project/core/widgets/custom_drawer.dart';
import 'package:flutter_application_project/core/widgets/custom_footer.dart';
import 'package:flutter_application_project/app.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      drawer: CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Home Screen Content',
              style: TextStyle(fontSize: 18),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(),
    );
  }
}
