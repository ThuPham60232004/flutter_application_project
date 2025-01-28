import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';

class ModalDetailScreen extends StatefulWidget {
  final String jobId;
  final String title;
  const ModalDetailScreen({Key? key, required this.jobId, required this.title})
      : super(key: key);

  @override
  State<ModalDetailScreen> createState() => _ModalDetailScreenState();
}

class _ModalDetailScreenState extends State<ModalDetailScreen> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  File? selectedFile;
  final TextEditingController coverLetterController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thành công"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  Future<void> _applyJob() async {
    if (selectedFile == null) {
      _showErrorDialog('Vui lòng chọn CV trước khi gửi.');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');

      if (userId == null) {
        throw Exception("Không tìm thấy thông tin người dùng.");
      }

      final fileBytes = await selectedFile!.readAsBytes();
      final base64File = base64Encode(fileBytes);

      final uri =
          Uri.parse('https://backend-findjob.onrender.com/application/');

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
        })
        ..fields['user'] = userId
        ..fields['job'] = widget.jobId
        ..fields['coverLetter'] = coverLetterController.text
        ..fields['profile'] = profileData?['_id']!
        ..fields['status'] = 'pending';

      request.files.add(http.MultipartFile.fromBytes(
        'cv',
        fileBytes,
        filename: selectedFile!.path.split('/').last,
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        print("Gửi thành công!");
        _showSuccessDialog("Gửi ứng tuyển thành công.");
      } else {
        final responseData = await response.stream.bytesToString();
        throw Exception('Lỗi khi gửi ứng tuyển: $responseData');
      }
    } catch (e) {
      print("Lỗi: $e");
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _fetchProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('id');
      if (userId == null) {
        throw Exception("User ID không tồn tại.");
      }

      final profileUrl =
          Uri.parse('https://backend-findjob.onrender.com/profile/$userId');
      final response = await http.get(profileUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          profileData = data;

          nameController.text = data['user']['name'] ?? '';
          phoneController.text = data['contactInfo']['phone'] ?? '';

          isLoading = false;
        });
      } else {
        throw Exception("Không thể lấy thông tin cá nhân.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Lỗi"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    } else {
      _showErrorDialog('Không chọn được file.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileData != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.title}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('CV ứng tuyển *'),
                        _buildCVPickerSection(),
                        const SizedBox(height: 16),
                        _buildSectionTitle('Thông tin cơ bản'),
                        const SizedBox(height: 16),
                        _buildTextField('Họ và tên', nameController,
                            enable: false),
                        const SizedBox(height: 16),
                        _buildTextField('Số điện thoại *', phoneController,
                            enable: false),
                        const SizedBox(height: 16),
                        _buildSectionTitle('Thư xin việc (Không bắt buộc)'),
                        TextField(
                          controller: coverLetterController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Nhập lá thư ứng tuyển...',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _applyJob,
                          child: Text('Gửi CV của tôi'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text("Không có dữ liệu.")),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _buildCVPickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.upload_file, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedFile == null
                        ? 'Tải lên CV mới'
                        : 'Đã chọn: ${selectedFile!.path.split('/').last}',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hỗ trợ định dạng doc, docx hoặc pdf, dưới 3MB và không chứa mật khẩu bảo vệ.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enable = true}) {
    return TextField(
      controller: controller,
      enabled: enable,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: enable ? Colors.white : Colors.grey[300],
      ),
      maxLines: controller == coverLetterController
          ? 5
          : 1, // Make the cover letter field multiline
    );
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String filePath;

  const PdfViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem PDF')),
      body: PDFView(filePath: filePath),
    );
  }
}
