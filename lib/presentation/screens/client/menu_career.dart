import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_project/presentation/screens/client/careerdetail_screen.dart';
import 'package:shimmer/shimmer.dart';

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
    ? Center(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.white,
          child: Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: List.generate(6, (index) {
              return Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
              );
            }),
          ),
        ),
      )
    : Padding(
        padding: EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: careers.length,
          itemBuilder: (context, index) {
            final career = careers[index];
            String name = career['name'] ?? 'Chưa có tên';
            String iconName = career['icon'] ?? 'category';
            String categoryId = career['_id'].toString();

            return GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('selectedCategoryId', categoryId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CareerDetail(categoryName: name),
                  ),
                );
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      getIcon(iconName),
                      size: 60.0,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(height: 10),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          },
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
