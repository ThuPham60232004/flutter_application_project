import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';

class MenuCareer extends StatelessWidget {
  const MenuCareer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    final careers = [
      {'icon': Icons.developer_board, 'text': 'Công nghệ \n thông tin'},
      {'icon': Icons.design_services, 'text': 'Thiết kế'},
      {'icon': Icons.account_balance, 'text': 'Tài chính'},
      {'icon': Icons.health_and_safety, 'text': 'Sức khỏe'},
      {'icon': Icons.school, 'text': 'Giáo dục'},
      {'icon': Icons.architecture, 'text': 'Kiến trúc'},
      {'icon': Icons.campaign, 'text': 'Marketing'},
      {'icon': Icons.hotel, 'text': 'Du lịch \n khách sạn'},
      {'icon': Icons.bolt, 'text': 'Năng lượng'},
      {'icon': Icons.local_shipping, 'text': 'Logistic'},
      {'icon': Icons.movie, 'text': 'Giải trí'},
      {'icon': Icons.bar_chart, 'text': 'Kinh tế'},
    ];

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lĩnh vực nghề nghiệp',
              style: PrimaryText.primaryTextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              width: 150,
              height: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color.fromARGB(255, 52, 223, 209)),
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(
              width: 180,
              height: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color.fromARGB(255, 52, 223, 209)),
              ),
            ),
            SizedBox(height: 30),
            Wrap(
              spacing: 20.0,
              runSpacing: 40.0,
              children: careers.map((career) {
                return Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(career['icon'] as IconData),
                      Text(
                        career['text'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
