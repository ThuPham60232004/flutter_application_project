import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompanyRegistrationScreen extends StatefulWidget {
  @override
  _CompanyRegistrationScreenState createState() => _CompanyRegistrationScreenState();
}

class _CompanyRegistrationScreenState extends State<CompanyRegistrationScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  File? _logoImage;
  File? _licenseImage;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _pickImage(bool isLogo) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isLogo) {
          _logoImage = File(pickedFile.path);
        } else {
          _licenseImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _registerCompany() async {
    if (_logoImage == null || _licenseImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng tải lên logo và giấy phép kinh doanh!')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    String? userId = await getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy ID người dùng!')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://backend-findjob.onrender.com/company/'),
    );

    request.fields['nameCompany'] = _companyNameController.text;
    request.fields['location'] = _locationController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['website'] = _websiteController.text;
    request.fields['managedBy'] = userId;

    request.files
        .add(await http.MultipartFile.fromPath('logo', _logoImage!.path));
    request.files
        .add(await http.MultipartFile.fromPath('license', _licenseImage!.path));

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng ký công ty thành công!')),
        );
        _clearForm();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Đăng ký thất bại! Mã lỗi: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _clearForm() {
    _companyNameController.clear();
    _locationController.clear();
    _descriptionController.clear();
    _websiteController.clear();
    _logoImage = null;
    _licenseImage = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký Công ty')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: 'Tên công ty'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
              ),
              TextField(
                controller: _websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _pickImage(true),
                child: const Text('Tải lên Logo'),
              ),
              _logoImage != null
                  ? Image.file(_logoImage!, height: 100)
                  : Container(),
              ElevatedButton(
                onPressed: () => _pickImage(false),
                child: const Text('Tải lên Giấy phép kinh doanh'),
              ),
              _licenseImage != null
                  ? Image.file(_licenseImage!, height: 100)
                  : Container(),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _registerCompany,
                      child: const Text('Đăng ký Công ty'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
