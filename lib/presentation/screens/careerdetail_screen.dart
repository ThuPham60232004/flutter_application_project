import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
class CareerDetail extends StatefulWidget {
  const CareerDetail({Key? key}) : super(key: key);

  @override
  _CareerDetailState createState() => _CareerDetailState();
}

class _CareerDetailState extends State<CareerDetail> {
  @override
  Widget build (BuildContext context){
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: Center(
        child: Text('This is the Career Detail Page'),
      ),
    );
  }
}
