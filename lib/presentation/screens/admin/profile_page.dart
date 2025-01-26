import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String baseUrl = 'http://192.168.1.213:2000/profile';
  List<dynamic> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        setState(() {
          _profiles = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Lỗi tải danh sách hồ sơ');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  Future<void> _saveProfile(Map<String, dynamic> profile, {String? userId}) async {
    try {
      final url = userId != null ? '$baseUrl/$userId' : baseUrl;
      final response = await (userId != null
          ? http.put(Uri.parse(url),
              body: jsonEncode(profile),
              headers: {'Content-Type': 'application/json'})
          : http.post(Uri.parse(url),
              body: jsonEncode(profile),
              headers: {'Content-Type': 'application/json'}));
      if (response.statusCode == 200) {
        _fetchProfiles();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lưu thành công!')));
      } else {
        throw Exception('Lỗi lưu hồ sơ');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
    }
  }

  Future<void> _deleteProfile(String userId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$userId'));
      if (response.statusCode == 200) {
        _fetchProfiles();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Xóa thành công!')));
      } else {
        throw Exception('Lỗi xóa hồ sơ');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
    }
  }

  void _showProfileForm({Map<String, dynamic>? profile}) async {
    final isEdit = profile != null;
    final titleController =
        TextEditingController(text: isEdit ? profile['title'] : '');
    final summaryController =
        TextEditingController(text: isEdit ? profile['summary'] : '');
    final phoneController = TextEditingController(
        text: isEdit ? profile['contactInfo']['phone'] : '');
    final addressController = TextEditingController(
        text: isEdit ? profile['contactInfo']['address'] : '');
    final linkedinController = TextEditingController(
        text: isEdit ? profile['contactInfo']['linkedin'] : '');
    final githubController = TextEditingController(
        text: isEdit ? profile['contactInfo']['github'] : '');
    final portfolioController = TextEditingController(
        text: isEdit ? profile['contactInfo']['portfolio'] : '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Chỉnh sửa hồ sơ' : 'Thêm hồ sơ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
              ),
              TextField(
                controller: summaryController,
                decoration: InputDecoration(labelText: 'Tóm tắt'),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
              ),
              TextField(
                controller: linkedinController,
                decoration: InputDecoration(labelText: 'LinkedIn'),
              ),
              TextField(
                controller: githubController,
                decoration: InputDecoration(labelText: 'GitHub'),
              ),
              TextField(
                controller: portfolioController,
                decoration: InputDecoration(labelText: 'Portfolio'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final profileData = {
                'title': titleController.text,
                'summary': summaryController.text,
                'contactInfo': {
                  'phone': phoneController.text,
                  'address': addressController.text,
                  'linkedin': linkedinController.text,
                  'github': githubController.text,
                  'portfolio': portfolioController.text,
                },
              };
              Navigator.of(context).pop();
              _saveProfile(profileData,
                  userId: isEdit ? profile['user'] : null);
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý Hồ sơ'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _profiles.isEmpty
              ? Center(child: Text('Không có hồ sơ nào'))
              : ListView.builder(
                  itemCount: _profiles.length,
                  itemBuilder: (context, index) {
                    final profile = _profiles[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: profile['profileImage'] != null
                              ? NetworkImage(profile['profileImage'])
                              : null,
                          child: profile['profileImage'] == null
                              ? Icon(Icons.person)
                              : null,
                        ),
                        title: Text(profile['title'] ?? 'Không có tiêu đề'),
                        subtitle: Text(profile['summary'] ?? 'Không có tóm tắt'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () =>
                                  _showProfileForm(profile: profile),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProfile(profile['user']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProfileForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
