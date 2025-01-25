import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_project/presentation/screens/client/detailjob_screen.dart';

class JobCard extends StatefulWidget {
  const JobCard({Key? key}) : super(key: key);

  @override
  _JobCardState createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  late List<dynamic> jobs = [];
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchJobs();
    _autoScroll();
  }

  Future<void> fetchJobs() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.213:2000/job/'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedJobs = jsonDecode(response.body);
        setState(() {
          jobs = decodedJobs;
          isLoading = false;
        });
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

  void _autoScroll() {
    Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;

        if (currentScroll < maxScroll) {
          _scrollController.animateTo(currentScroll + 200,
              duration: Duration(seconds: 2), curve: Curves.easeInOut);
        } else {
          _scrollController.animateTo(0,
              duration: Duration(seconds: 2), curve: Curves.easeInOut);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(
                  child: Text(
                    'Không có công việc nào phù hợp',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController, 
                          scrollDirection: Axis.horizontal,
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            if (job is Map<String, dynamic>) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailJobScreen(job: job),
                                      ),
                                    );
                                  },
                                  child: _JobCardDesign(
                                    logoUrl: job['company']?['logo'] ?? '',
                                    jobTitle: job['title'] ?? 'Không có tiêu đề',
                                    companyName: job['company']?['nameCompany'] ?? 'Không có công ty',
                                    jobDescription: job['description'] ?? 'Không có mô tả',
                                    jobExperience: job['exp'] ?? 'Không yêu cầu',
                                    jobLocation: job['location'] ?? 'Remote',
                                    jobSalary: job['salary'] != null
                                        ? '${job['salary']} VND'
                                        : 'Không rõ',
                                  ),
                                ),
                              );
                            } else {
                              return const Text('Dữ liệu công việc không hợp lệ');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
      padding: const EdgeInsets.all(12.0), // Adjust padding to reduce the space
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0), // Adjust border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Shrink wrap Row
        children: [
          CircleAvatar(
            radius: 25.0,  // Slightly smaller radius to make it fit better
            backgroundImage: logoUrl.isNotEmpty ? NetworkImage(logoUrl) : null,
            backgroundColor: Colors.grey.shade200,
            child: logoUrl.isEmpty
                ? const Icon(Icons.business, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12.0),  // Adjusted space between logo and text
          Flexible( // Use Flexible instead of Expanded
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobTitle,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4.0),
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
                  jobDescription.length > 42
                      ? jobDescription.substring(0, 42) + '...'
                      : jobDescription,
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Text(
                      jobExperience,
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.black54),
                    ),
                    const Text(" • ", style: TextStyle(color: Colors.black26)),
                    Text(
                      jobLocation,
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.black54),
                    ),
                    const Text(" • ", style: TextStyle(color: Colors.black26)),
                    Text(
                      jobSalary,
                      style: const TextStyle(
                          fontSize: 12.0, color: Colors.black54),
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
