import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/widgets/widget_jobcard.dart';
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
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 36),
            Text(
              'Công nghệ thông tin',
              style: PrimaryText.primaryTextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
                height: 252,
                child: JobCard(),
            ),
            const SizedBox(
                height: 252,
                child: JobCard(),
            ),
            const SizedBox(
                height: 252,
                child: JobCard(),
            ),
          ]
        ),
      ),
      ),
    );
  }
}
