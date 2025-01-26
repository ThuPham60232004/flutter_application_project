import 'package:flutter/material.dart';
import 'package:flutter_application_project/data/repositories/auth_repository.dart';
import 'package:flutter_application_project/data/sources/local_data_source.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_project/presentation/screens/admin/home_a.dart';
import 'package:flutter_application_project/presentation/screens/client/home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final AuthRepository authRepository = AuthRepository();
  final LocalDataSource localDataSource = LocalDataSource();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> loginUser(String email, String password) async {
    setState(() => isLoading = true);
    
    try {
      final user = await authRepository.loginUser(email, password);
      if (user != null) {
        await localDataSource.saveUserData(
            user.token, user.name, user.profileImage, user.id);
        print('role: ${user.role}');
        switch (user.role) {
          case 'job_seeker':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
          case 'job_poster':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
            break;
          case 'admin':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
            break;
          default:
            _showErrorDialog('Vai trò không hợp lệ');
            break;
        }
      } else {
        _showErrorDialog('Đăng nhập thất bại');
      }
    } catch (error) {
      _showErrorDialog('Đăng nhập thất bại');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Lỗi'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Đăng nhập',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Hoặc tiếp tục với địa chỉ email'),
              const SizedBox(height: 10),
              _buildTextField(
                  emailController, 'Email của bạn', Icons.email_outlined),
              const SizedBox(height: 10),
              _buildTextField(
                  passwordController, 'Mật khẩu', Icons.lock_outline,
                  obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        final email = emailController.text;
                        final password = passwordController.text;
                        if (email.isNotEmpty && password.isNotEmpty) {
                          loginUser(email, password);
                        } else {
                          _showErrorDialog(
                              'Vui lòng nhập cả email và mật khẩu');
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(80, 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: PrimaryTheme.buttonPrimary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    constraints:
                        const BoxConstraints(minHeight: 40, minWidth: 80),
                    alignment: Alignment.center,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Đăng nhập',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Bạn quên mật khẩu?  ',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgetpassscreen');
                      },
                      child: const Text('Quên mật khẩu')),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản?  ',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text('Đăng ký')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
