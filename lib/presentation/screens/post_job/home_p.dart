import 'package:flutter/material.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/job_poster/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/job_poster/widget_drawer.dart';
class EmployerHomePage extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: PosterAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      drawer: PosterDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào, người đăng tin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    icon: Icons.post_add,
                    title: 'Tạo bài đăng mới',
                    onTap: () {
                      Navigator.pushNamed(context, '/createPost');
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.manage_accounts,
                    title: 'Quản lý bài đăng',
                    onTap: () {
                      Navigator.pushNamed(context, '/managePosts');
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.business,
                    title: 'Hồ sơ công ty',
                    onTap: () {
                      // Điều hướng đến màn hình hồ sơ công ty
                      Navigator.pushNamed(context, '/companyProfile');
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.logout,
                    title: 'Đăng xuất',
                    onTap: () {
                      // Xử lý đăng xuất
                      _logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Đăng xuất'),
          content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Đăng xuất'),
            ),
          ],
        );
      },
    );
  }
}
