import 'package:flutter/material.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/job_poster/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/job_poster/widget_drawer.dart';

class EmployerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: PosterAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      drawer: PosterDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(),
              _buildBenefits(),
              _buildKnowledgeSection(),
              _buildConsultationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Image.asset("assets/images/image1.png", height: 200, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Nơi gặp gỡ giữa doanh nghiệp\nvà 10 triệu ứng viên chất lượng",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 44, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child:
                    Text("Đăng ký ngay", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 🔹 Lợi ích
   Widget _buildBenefits() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _benefitItem("assets/images/icon1.png", "Nguồn ứng viên chất lượng",
              "Nhà tuyển dụng có thể tiếp cận nguồn ứng viên dồi dào với hơn 10 triệu hồ sơ và hơn 50 triệu lượt truy cập mỗi năm"),
          _benefitItem("assets/images/icon2.png", "Trải nghiệm toàn diện",
              "Tài khoản nhà tuyển dụng được tích hợp thêm các tính năng thông minh, giúp thuận tiện quản lý tin đăng, quản lý hồ sơ và theo dõi ứng viên, và lượng nộp đơn"),
          _benefitItem("assets/images/icon3.png", "Chi phí hợp lý",
              "Đặc quyền 12++ tin đăng miễn phí mỗi năm giúp nhà tuyển dụng tối ưu chi phí & quy trình tuyển dụng"),
          _benefitItem("assets/images/icon4.png",
              "Chất lượng CSKH chuyên nghiệp",
              "Đội ngũ CSKH giờ tập trung cho JobPath.vn, chuyên nghiệp hơn & tận tình hơn, nhằm mang lại trải nghiệm tốt nhất và hiệu quả tối đa"),
        ],
      ),
    );
  }

  Widget _benefitItem(String iconPath, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(iconPath, width: 40, height: 40),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Kiến thức hữu ích
  Widget _buildKnowledgeSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Image.asset("assets/images/image2.png",
              height: 200, fit: BoxFit.cover),
          Text(
            "Kiến thức hữu ích để bạn tuyển dụng thành công",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _knowledgeItem(
              "5 bước để doanh nghiệp phát triển chiến lược nhân sự"),
          _knowledgeItem(
              "5 điều các doanh nghiệp thành công làm để giữ chân nhân tài"),
          _knowledgeItem(
              "10 câu hỏi phỏng vấn giúp sáng lọc ứng viên tốt nhất"),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {},
            child: Text("Xem tất cả", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _knowledgeItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

   // 🔹 Đăng ký tư vấn
  Widget _buildConsultationSection() {
    return Column(
      children: [
        Image.asset("assets/images/image3.png",
            height: 300, width: 900, fit: BoxFit.cover),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                "Đăng ký tư vấn",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _hotlineCard("Hotline hỗ trợ miền Nam", "HCM: (028) 7108 2424"),
              SizedBox(height: 10),
              _hotlineCard("Hotline hỗ trợ miền Bắc", "HN: (024) 7308 2424"),
              SizedBox(height: 20),
                          ],
          ),
        ),
        Image.asset("assets/images/image5.png",
        height: 380, fit: BoxFit.cover),
        Column(
          children: [
              SizedBox(height: 20),
            _consultationCard("Quản lý đăng tuyển",
                  "Với thư viện chuẩn của hơn 1000+ mô tả công việc gợi ý cho nhà tuyển dụng với các ngành nghề và vị trí khác nhau"),
              _consultationCard("Quản lý ứng viên",
                  "Với công cụ quản lý tích hợp, báo cáo trực quan, dễ sử dụng và theo dõi kho hồ sơ ứng viên theo từng vị trí đăng tuyển"),
              _consultationCard("Quảng cáo đa nền tảng",
                  "Với cơ chế đẩy tin lên các vị trí đầu trang kết quả tìm kiếm việc làm và kết hợp nguồn tiếp cận thông qua các kênh truyền thông mạng xã hội Facebook, Tiktok"),

          ],
        )
      ],
    );
  }

  Widget _hotlineCard(String title, String phone) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: Offset(2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.headset_mic, color: Colors.purple, size: 40),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(phone,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _consultationCard(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(description, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
