import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class JobApplicationPage extends StatefulWidget {
  @override
  _JobApplicationPageState createState() => _JobApplicationPageState();
}

class _JobApplicationPageState extends State<JobApplicationPage> {
  String? userId;
  String? selectedJobId;
  bool isViewingApplications = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id');
    });
  }

  Future<List<dynamic>> fetchJobs() async {
    if (userId == null) return [];

    final response = await http.get(
      Uri.parse('https://backend-findjob.onrender.com/job/user/$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<List<dynamic>> fetchApplications(String jobId) async {
    final response = await http.get(
      Uri.parse('https://backend-findjob.onrender.com/application/job/$jobId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load applications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isViewingApplications
            ? 'Danh sách ứng tuyển'
            : 'Danh sách công việc'),
        leading: isViewingApplications
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    isViewingApplications = false;
                    selectedJobId = null;
                  });
                },
              )
            : null,
        flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFB276EF), // Màu tím nhạt
              Color(0xFF5A85F4), // Màu xanh dương
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      ),
      body: userId == null
          ? const Center(child: CircularProgressIndicator())
          : isViewingApplications
              ? _buildApplicationList(selectedJobId!)
              : _buildJobList(),
    );
  }

  Widget _buildJobList() {
    return FutureBuilder<List<dynamic>>(
      future: fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có công việc nào.'));
        }

        final jobs = snapshot.data!;
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            final job = jobs[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                title: Text('${job['title'] ?? 'Không có tiêu đề'}'),
                subtitle: Text(
                  '${job['description'] ?? 'Không có mô tả'}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                onTap: () {
                  setState(() {
                    selectedJobId = job["_id"];
                    isViewingApplications = true;
                  });
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildApplicationList(String jobId) {
    return FutureBuilder<List<dynamic>>(
      future: fetchApplications(jobId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có ứng dụng nào.'));
        }

        final applications = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final application = applications[index];

            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ApplicationDetailPage(application: application),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        application['user']['name'] ?? 'Không có thông tin CV',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.email,
                              size: 18, color: Colors.blueGrey),
                          const SizedBox(width: 6),
                          Text(
                            application['user']['email'] ?? 'Không xác định',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                            children: [
                              const Icon(Icons.markunread_mailbox,
                                  size: 18, color: Color.fromARGB(255, 0, 0, 0)),
                              const SizedBox(width: 6),
                              Text(
                                'Thư giới thiệu: ${application['coverLetter'] ?? 'Không có thư'}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                      
                      const SizedBox(height: 6),
                      if (application['cv'] != null)
                        GestureDetector(
                          onTap: () {
                            final cvUrl =
                                'https://backend-findjob.onrender.com/${application['cv']}';
                            launchUrl(Uri.parse(cvUrl));
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf,
                                  size: 18, color: Colors.red),
                              const SizedBox(width: 6),
                              Text(
                                'Xem CV',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 243, 33, 33),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        const Text(
                          'Không có CV',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ApplicationDetailPage extends StatelessWidget {
  final dynamic application;

  ApplicationDetailPage({required this.application});

  @override
  Widget build(BuildContext context) {
    final user = application['user'];
    final profile = application['profile'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết ứng tuyển'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Thông tin người ứng tuyển'),
              _buildCard([
                _buildInputField(
                    'Tên người ứng tuyển', user['name'].toString()),
                _buildInputField('Email', user['email'].toString()),
                _buildInputField('Số điện thoại', user['phone'].toString()),
                _buildInputField('Trạng thái', user['status'].toString()),
              ]),
              _buildSectionTitle('Hồ sơ cá nhân'),
              _buildCard([
                _buildInputField('Chức danh', profile['title'].toString()),
                _buildInputField('Tóm tắt', profile['summary'].toString()),
              ]),
              _buildSectionTitle('Kinh nghiệm'),
              ...profile['experiences'].map<Widget>((experience) {
                return _buildCard([
                  _buildInputField(
                      'Công ty', experience['companyName'].toString()),
                  _buildInputField(
                      'Chức vụ', experience['jobTitle'].toString()),
                  _buildInputField(
                      'Bắt đầu', experience['startDate']?.toString() ?? 'N/A'),
                ]);
              }).toList(),
              _buildSectionTitle('Học vấn'),
              ...profile['education'].map<Widget>((education) {
                return _buildCard([
                  _buildInputField(
                      'Trường học', education['schoolName'].toString()),
                  _buildInputField('Bằng cấp', education['degree'].toString()),
                  _buildInputField(
                      'Ngành học', education['fieldOfStudy'].toString()),
                ]);
              }).toList(),
              _buildSectionTitle('Kỹ năng'),
              ...profile['skills'].map<Widget>((skill) {
                return _buildCard([
                  _buildInputField('Kỹ năng', skill['name'].toString()),
                  _buildInputField(
                      'Mức độ', skill['proficiencyLevel'].toString()),
                ]);
              }).toList(),
              _buildSectionTitle('Chứng chỉ'),
              ...profile['certifications'].map<Widget>((cert) {
                return _buildCard([
                  _buildInputField('Tên chứng chỉ', cert['name'].toString()),
                  _buildInputField('Cấp bởi', cert['issuedBy'].toString()),
                ]);
              }).toList(),
              _buildSectionTitle('Hồ sơ đính kèm'),
              _buildCard([
                _buildInputField('CV', application['cv'].toString()),
                _buildInputField(
                    'Thư xin việc',
                    application['coverLetter']?.toString() ??
                        'Không có thư xin việc'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            ),
          ),
        ],
      ),
    );
  }
}
