import 'package:flutter/material.dart';
import 'package:flutter_application_project/core/widgets/client/widget_jobcard.dart';
import 'package:flutter_application_project/core/widgets/client/widget_footer.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:flutter_application_project/presentation/modal/detailjob_modal.dart';
class DetailJobScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const DetailJobScreen({Key? key, required this.job}) : super(key: key);

  @override
  _DetailJobScreenState createState() => _DetailJobScreenState();
}

class _DetailJobScreenState extends State<DetailJobScreen> {
  String _currentTab = 'Chi tiết';
  static const TextStyle _headerTextStyle =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  String _formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.job['company'];
    final benefits = widget.job['benefits'] ?? [];
    final inheritedTheme = AppInheritedTheme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        themeMode: inheritedTheme!.themeMode,
        toggleTheme: inheritedTheme.toggleTheme,
      ),
      body:SingleChildScrollView(
        child: Column(
        children:[
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildItemPage(),
              const SizedBox(height: 30),
              Row(
                children: [
                  _buildTabButton('Chi tiết', _currentTab == 'Chi tiết'),
                  const SizedBox(width: 20),
                  _buildTabButton(
                      'Tổng quan công ty', _currentTab == 'Tổng quan công ty'),
                ],
              ),
              const SizedBox(height: 10),
              if (_currentTab == 'Chi tiết') _buildJobDetails(),
              if (_currentTab == 'Tổng quan công ty')
                _buildCompanyOverview(company),
                const SizedBox(height: 30),
                _buildSectionWithLine('Phúc Lợi', _buildBenefitSection()),
                const SizedBox(height: 20),
                _buildSectionWithLine('Về Chúng Tôi', _buildAboutUsHeader()),
                const SizedBox(height: 20),
                _buildText(),
                const SizedBox(height: 20),
               _buildSectionWithLine1('Gợi ý công việc'),
               const SizedBox(height: 200, child: JobCard()),
               
            ],
            
          ),
        ),
      ),
      SizedBox(
        height: 330,
         child: CustomFooter(),
      ),
        ]
      )
      )
    );
  }
  Widget _buildSectionWithLine1(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _headerTextStyle),
        const SizedBox(height: 10),
        Container(
        height: 2,
        width: 100,
        color: Colors.black,  
      ),
      ],
    );
  }
Widget _buildText() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Mô tả', 
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        height: 2,
        width: 50,
        color: Colors.black,  
      ),
      const SizedBox(height: 10),
      SingleChildScrollView(
        child: Text(
          '${widget.job['description'] ?? 'Không có mô tả'}',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    ],
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
  Widget _buildBenefitSection() {
  final List<dynamic> benefits = widget.job['benefits'] ?? [];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 3,
    ),
    itemCount: benefits.length,
    itemBuilder: (context, index) {
      final benefit = benefits[index];
      return Row(
        children: [
          Icon(
            _getIconFromName(benefit['icon'] as String?),
            size: 20,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              benefit['name'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      );
    },
  );
}
IconData _getIconFromName(String? iconName) {
  switch (iconName) {
    case 'monetization_on':
      return Icons.monetization_on;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'card_giftcard':
      return Icons.card_giftcard;
    case 'family_restroom':
      return Icons.family_restroom;
    case 'local_cafe':
      return Icons.local_cafe;
    case 'favorite':
      return Icons.favorite;
    case 'flight':
      return Icons.flight;
    case 'laptop':
      return Icons.laptop;
    case 'event':
      return Icons.event;
    case 'home':
      return Icons.home;
    case 'airplanemode_active':
      return Icons.airplanemode_active_outlined;
    case 'calendar_today':
      return Icons.calendar_today;
    default:
      return Icons.help_outline; 
  }
}
Widget _buildAboutUsHeader() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.asset(
          'assets/images/nen.png',
          width: 170,
          height: 215,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 20),
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hãy ứng tuyển',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 2,
                  width: 70,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 12),
                Text(
                  'Ứng tuyển ngay để gia nhập đội ngũ phát triển nghề nghiệp, nhận cơ hội thăng tiến hấp dẫn',
                  style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black54),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModalDetailScreen(jobId: widget.job['_id'],title:widget.job['title']),
                          ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      
                      backgroundColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, const Color.fromARGB(255, 184, 129, 204)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        alignment: Alignment.center,
                        
                        child: const Text(
                          'Ứng tuyển',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

  Widget _buildItemPage() {
    return Container(
      width: double.infinity,
      height: 150,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ' ${widget.job['title']}',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text('${widget.job['type']}',
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
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
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: Padding(
      padding: const EdgeInsets.all(12.0), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2, 
            crossAxisSpacing: 8, 
            mainAxisSpacing: 8, 
            childAspectRatio: 4, 
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildJobDetailItem(
                icon: Icons.location_on,
                iconColor: Colors.red,
                label: 'Vị trí',
                value: widget.job['location'] ?? 'Không rõ',
              ),
              _buildJobDetailItem(
                icon: Icons.work,
                iconColor: Colors.orange,
                label: 'Kinh nghiệm',
                value: widget.job['exp'] ?? 'Không rõ',
              ),
              _buildJobDetailItem(
                icon: Icons.attach_money,
                iconColor: Colors.green,
                label: 'Mức lương',
                value: widget.job['salary'] != null ? '${widget.job['salary']} VND' : 'Không rõ',
              ),
              _buildJobDetailItem(
                icon: Icons.business_center,
                iconColor: Colors.teal,
                label: 'Hình thức',
                value: widget.job['type'] ?? 'Không rõ',
              ),
              _buildJobDetailItem(
                icon: Icons.calendar_today,
                iconColor: Colors.purple,
                label: 'Hạn nộp',
                value: _formatDate(widget.job['deadline'] ?? 'Không rõ'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildJobDetailItem({
  required IconData icon,
  required Color iconColor,
  required String label,
  required String value,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, color: iconColor, size: 20),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    ],
  );
}


 Widget _buildCompanyOverview(
    Map<String, dynamic> company) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        company['logo'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  company['logo'],
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(Icons.business, size: 40, color: Colors.grey),
              ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin công ty',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.apartment, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 8.0),
                  Text(
                    'Tên công ty: ${company['nameCompany']}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 8.0),
                  Text(
                    'Vị trí: ${company['location']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  Icon(Icons.link, size: 16),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                    },
                    child: Text(
                      company['website'] ?? 'Không có thông tin',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
}
