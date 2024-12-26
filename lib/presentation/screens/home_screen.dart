import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/widget_drawer.dart';
import 'package:flutter_application_project/core/widgets/widget_footer.dart';
import 'package:flutter_application_project/core/widgets/widget_jobcard.dart';
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
            JobCard(),
          ],
        ),
      ),
      bottomNavigationBar: CustomFooter(),
    );
  }
}
