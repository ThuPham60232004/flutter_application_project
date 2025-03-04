import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CompanyProfilePage extends StatefulWidget {
  @override
  _CompanyProfilePageState createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  Map<String, dynamic>? companyData;
  bool isLoading = true;
  String? errorMessage;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchCompanyProfile();
  }

  Future<void> fetchCompanyProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('id');

      if (userId == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'Không tìm thấy ID người dùng!';
        });
        return;
      }

      final url = Uri.parse(
          'https://backend-findjob.onrender.com/company/user/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData is List && responseData.isNotEmpty) {
          setState(() {
            companyData = responseData[0];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Không tìm thấy thông tin công ty.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Tải thông tin công ty thất bại.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Đã xảy ra lỗi: $e';
        isLoading = false;
      });
    }
  }

  Widget buildInputField(String label, String? value,
      {bool isMultiline = false, bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: value ?? 'Chưa có thông tin',
          enabled: isEditable,
          maxLines: isMultiline ? null : 1,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> updateCompanyProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('id');
      if (userId == null) return;

      final url = Uri.parse(
          'https://backend-findjob.onrender.com/company/${companyData!['_id']}');
      final response = await http.put(url,
          body: json.encode({
            "nameCompany": companyData!['nameCompany'],
            "location": companyData!['location'],
            "website": companyData!['website'],
            "description": companyData!['description'],
            "isCompanyVerified": companyData!['isCompanyVerified'],
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        setState(() {
          isEditing = false; // Sau khi cập nhật, không cho chỉnh sửa nữa
        });
        fetchCompanyProfile(); // Lấy lại thông tin mới
      } else {
        setState(() {
          errorMessage = 'Cập nhật thông tin thất bại';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Đã xảy ra lỗi khi cập nhật: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hồ Sơ Công Ty'),
        
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (isEditing) {
                updateCompanyProfile(); // Cập nhật thông tin khi nhấn nút
              } else {
                setState(() {
                  isEditing = true; // Cho phép chỉnh sửa thông tin
                });
              }
            },
          ),
        ],
        flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFB276EF), // Màu tím nhạt
              Color(0xFF5A85F4), // Màu xanh dương
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : companyData != null
                  ? SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          if (companyData!['logo'] != null)
                            CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  NetworkImage(companyData!['logo']),
                            )
                          else
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              child: Icon(Icons.business,
                                  size: 50, color: Colors.white),
                            ),
                          SizedBox(height: 16),
                          buildInputField(
                              'Tên công ty', companyData!['nameCompany']),
                          buildInputField('Địa chỉ', companyData!['location']),
                          buildInputField('Website', companyData!['website']),
                          buildInputField('Mô tả', companyData!['description'],
                              isMultiline: true),
                          buildInputField(
                            'Trạng thái',
                            companyData!['isCompanyVerified'] == true
                                ? 'Đã xác minh'
                                : 'Chưa xác minh',
                            isEditable: false,
                          ),
                          if (companyData!['employees'] != null &&
                              companyData!['employees'].isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nhân viên:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                ...companyData!['employees'].map<Widget>(
                                  (employee) => Card(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(employee['name'] ??
                                          'Tên không xác định'),
                                      subtitle: Text(employee['email'] ??
                                          'Email không xác định'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text('Không tìm thấy thông tin công ty.'),
                    ),
    );
  }
}
