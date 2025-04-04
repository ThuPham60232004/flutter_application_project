import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateProfilePage extends StatefulWidget {
  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String summary = '';
  String phone = '';
  String address = '';
  String linkedin = '';
  String github = '';
  String portfolio = '';
  String userId = '';
  File? profileImage;

  List<Map<String, dynamic>> experiences = [];
  List<Map<String, dynamic>> education = [];
  List<Map<String, dynamic>> skills = [];
  List<Map<String, dynamic>> languages = [];
  List<Map<String, dynamic>> certifications = [];

  Future<void> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userIdFromPrefs = prefs.getString('id');
    setState(() {
      userId = userIdFromPrefs ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserId();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var profileData = {
        'user': userId,
        'title': title,
        'summary': summary,
        'contactInfo': {
          'phone': phone,
          'address': address,
          'linkedin': linkedin,
          'github': github,
          'portfolio': portfolio,
        },
        'experiences': experiences,
        'education': education,
        'skills': skills,
        'languages': languages,
        'certifications': certifications,
        'profileImage': profileImage != null
            ? base64Encode(profileImage!.readAsBytesSync())
            : null, // Convert image to base64 if selected
      };

      var response = await http.post(
        Uri.parse('https://backend-findjob.onrender.com/profile/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(profileData),
      );

      if (response.statusCode == 200) {
        _showSnackbar(
            'Profile created successfully!', Icons.check_circle, Colors.green);
      } else {
        _showSnackbar('Failed to create profile.', Icons.error, Colors.red);
      }
    }
  }

  void _showSnackbar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.black87,
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
  preferredSize: Size.fromHeight(kToolbarHeight),
  child: AppBar(
    title: Row(
      children: [
        Icon(Icons.person_add, color: Colors.white),
        SizedBox(width: 10),
        Text('Tạo Hồ Sơ'),
      ],
    ),
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFB276EF),
            Color(0xFF5A85F4),
          ],
        ),
      ),
    ),
  ),
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Thông Tin Cơ Bản'),
              _buildInputField('Chức danh', (value) => title = value),
              _buildInputField('Tóm tắt', (value) => summary = value,
                  maxLines: 4),
              _buildSectionTitle('Thông Tin Liên Hệ'),
              _buildInputField('Số điện thoại', (value) => phone = value),
              _buildInputField('Địa chỉ', (value) => address = value),
              _buildInputField('LinkedIn', (value) => linkedin = value),
              _buildInputField('GitHub', (value) => github = value),
              _buildInputField('Hồ sơ cá nhân', (value) => portfolio = value),
              _buildSectionTitle('Ảnh Hồ Sơ'),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: profileImage != null
                      ? ClipOval(
                          child: Image.file(
                            profileImage!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(Icons.camera_alt, color: Colors.white, size: 50),
                ),
              ),
              _buildSectionTitle('Kinh Nghiệm'),
              ..._buildDynamicList(
                label: 'Kinh nghiệm',
                fields: [
                  'Tên công ty',
                  'Chức danh',
                  'Ngày bắt đầu',
                  'Ngày kết thúc',
                  'Trách nhiệm'
                ],
                list: experiences,
                onAdd: _addExperience,
                onRemove: _removeExperience,
              ),
              _buildSectionTitle('Học Vấn'),
              ..._buildDynamicList(
                label: 'Học vấn',
                fields: [
                  'Tên trường',
                  'Bằng cấp',
                  'Lĩnh vực học',
                  'Ngày bắt đầu',
                  'Ngày kết thúc'
                ],
                list: education,
                onAdd: _addEducation,
                onRemove: _removeEducation,
              ),
              _buildSectionTitle('Kỹ Năng'),
              ..._buildDynamicList(
                label: 'Kỹ năng',
                fields: ['Tên kỹ năng', 'Mức độ thành thạo'],
                list: skills,
                onAdd: _addSkill,
                onRemove: _removeSkill,
              ),
              _buildSectionTitle('Ngôn Ngữ'),
              ..._buildDynamicList(
                label: 'Ngôn ngữ',
                fields: ['Tên ngôn ngữ', 'Mức độ thành thạo'],
                list: languages,
                onAdd: _addLanguage,
                onRemove: _removeLanguage,
              ),
              _buildSectionTitle('Chứng Chỉ'),
              ..._buildDynamicList(
                label: 'Chứng chỉ',
                fields: [
                  'Tên chứng chỉ',
                  'Đơn vị cấp',
                  'Ngày cấp',
                  'Ngày hết hạn'
                ],
                list: certifications,
                onAdd: _addCertification,
                onRemove: _removeCertification,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  child: Text(
                    'Tạo Hồ Sơ',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, Function(String) onChanged,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.deepPurple[50],
          labelStyle: TextStyle(color: Colors.deepPurple),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
      ),
    );
  }

  List<Widget> _buildDynamicList({
    required String label,
    required List<String> fields,
    required List<Map<String, dynamic>> list,
    required Function onAdd,
    required Function onRemove,
  }) {
    return [
      ...list.map((item) {
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.deepPurple[50],
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                ...fields.map((field) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: field,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        item[field] = value;
                      },
                    ),
                  );
                }).toList(),
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => onRemove(item),
                ),
              ],
            ),
          ),
        );
      }).toList(),
      ElevatedButton(
        onPressed: () => onAdd(),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          minimumSize: Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        child: Text('Thêm $label', style: TextStyle(color: Colors.white)),
      ),
    ];
  }

  void _addExperience() {
    setState(() {
      experiences.add({
        'Tên công ty': '',
        'Chức danh': '',
        'Ngày bắt đầu': '',
        'Ngày kết thúc': '',
        'Trách nhiệm': '',
      });
    });
  }

  void _removeExperience(Map<String, dynamic> item) {
    setState(() {
      experiences.remove(item);
    });
  }

  void _addEducation() {
    setState(() {
      education.add({
        'Tên trường': '',
        'Bằng cấp': '',
        'Lĩnh vực học': '',
        'Ngày bắt đầu': '',
        'Ngày kết thúc': '',
      });
    });
  }

  void _removeEducation(Map<String, dynamic> item) {
    setState(() {
      education.remove(item);
    });
  }

  void _addSkill() {
    setState(() {
      skills.add({
        'Tên kỹ năng': '',
        'Mức độ thành thạo': '',
      });
    });
  }

  void _removeSkill(Map<String, dynamic> item) {
    setState(() {
      skills.remove(item);
    });
  }

  void _addLanguage() {
    setState(() {
      languages.add({
        'Tên ngôn ngữ': '',
        'Mức độ thành thạo': '',
      });
    });
  }

  void _removeLanguage(Map<String, dynamic> item) {
    setState(() {
      languages.remove(item);
    });
  }

  void _addCertification() {
    setState(() {
      certifications.add({
        'Tên chứng chỉ': '',
        'Đơn vị cấp': '',
        'Ngày cấp': '',
        'Ngày hết hạn': '',
      });
    });
  }

  void _removeCertification(Map<String, dynamic> item) {
    setState(() {
      certifications.remove(item);
    });
  }
}
