import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';

class ResetPassScreen extends StatelessWidget {
  const ResetPassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thay đổi mật khẩu',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              buildTextField(
                icon: Icons.email_outlined,
                hintText: 'Email của bạn',
              ),
              SizedBox(height: 10),
              buildTextField(
                icon: Icons.lock_outline,
                hintText: 'Mật khẩu',
                obscureText: true,
              ),
              SizedBox(height: 10),
              buildTextField(
                icon: Icons.lock_outline,
                hintText: 'Xác nhận mật khẩu',
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
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
                    constraints: BoxConstraints(
                      minHeight: 50,
                      minWidth: double.infinity,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Tiếp tục',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required IconData icon,
    required String hintText,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
