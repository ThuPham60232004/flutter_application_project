import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';

class ModalDetailScreen extends StatelessWidget {
  const ModalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lập trình viên Backend',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'CV của bạn *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF7E0E0),
                  border: Border.all(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.upload_file, color: Colors.black54),
                          SizedBox(width: 8),
                          Text(
                            'Tải lên CV mới',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.cloud_upload),
                            label: Text('Chọn tệp'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Chưa chọn tệp',
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Vui lòng tải lên tệp .doc, .docx hoặc .pdf, tối đa 3MB và không có bảo vệ mật khẩu.',
                        style: TextStyle(fontSize: 12, color: Color(0xFF979090)),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),
              Text(
                'Thông tin cá nhân',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Họ và tên *',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Số điện thoại *',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Vị trí làm việc ưa thích *',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(child: Text('HCM'), value: 'HCM'),
                  DropdownMenuItem(child: Text('HN'), value: 'HN'),
                  DropdownMenuItem(child: Text('DN'), value: 'DN'),
                ],
                onChanged: (value) {},
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Thư xin việc',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '(Tùy chọn)',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Kỹ năng, dự án công việc hoặc thành tựu nào khiến bạn là ứng viên mạnh?',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText:
                      'Chi tiết và ví dụ cụ thể sẽ làm đơn ứng tuyển của bạn mạnh mẽ hơn .....',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '500 trong số 500 ký tự còn lại',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
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
                        'Ứng tuyển',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
}
