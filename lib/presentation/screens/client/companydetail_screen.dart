import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_project/presentation/screens/client/detailjob_screen.dart';
import 'package:flutter_application_project/app.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';

class CompanyDetailScreen extends StatefulWidget {
  final dynamic company;

  const CompanyDetailScreen({Key? key, required this.company})
      : super(key: key);

  @override
  _CompanyDetailScreenState createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  bool isLoading = true;
  List<dynamic> jobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backend-findjob.onrender.com/job/company/${widget.company['_id']}'));
      if (response.statusCode == 200) {
        final List<dynamic> decodedJobs = jsonDecode(response.body);
        setState(() {
          jobs = decodedJobs;
          isLoading = false;
        });
        debugPrint('Jobs fetched successfully: $decodedJobs');
      } else {
        throw Exception('Không thể tải danh sách công việc');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Lỗi khi tải danh sách công việc: $e');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.company['logo'] ??
                          'https://via.placeholder.com/300x200',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.company['nameCompany'] ?? 'Không rõ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.black),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          widget.company['location'] ?? 'Không rõ',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 40, thickness: 1),
                  Text(
                    'Mô tả công ty:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.company['description'] ??
                        'Chưa có thông tin mô tả cho công ty này.',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : jobs.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có công việc nào phù hợp',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailJobScreen(job: job),
                                ),
                              );
                            },
                            child: _JobCardDesign(
                              logoUrl: job['company']?['logo'] ?? '',
                              jobTitle: job['title'] ?? 'Không có tiêu đề',
                              companyName: job['company']?['nameCompany'] ??
                                  'Không có công ty',
                              jobDescription:
                                  job['description'] ?? 'Không có mô tả',
                              jobExperience: job['exp'] ?? 'Không yêu cầu',
                              jobLocation: job['location'] ?? 'Remote',
                              jobSalary: job['salary'] != null
                                  ? '${job['salary']} VND'
                                  : 'Không rõ',
                            ),
                          ),
                        );
                      },
                    ),
        ]),
      ),
    );
  }
}

class _JobCardDesign extends StatelessWidget {
  final String logoUrl;
  final String jobTitle;
  final String companyName;
  final String jobDescription;
  final String jobExperience;
  final String jobLocation;
  final String jobSalary;

  const _JobCardDesign({
    Key? key,
    required this.logoUrl,
    required this.jobTitle,
    required this.companyName,
    required this.jobDescription,
    required this.jobExperience,
    required this.jobLocation,
    required this.jobSalary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.0,
            backgroundImage: logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
            backgroundColor: Colors.grey.shade200,
            child: logoUrl.isEmpty
                ? const Icon(Icons.business, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobTitle,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  jobDescription.length > 50
                      ? jobDescription.substring(0, 50) + '...'
                      : jobDescription,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Text(
                      jobExperience,
                      style: const TextStyle(
                          fontSize: 14.0, color: Colors.black54),
                    ),
                    const Text(" • ", style: TextStyle(color: Colors.black26)),
                    Text(
                      jobLocation,
                      style: const TextStyle(
                          fontSize: 14.0, color: Colors.black54),
                    ),
                    const Text(" • ", style: TextStyle(color: Colors.black26)),
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: 60,
                      ),
                      child: Text(
                        jobSalary,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
