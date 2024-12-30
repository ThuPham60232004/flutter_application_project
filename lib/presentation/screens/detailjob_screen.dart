import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/widget_drawer.dart';
import 'package:flutter_application_project/core/widgets/widget_footer.dart';
import 'package:flutter_application_project/core/widgets/widget_jobcard.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/widget_search.dart';
import 'package:flutter_application_project/core/widgets/widgte_jobbanner.dart';
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/themes/primary_theme.dart';

class DetailJobScreen extends StatefulWidget {
  const DetailJobScreen({Key? key}) : super(key: key);

  @override
  _DetailJobScreenState createState() => _DetailJobScreenState();
}

class _DetailJobScreenState extends State<DetailJobScreen> {
  double _scrollOffset = 0.0;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildItemPage(),
              const SizedBox(height: 20),
              _buildPosJob(),
              _buildBenefitSection(),
              const SizedBox(height: 20),
              _buildAboutUsHeader(),
              const SizedBox(height: 20),
               _buildText(),
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(
                height: 252,
                child: JobCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Gợi Ý (Công Việc Tương Tự)',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
Widget _buildItemPage() {
  return Container(
    width: MediaQuery.of(context).size.width, 
    height: 150, 
    decoration: BoxDecoration(
      color: Colors.purple[100], 
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        crossAxisAlignment: CrossAxisAlignment.center, 
        children: [
          Text(
            'Backend Developer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10), 
          Text(
            'Job Item',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white, 
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildPosJob() {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 250,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Backend Developer',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'Freelancer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Tiến Phong - TPHCM, Việt Nam',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: Row(
            children: [
              Text(
                'Chi tiết',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 20),
              Text(
                'Tổng quan công ty',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Container(
                width:120,
                height:120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    'assets/images/hcm_map.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12), 
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'Ngày cập nhật: 09/12/2024',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.business, color: Colors.blue, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'Ngành nghề:Technology',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.money, color: Colors.green, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'Lương: 11 Tr - 15 Tr VND',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.orange, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'Hết hạn nộp: 31/01/2025',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.work, color: Colors.purple, size: 20),
                        SizedBox(width: 5),
                        Text(
                          'Hình thức: Nhân viên chính thức',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}








  Widget _buildBenefitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phúc Lợi',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildBenefitItem(Icons.health_and_safety, 'Chế độ bảo hiểm'),
            _buildBenefitItem(Icons.card_giftcard, 'Chế độ thưởng'),
            _buildBenefitItem(Icons.family_restroom, 'Phụ cấp nhà ở'),
            _buildBenefitItem(Icons.local_cafe, 'Đào tạo'),
            _buildBenefitItem(Icons.favorite, 'Chăm sóc sức khoẻ'),
            _buildBenefitItem(Icons.flight, 'Du Lịch'),
            _buildBenefitItem(Icons.laptop, 'Công việc ổn định'),
            _buildBenefitItem(Icons.attach_money, 'Tăng lương'),
            _buildBenefitItem(Icons.event, 'Nghỉ phép năm'),
          ],
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Stack(
            alignment: Alignment.center,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.purple),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

Widget _buildAboutUsHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/nen.png',
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'More Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 1.0),
            _buildAboutUsDecoration(),
            const SizedBox(
              width: 180,
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ea nisi Lorem ipsum dolor sit amet, consectetur.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color:  const Color(0xFFA290FF)), 
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Ứng tuyển',
                style: TextStyle(fontSize: 14, color:  const Color(0xFFA290FF)),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
Widget _buildText() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Unde, iure beatae! Voluptas tempora doloremque atque repudiandae maiores odio magni. Illo ut nihil officia numquam in. Delenti pariatur at minima quaerat!',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Qui corrupti animi, dignissimos veritatis, necessitatibus consequuntur nobis, placeat beatae dolorum ullam harum at atque dolor! Accusantium cupiditate ipsum placeat, vel voluptatibus non eaque, animi neque minima facere provident aspernatur!',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
        const Text(
          'Porro magni numquam ex natus repellat accusamus laborum blanditiis odit consequatur at veritatis nostrum provident recusandae dolores incidunt distinctio facere, nulla odio quo tempore libero! Voluptatum porro velit, qui optio.',
          style: TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Hành động khi nhấn vào nút
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFA290FF), 
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Ứng tuyển',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}



  Widget _buildAboutUsDecoration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(
          width: 50,
          height: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color.fromARGB(255, 89, 148, 185)),
          ),
        ),
        SizedBox(height: 3.0),
        SizedBox(
          width: 80,
          height: 2,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Color.fromARGB(255, 89, 148, 185)),
          ),
        ),
        
      ],
    );
  }
}
 