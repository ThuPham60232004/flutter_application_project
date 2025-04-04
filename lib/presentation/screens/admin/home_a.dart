import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/admin/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/admin/widget_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/presentation/screens/signup_screen.dart';
import 'package:flutter_application_project/presentation/screens/account_screen.dart';
import 'package:flutter_application_project/presentation/screens/contact_screen.dart';
import 'package:flutter_application_project/presentation/screens/admin/category_screen.dart';
import 'package:flutter_application_project/presentation/screens/admin/benefit_page.dart';
import 'package:flutter_application_project/presentation/screens/admin/profile_screen.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int usersCount = 0;
  int companiesCount = 0;
  int jobsCount = 0;
  int applicationsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('https://backend-findjob.onrender.com/user/count')),
        http.get(
            Uri.parse('https://backend-findjob.onrender.com/company/count')),
        http.get(Uri.parse('https://backend-findjob.onrender.com/job/count')),
        http.get(Uri.parse(
            'https://backend-findjob.onrender.com/application/count')),
      ]);

      if (responses.every((response) => response.statusCode == 200)) {
        setState(() {
          usersCount = json.decode(responses[0].body)['totalUsers'] ?? 0;
          companiesCount = json.decode(responses[1].body)['count'] ?? 0;
          jobsCount = json.decode(responses[2].body)['count'] ?? 0;
          applicationsCount = json.decode(responses[3].body)['count'] ?? 0;
        });
      } else {
        throw Exception('Failed to load stats');
      }
    } catch (e) {
      print('Error fetching stats: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: AdminAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      drawer: AdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildStatisticsGrid(),
            SizedBox(height: 20),
            _buildCategoryTitle("Danh mục"),
            SizedBox(height: 10),
            _buildCategoriesGrid(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // 🟣 Header
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text("Xin chào!",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Text(
            "Phạm Thị Anh Thư",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildSearchBar(),
        ],
      ),
    );
  }

  // 🔍 Thanh tìm kiếm
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Tìm kiếm công việc ......",
          border: InputBorder.none,
          icon: Icon(Icons.search, color: Colors.grey),
        ),
      ),
    );
  }

  // 📊 Thống kê số liệu
  Widget _buildStatisticsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: [
          _buildStatCard(usersCount.toString(), "Người dùng", Color(0xFF9B5DE5)),
          _buildStatCard(jobsCount.toString(), "Công việc", Color(0xFFF15BB5)),
          _buildStatCard(companiesCount.toString(), "Công ty", Color(0xFF00BBF9)), 
          _buildStatCard(applicationsCount.toString(), "Đơn ứng tuyển", Color(0xFF00F5D4)), // Xanh ngọc

        ],
      ),
    );
  }

  Widget _buildStatCard(String number, String title, Color color) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  // 🏷 Tiêu đề danh mục
  Widget _buildCategoryTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

 // 🏷 Thiết kế danh mục tối giản
Widget _buildCategoriesGrid() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _buildMenuItem(Icons.person_add, 'Đăng ký', SignUpScreen()),
        _buildMenuItem(Icons.contact_mail, 'Liên hệ', ContactScreen()),
        _buildMenuItem(Icons.account_circle, 'Tài khoản', AccoutScreen()),
        _buildMenuItem(Icons.category, 'Danh mục', CategoryScreen()),
        _buildMenuItem(Icons.volunteer_activism, 'Phúc lợi', BenefitPage()),
        _buildMenuItem(Icons.person, 'Hồ sơ', ProfilePage()),
      ],
    ),
  );
}

Widget _buildMenuItem(IconData icon, String title, Widget page) {
  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền trắng để đồng nhất
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 4)) // Bóng đổ nhẹ
        ],
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200, // Nền icon nhẹ nhàng
            radius: 25,
            child: Icon(icon, color: Colors.black54, size: 28), // Icon màu trung tính
          ),
          SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    ),
  );
}

}
