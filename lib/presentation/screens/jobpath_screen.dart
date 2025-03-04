import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';

class JobPathScreen extends StatefulWidget {
  const JobPathScreen({super.key});

  @override
  _JobPathScreenState createState() => _JobPathScreenState();
}

class _JobPathScreenState extends State<JobPathScreen> {
  String? selectedRoute; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.purple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Image.asset('assets/images/logo.png', width: 250),
          const SizedBox(height: 10),
          Text(
            "Bắt đầu ngay! Bạn muốn tìm việc hay đăng tuyển?",
            style: PrimaryText.primaryTextStyle2(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOptionCard(context, Icons.work, "Tìm việc", "Tôi muốn tìm việc", "/signup"),
                _buildOptionCard(context, Icons.person_add, "Tuyển dụng", "Tôi muốn tìm nhân viên", "/jobseeker"),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedRoute == null
                    ? null
                    : () {
                        Navigator.pushNamed(context, selectedRoute!);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedRoute == null ? Colors.grey : PrimaryTheme.buttonPrimary.colors.first,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Tiếp tục", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, IconData icon, String title, String subtitle, String route) {
    bool isSelected = selectedRoute == route;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRoute = route;
        });
      },
      child: Container(
        width: 170,
        height: 240,
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.purple : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.purple.shade50 : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(icon, size: 45, color: isSelected ? Colors.purple : Colors.black),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black54), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
