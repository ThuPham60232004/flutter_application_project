import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/data/repositories/user_repository.dart';
import 'package:flutter_application_project/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_project/core/themes/primary_theme.dart';

class AccoutScreen extends StatefulWidget {
  const AccoutScreen({Key? key}) : super(key: key);

  @override
  _AccoutScreenState createState() => _AccoutScreenState();
}

class _AccoutScreenState extends State<AccoutScreen> {
  User? user;
  bool isLoading = true;
  bool isEditing = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('id');

    if (token != null && userId != null) {
      try {
        UserRepository userRepository = UserRepository();
        User fetchedUser = await userRepository.fetchUserData(userId, token);
        setState(() {
          user = fetchedUser;
          isLoading = false;
          nameController.text = user!.name ?? '';
          phoneController.text = user!.phone ?? '';
          emailController.text = user!.email ?? '';
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('id');
    if (userId != null) {
      final response = await http.put(
        Uri.parse('https://backend-findjob.onrender.com/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': nameController.text,
          'phone': phoneController.text,
          'email': emailController.text,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          isEditing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Dữ liệu đã được lưu thành công')));
        _loadUserData();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Không thể lưu dữ liệu')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(
          themeMode: inheritedTheme!.themeMode,
          toggleTheme: inheritedTheme.toggleTheme,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (user == null) {
      return Scaffold(
        appBar: CustomAppBar(
          themeMode: inheritedTheme!.themeMode,
          toggleTheme: inheritedTheme.toggleTheme,
        ),
        body: Center(child: Text('Failed to load user data')),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    user?.profileImage != null && user!.profileImage.isNotEmpty
                        ? NetworkImage(user!.profileImage)
                        : AssetImage('assets/icons/nen.png') as ImageProvider,
              ),
              SizedBox(height: 16),
              Text(
                "Tài khoản",
                style: PrimaryText.primaryTextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInputField("Họ và tên", nameController),
                    buildInputField("Số điện thoại", phoneController),
                    buildInputField("Email", emailController),
                    SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveUserData,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: PrimaryTheme.buttonPrimary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Lưu',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: controller,
                      readOnly: !isEditing, 
                      decoration: InputDecoration(
                        hintText: 'Nhập $label',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    foregroundColor: const Color.fromARGB(255, 163, 62, 252),
                  ),
                  child: Text(
                    isEditing ? "Xong" : "Chỉnh sửa",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
