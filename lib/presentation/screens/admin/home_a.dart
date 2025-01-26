import 'package:flutter/material.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/admin/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/admin/widget_drawer.dart';
void main() {
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> stats = [
    {'title': 'Interview Schedules', 'value': '1568', 'growth': '25%', 'icon': Icons.calendar_today},
    {'title': 'Applied Jobs', 'value': '284', 'growth': '5%', 'icon': Icons.work_outline},
    {'title': 'Task Bids Won', 'value': '136', 'growth': '12%', 'icon': Icons.check_circle_outline},
    {'title': 'Application Sent', 'value': '985', 'growth': '5%', 'icon': Icons.send},
    {'title': 'Profile Viewed', 'value': '165', 'growth': '15%', 'icon': Icons.person_outline},
    {'title': 'New Messages', 'value': '2356', 'growth': '-2%', 'icon': Icons.message},
    {'title': 'Articles Added', 'value': '254', 'growth': '2%', 'icon': Icons.article},
    {'title': 'CV Added', 'value': '548', 'growth': '48%', 'icon': Icons.person_add},
  ];

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2,
                ),
                itemCount: stats.length,
                itemBuilder: (context, index) {
                  return StatCard(
                    title: stats[index]['title'],
                    value: stats[index]['value'],
                    growth: stats[index]['growth'],
                    icon: stats[index]['icon'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Vacancy Stats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text('Graph Placeholder', style: TextStyle(color: Colors.blueGrey)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String growth;
  final IconData icon;

  const StatCard({
    required this.title,
    required this.value,
    required this.growth,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  @override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(13.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(width: 10),
        Expanded( 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Text(
          growth,
          style: TextStyle(
            color: growth.startsWith('-') ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

}
