import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_project/presentation/screens/client/careerdetail_screen.dart';

class MenuCareer extends StatefulWidget {
  const MenuCareer({Key? key}) : super(key: key);

  @override
  _MenuCareerState createState() => _MenuCareerState();
}

class _MenuCareerState extends State<MenuCareer> {
  late List<dynamic> careers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCareers();
  }

  Future<void> fetchCareers() async {
    final response = await http
        .get(Uri.parse('https://backend-findjob.onrender.com/category/'));

    if (response.statusCode == 200) {
      setState(() {
        careers = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Không thể tải danh sách lĩnh vực nghề nghiệp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                  const SizedBox(
                    width: 150,
                    height: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(166, 64, 31, 211)),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  const SizedBox(
                    width: 180,
                    height: 2,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(166, 64, 31, 211)),
                    ),
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    spacing: 20.0,
                    runSpacing: 40.0,
                    children: careers.map((career) {
                      String name = career['name'] ?? 'Chưa có tên';
                      String iconName = career['icon'] ?? 'category';
                      String categoryId = career['_id'].toString();

                      return GestureDetector(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString(
                              'selectedCategoryId', categoryId);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CareerDetail(
                                categoryName: name,
                              ),
                            ),
                          );
                        },
                        child: Container(
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
                              Icon(
                                getIcon(iconName),
                                size: 40.0,
                              ),
                              Text(
                                name,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
    );
  }

  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'developer_board':
        return Icons.developer_board;
      case 'design_services':
        return Icons.design_services;
      case 'account_balance':
        return Icons.account_balance;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'school':
        return Icons.school;
      case 'architecture':
        return Icons.architecture;
      case 'campaign':
        return Icons.campaign;
      case 'hotel':
        return Icons.hotel;
      case 'bolt':
        return Icons.bolt;
      case 'local_shipping':
        return Icons.local_shipping;
      case 'movie':
        return Icons.movie;
      case 'bar_chart':
        return Icons.bar_chart;
      default:
        return Icons.category;
    }
  }
}
