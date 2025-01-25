import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/core/themes/primary_text.dart';
import 'package:flutter_application_project/core/widgets/widget_appbar.dart';
import 'package:flutter_application_project/core/widgets/widget_drawer.dart';
import 'package:flutter_application_project/core/widgets/widget_search.dart';
import 'package:flutter_application_project/core/widgets/widgte_jobbanner.dart';
import 'package:flutter_application_project/core/widgets/widget_footer.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/presentation/screens/companydetail_screen.dart';
class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  double _scrollOffset = 0.0;
  List<dynamic> companyList = [];
  bool isLoading = true;
  Map<String, int> jobCounts = {};

  @override
  void initState() {
    super.initState();
    fetchCompanies();
  }

  Future<void> fetchCompanies() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.213:2000/company/'));
      if (response.statusCode == 200) {
        setState(() {
          companyList = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Không thể tải công ty');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Lỗi: $e');
    }
  }

  Future<int> fetchJobCount(String companyId) async {
    if (jobCounts.containsKey(companyId)) {
      return jobCounts[companyId]!;
    }

    try {
      final response = await http.get(Uri.parse('http://192.168.1.213:2000/job/count-by-company/$companyId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jobCount = data['jobCount'] ?? 0;
        setState(() {
          jobCounts[companyId] = jobCount;
        });
        return jobCount;
      } else {
        throw Exception('Không thể tải số lượng công việc');
      }
    } catch (e) {
      print('Lỗi khi lấy số công việc: $e');
      return 0;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: SizedBox(
                  height: 80,
                  child: WidgetSearch(),
                ),
              ),
              SizedBox(
                height: 200,
                child: BannerCarousel(),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Danh Sách Các Công Ty Nổi Bật',
                  style: PrimaryText.primaryTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : companyList.isEmpty
                        ? Center(child: Text('Không có công ty nào.'))
                        : Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: companyList.map((company) => _buildCompanyCard(company)).toList(),
                          ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 330,
                child: CustomFooter(),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildCompanyCard(dynamic company) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDetailScreen(company: company),
          ),
        );
      },
      child: FutureBuilder<int>(
        future: fetchJobCount(company['_id']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi khi lấy số công việc'));
          }

          int jobCount = snapshot.data ?? 0;

          return Container(
            width: 200,
            height: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    company['logo'] ?? 'https://via.placeholder.com/200x120',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company['nameCompany'] ?? 'Không rõ',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.blueAccent, size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              company['location'] ?? 'Không rõ',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.work, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '$jobCount công việc',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
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
        },
      ),
    );
  }

}
