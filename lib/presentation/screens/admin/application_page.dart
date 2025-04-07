import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class ApplicationPage extends StatefulWidget {
  @override
  _ApplicationPageState createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  List<dynamic> applications = [];
  List<dynamic> users = [];
  List<dynamic> jobs = [];
  List<dynamic> profiles = [];
  final _formKey = GlobalKey<FormState>();

  String? selectedUserId;
  String? selectedJobId;
  String? selectedProfileId;
  String? selectedStatus;

  TextEditingController coverLetterController = TextEditingController();
  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
    fetchApplications();
    fetchUsers();
    fetchJobs();
    fetchProfiles();
  }

  Future<void> fetchApplications() async {
    final response = await http
        .get(Uri.parse('https://backend-findjob.onrender.com/application'));
    if (response.statusCode == 200) {
      setState(() {
        applications = json.decode(response.body);
      });
    }
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://backend-findjob.onrender.com/user'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    }
  }

  Future<void> fetchJobs() async {
    final response =
        await http.get(Uri.parse('https://backend-findjob.onrender.com/job'));
    if (response.statusCode == 200) {
      setState(() {
        jobs = json.decode(response.body);
      });
    }
  }

  Future<void> fetchProfiles() async {
    final response = await http
        .get(Uri.parse('https://backend-findjob.onrender.com/profile'));
    if (response.statusCode == 200) {
      setState(() {
        profiles = json.decode(response.body);
      });
    }
  }

  Future<void> deleteApplication(String id) async {
    final response = await http.delete(
        Uri.parse('https://backend-findjob.onrender.com/application/$id'));
    if (response.statusCode == 200) {
      fetchApplications();
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        selectedFile = result.files.single;
      });
    }
  }

  Future<void> addOrUpdateApplication(String? id) async {
    if (_formKey.currentState!.validate()) {
      if (selectedFile == null) {
        _showErrorDialog('Vui lòng chọn CV trước khi gửi.');
        return;
      }

      if (selectedUserId == null ||
          selectedJobId == null ||
          selectedProfileId == null ||
          selectedStatus == null) {
        _showErrorDialog('Vui lòng điền đủ các trường bắt buộc.');
        return;
      }

      final url = id == null
          ? 'https://backend-findjob.onrender.com/application'
          : 'https://backend-findjob.onrender.com/application/$id';
      final method = id == null ? 'POST' : 'PUT';

      try {
        final fileBytes = selectedFile?.bytes;
        if (fileBytes == null) {
          _showErrorDialog('Không thể đọc dữ liệu CV.');
          return;
        }

        var request = http.MultipartRequest(method, Uri.parse(url))
          ..fields['user'] = selectedUserId!
          ..fields['job'] = selectedJobId!
          ..fields['profile'] = selectedProfileId!
          ..fields['coverLetter'] = coverLetterController.text
          ..fields['status'] = selectedStatus!
          ..files.add(http.MultipartFile.fromBytes(
            'cv',
            fileBytes,
            filename: selectedFile!.name,
          ));

        final response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          fetchApplications();
          Navigator.pop(context);
          _showSuccessDialog("Đơn ứng tuyển đã được gửi thành công.");
        } else {
          final responseData = await response.stream.bytesToString();
          throw Exception('Lỗi khi gửi đơn ứng tuyển: $responseData');
        }
      } catch (e) {
        print("Lỗi khi gửi đơn ứng tuyển: $e");
        _showErrorDialog('Lỗi: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Lỗi"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thành công"),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void showForm([Map<String, dynamic>? application]) {
    if (application != null) {
      selectedUserId = application['user'];
      selectedJobId = application['job'];
      selectedProfileId = application['profile'];
      selectedStatus = application['status'];
      coverLetterController.text = application['coverLetter'] ?? '';
    } else {
      selectedUserId = null;
      selectedJobId = null;
      selectedProfileId = null;
      selectedStatus = 'pending';
      coverLetterController.clear();
      selectedFile = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                application == null
                    ? 'Thêm Đơn Ứng Tuyển'
                    : 'Chỉnh Sửa Đơn Ứng Tuyển',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple, 
                ),
              ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: selectedUserId,
                    decoration: InputDecoration(
                      labelText: 'Người dùng',
                      border: OutlineInputBorder(),
                    ),
                    items: profiles.map((profile) {
                    final userName = profile['user']?['name'] ?? 'Không rõ';
                    return DropdownMenuItem(
                      value: profile['_id'].toString(),
                      child: Text(userName),
                    );
                  }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedUserId = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedJobId,
                    decoration: InputDecoration(
                      labelText: 'Công việc',
                      border: OutlineInputBorder(),
                    ),
                    items: jobs.map((job) {
                      return DropdownMenuItem(
                        value: job['_id'].toString(),
                        child: Text(job['title'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedJobId = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedProfileId,
                    decoration: InputDecoration(
                      labelText: 'Hồ sơ',
                      border: OutlineInputBorder(),
                    ),
                    items: profiles.map((profile) {
                      return DropdownMenuItem(
                        value: profile['_id'].toString(),
                        child: Text(profile['user']['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProfileId = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Trạng thái',
                      border: OutlineInputBorder(),
                    ),
                    items: ['pending', 'accepted', 'rejected'].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: pickFile,
                    child: Text(selectedFile == null
                        ? 'Chọn CV'
                        : selectedFile!.name),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: coverLetterController,
                    decoration: InputDecoration(
                      labelText: 'Thư xin việc',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () =>
                        addOrUpdateApplication(application?['_id']),
                    child: Center(
                    child: Text(
                      application == null
                          ? 'Thêm Đơn Ứng Tuyển'
                          : 'Cập Nhật Đơn Ứng Tuyển',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple, 
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Đơn Ứng Tuyển',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: applications.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  final application = applications[index];
                  final job = jobs[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        job['title'] ?? 'Không có tiêu đề công việc',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(application['status'] ?? 'Không có trạng thái'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () => showForm(application),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () =>
                                deleteApplication(application['_id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => showForm(),
        child: Icon(
          Icons.add,
          color: Colors.white,  
        ),
      ),
    );
  }
}
