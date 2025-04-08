import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_project/presentation/screens/client/detailjob_screen.dart';
import 'package:flutter_application_project/core/widgets/client/widget_appbar.dart';
import 'package:flutter_application_project/app.dart';
import 'package:intl/intl.dart';

class CompanyDetailScreen extends StatefulWidget {
  final dynamic company;

  const CompanyDetailScreen({Key? key, required this.company}) : super(key: key);

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
        setState(() {
          jobs = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
        child: Column(
          children: [
            _buildCompanyCard(),
            const SizedBox(height: 20),
            isLoading ? const CircularProgressIndicator() : _buildJobList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                widget.company['logo'] ?? 'https://via.placeholder.com/300x200',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              widget.company['nameCompany'] ?? 'Unknown',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    widget.company['location'] ?? 'Unknown',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            Text(
              'Mô tả công ty:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.company['description'] ?? 'Không có mô tả',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList() {
    return jobs.isEmpty
        ? const Center(child: Text('No jobs available', style: TextStyle(fontSize: 16, color: Colors.grey)))
        : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: jobs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final job = jobs[index];
              return _JobCardDesign(
                job: job,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailJobScreen(job: job)),
                  );
                },
              );
            },
          );
  }
}

class _JobCardDesign extends StatelessWidget {
  final dynamic job;
  final VoidCallback onTap;

  const _JobCardDesign({Key? key, required this.job, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.blue.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job['title'] ?? 'No title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              job['company']?['nameCompany'] ?? 'No company',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildJobTag(Icons.work, job['exp'] ?? 'No experience'),
                const SizedBox(width: 8),
                _buildJobTag(Icons.location_on, job['location'] ?? 'Remote'),
                const SizedBox(width: 8),
                _buildJobTag(
                  Icons.monetization_on,
                  job['salary'] != null
                      ? '${NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0).format(job['salary'])} VND'
                      : 'Unknown',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobTag(IconData icon, String text) {
  String displayText = text.length > 12 ? '${text.substring(0, 12)}...' : text;
  
  return Row(
    children: [
      Icon(icon, size: 16, color: Colors.black),
      const SizedBox(width: 4),
      Text(
        displayText,
        style: const TextStyle(fontSize: 14, color: Colors.black54),
      ),
    ],
  );
}

}
