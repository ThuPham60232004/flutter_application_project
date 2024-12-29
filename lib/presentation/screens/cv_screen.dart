import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';

class CVScreen extends StatefulWidget {
  const CVScreen({Key? key}) : super(key: key);
  @override
  _CVScreenState createState() => _CVScreenState();
}

class _CVScreenState extends State<CVScreen> {
  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/icons/nen.png'),
                    ),
                    const SizedBox(height: 10),
                     Text(
                      'Ảnh đại diện',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "Thông tin cá nhân",
                style: PrimaryText.primaryTextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              buildSection([
                buildInputField("Họ và tên", "Phạm Thị Anh Thư"),
                buildInputField("Ngày sinh", "30/09/2004"),
                buildInputField("Email", "ptat1@gmail.com"),
                buildInputField("Số điện thoại", "0912345678"),
              ]),
              const SizedBox(height: 10),
              Text(
                "Học vấn",
                style: PrimaryText.primaryTextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              buildSection([
                buildInputField("Tên trường", "Trường Đại học Ngoại ngữ - Tin học Tp.HCM"),
                buildInputField("Ngành học", "Công nghệ thông tin"),
                buildInputField("Chuyên ngành", "Công nghệ phần mềm"),
                buildInputField("Năm tốt nghiệp", "Chưa tốt nghiệp"),
              ]),
              const SizedBox(height: 10),
              Text(
                "Kinh nghiệm làm việc",
                style: PrimaryText.primaryTextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              buildSection([
                buildInputField("Kỹ năng", "HTML, CSS, Photoshop"),
                buildInputField("Công ty", "ABC"),
                buildInputField("Vị trí", "Web Developer"),
                buildInputField("Thời gian làm việc", "1 năm"),
                buildInputField("Các chứng chỉ", "Danh sách các chứng chỉ đã hoàn thành."),
                buildInputField("Dự án", "Tên dự án, mô tả ngắn gọn, liên kết (nếu có)"),
              ]),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print("Chỉnh sửa $label");
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    foregroundColor: const Color.fromARGB(255, 33, 215, 243),
                  ),
                  child: const Text(
                    "Chỉnh sửa",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSection(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fields,
      ),
    );
  }
}
