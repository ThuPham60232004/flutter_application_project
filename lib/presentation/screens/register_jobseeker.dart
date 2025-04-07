import 'package:flutter/material.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobSeekerScreen extends StatefulWidget {
  @override
  _JobSeekerScreenState createState() => _JobSeekerScreenState();
}

class _JobSeekerScreenState extends State<JobSeekerScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mật khẩu không khớp!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://backend-findjob.onrender.com/user/registerPoster'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'role': 'job_poster',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.')),
        );

        if (response.body.contains("job_poster")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vui lòng kiểm tra email để xác thực tài khoản.')),
          );
        }

        Navigator.pushNamed(context, '/login');
      } else {
        final error = json.decode(response.body)['message'] ?? 'Đã có lỗi xảy ra';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể kết nối đến server')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  width: 200,
                ),
              ),
              Center(
                child: Text(
                  'Tạo tài khoản',
                  style: TextStyle(
                    fontSize: 39,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(nameController, 'Tên của bạn', Icons.person_outline),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'Email của bạn', Icons.email_outlined),
              const SizedBox(height: 10),
              _buildTextField(passwordController, 'Mật khẩu', Icons.lock_outline, obscureText: true),
              const SizedBox(height: 10),
              _buildTextField(confirmPasswordController, 'Xác nhận mật khẩu', Icons.lock_outline, obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : registerUser,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: PrimaryTheme.buttonPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 40, minWidth: 80),
                    alignment: Alignment.center,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Đăng ký',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Đã có tài khoản?  ', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Đăng nhập'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
