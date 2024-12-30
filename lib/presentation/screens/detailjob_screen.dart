import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/widget_drawer.dart';
import 'package:flutter_application_project/core/widgets/widget_footer.dart';
import 'package:flutter_application_project/core/widgets/widget_jobcard.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/widget_search.dart';
import 'package:flutter_application_project/core/widgets/widgte_jobbanner.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';

class DetailJobScreen extends StatefulWidget {
  const DetailJobScreen({Key? key}) : super(key: key);

  @override
  _DetailJobScreenState createState() => _DetailJobScreenState();
}

class _DetailJobScreenState extends State<DetailJobScreen> {
  double _scrollOffset = 0.0;
  String _currentTab = 'Chi tiết';

  static const TextStyle _headerTextStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const TextStyle _subHeaderTextStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  static const TextStyle _defaultTextStyle =
      TextStyle(fontSize: 14, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    final inheritedTheme = AppInheritedTheme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      drawer: CustomDrawer(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            setState(() {
              _scrollOffset = scrollNotification.metrics.pixels;
            });
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                _buildItemPage(),
                const SizedBox(height: 20),
                _buildPosJob(),
                _buildSectionWithLine('Phúc Lợi', _buildBenefitSection()),
                const SizedBox(height: 20),
                _buildSectionWithLine('Về Chúng Tôi', _buildAboutUsHeader()),
                const SizedBox(height: 20),
                _buildText(),
                const SizedBox(height: 20),
                const SizedBox(height: 252, child: JobCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionWithLine(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _headerTextStyle),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 2,
          color: Colors.black,
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }


  Widget _buildItemPage() {
    return Container(
      width: double.infinity,
      height: 150,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Backend Developer',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text('Job Item',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPosJob() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Backend Developer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text('Freelancer',
                  style: TextStyle(fontSize: 14, color: Colors.blue)),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text('Tiến Phong - TPHCM, Việt Nam', style: _defaultTextStyle),
        const SizedBox(height: 5),
       Row(
          children: [
            _buildTabButton('Chi tiết', _currentTab == 'Chi tiết'),
            const SizedBox(width: 20),
            _buildTabButton('Tổng quan công ty', _currentTab == 'Tổng quan công ty'),
          ],
        ),

        const SizedBox(height: 10),
        if (_currentTab == 'Chi tiết') _buildJobDetails(),
        if (_currentTab == 'Tổng quan công ty') _buildCompanyOverview(),
      ],
    );
  }

Widget _buildTabButton(String title, bool isSelected) {
  return GestureDetector(
    onTap: () {
      setState(() {
        _currentTab = title;
      });
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: title.length * 8.0,
            color: Colors.black,
          ),
      ],
    ),
  );
}

  Widget _buildJobDetails() {
    return Row(
      children: [
        _buildImageContainer('assets/images/hcm_map.png'),
        const SizedBox(width: 12),
        _buildJobInfo(),
      ],
    );
  }

  Widget _buildCompanyOverview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CTY TNHH YAKULT VIET NAM',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildInfoRow(Icons.location_on,
              'Địa điểm: 195 Trương Văn Bang, KP1, P Thạnh Mỹ Lợi, Tp Thủ Đức, HCM'),
          _buildInfoRow(Icons.person, 'Người liên hệ: Ms Huyền'),
          _buildInfoRow(Icons.group, 'Quy mô công ty: 500-999'),
          _buildInfoRow(Icons.business_center,
              'Loại hình hoạt động: Trách nhiệm hữu hạn'),
          _buildInfoRow(Icons.link,
              'Website: https://corporate.yakult.vn/tuyen-dung.html'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: _defaultTextStyle),
        ),
      ],
    );
  }

  Widget _buildBenefitSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3,
      ),
      itemCount: _benefits.length,
      itemBuilder: (context, index) {
        final benefit = _benefits[index];
        return Row(
          children: [
            Icon(benefit['icon'] as IconData, size: 20),
            const SizedBox(width: 5),
            Expanded(
                child: Text(benefit['text'] as String,
                    style: const TextStyle(fontSize: 14))),
          ],
        );
      },
    );
  }

  final List<Map<String, dynamic>> _benefits = [
    {'icon': Icons.health_and_safety, 'text': 'Chế độ bảo hiểm'},
    {'icon': Icons.card_giftcard, 'text': 'Chế độ thưởng'},
    {'icon': Icons.family_restroom, 'text': 'Phụ cấp nhà ở'},
    {'icon': Icons.local_cafe, 'text': 'Đào tạo'},
    {'icon': Icons.favorite, 'text': 'Chăm sóc sức khoẻ'},
    {'icon': Icons.flight, 'text': 'Du Lịch'},
    {'icon': Icons.laptop, 'text': 'Công việc ổn định'},
    {'icon': Icons.attach_money, 'text': 'Tăng lương'},
    {'icon': Icons.event, 'text': 'Nghỉ phép năm'},
  ];

  Widget _buildAboutUsHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/nen.png',
            width: 190, height: 190, fit: BoxFit.cover),
        const SizedBox(width: 20),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('More Info',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Container(height: 2, width: 50, color: Colors.black),
                  const SizedBox(height: 12),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ea nisi Lorem ipsum dolor',
                    style: TextStyle(fontSize: 12, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
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
                          horizontal: 20,
                          vertical: 12,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Ứng tuyển',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    return const Text(
      'This is a placeholder text for additional information about the job or company. You can customize this section further based on your requirements.',
      style: TextStyle(fontSize: 14, height: 1.5),
    );
  }

  Widget _buildImageContainer(String assetPath) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(assetPath, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildJobInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJobDetail(Icons.calendar_today, 'Ngày cập nhật: 09/12/2024'),
          _buildJobDetail(Icons.business, 'Ngành nghề: Technology'),
          _buildJobDetail(Icons.money, 'Lương: 11 Tr - 15 Tr VND'),
          _buildJobDetail(Icons.access_time, 'Hết hạn nộp: 31/01/2025'),
          _buildJobDetail(Icons.work, 'Hình thức: Nhân viên chính thức'),
        ],
      ),
    );
  }

  Widget _buildJobDetail(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.black, size: 20),
        const SizedBox(width: 5),
        Text(text, style: _defaultTextStyle),
      ],
    );
  }
}
