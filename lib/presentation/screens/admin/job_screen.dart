import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobListScreen extends StatefulWidget {
  const JobListScreen({Key? key}) : super(key: key);

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  List jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      final response =
          await http.get(Uri.parse('https://backend-findjob.onrender.com/job'));
      if (response.statusCode == 200) {
        setState(() {
          jobs = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching jobs: $e')),
      );
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      final response = await http
          .delete(Uri.parse('https://backend-findjob.onrender.com/job/$jobId'));
      if (response.statusCode == 200) {
        setState(() {
          jobs.removeWhere((job) => job['_id'] == jobId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete job');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting job: $e')),
      );
    }
  }

 void openAddJobForm() {
  showDialog(
    context: context,
    builder: (context) => const AddJobFormDialog(),
  ).then((_) => fetchJobs());
}

void openEditJobForm(String jobId) async {
  try {
    final response = await http
        .get(Uri.parse('https://backend-findjob.onrender.com/job/$jobId'));
    if (response.statusCode == 200) {
      final job = json.decode(response.body);
      showDialog(
        context: context,
        builder: (context) => EditJobFormDialog(job: job),
      ).then((_) => fetchJobs());
    } else {
      throw Exception('Failed to fetch job data');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching job data: $e'),
        backgroundColor: Colors.deepPurple, // Changed background color to deepPurple
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Danh sách công việc',
    style: TextStyle(fontWeight: FontWeight.bold), 
  ),
  centerTitle: true,
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

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    title: Text(job['title'] ?? 'No Title',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(
                      job['description'] ?? 'No Description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                                'Are you sure you want to delete this job?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          deleteJob(job['_id']);
                        }
                      },
                    ),
                    onTap: () => openEditJobForm(job['_id']),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddJobForm,
        child: const Icon(
          Icons.add,
          color: Colors.white, // Set the icon color to white
        ),
        backgroundColor: Colors.deepPurple, // Set the background color to deep purple
      ),

    );
  }
}

class AddJobFormDialog extends StatefulWidget {
  const AddJobFormDialog({Key? key}) : super(key: key);

  @override
  State<AddJobFormDialog> createState() => _AddJobFormDialogState();
}

class _AddJobFormDialogState extends State<AddJobFormDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController deadlineController;
  late TextEditingController experienceController;
  late TextEditingController locationController;
  late TextEditingController salaryController;
  List companies = [];
  List categories = [];
  List users = [];
  List benefits = [];
  String? selectedCompany;
  String? selectedCategory;
  String? selectedUser;
  String? selectedBenefit;
  String? selectedType;
  DateTime? selectedDeadline;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    deadlineController = TextEditingController();
    experienceController = TextEditingController();
    locationController = TextEditingController();
    salaryController = TextEditingController();
    fetchDropdownData();
  }

  Future<void> fetchDropdownData() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('https://backend-findjob.onrender.com/company')),
        http.get(Uri.parse('https://backend-findjob.onrender.com/category')),
        http.get(Uri.parse('https://backend-findjob.onrender.com/user')),
        http.get(Uri.parse('https://backend-findjob.onrender.com/benefit')),
      ]);

      setState(() {
        companies = json.decode(responses[0].body);
        categories = json.decode(responses[1].body);
        users = json.decode(responses[2].body);
        benefits = json.decode(responses[3].body);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching dropdown data: $e')),
      );
    }
  }

  Future<void> saveJob() async {
    final jobData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'company': selectedCompany,
      'category': selectedCategory,
      'postedBy': selectedUser,
      'benefits': selectedBenefit,
      'deadline': selectedDeadline?.toIso8601String(),
      'exp': experienceController.text,
      'type': selectedType,
      'location': locationController.text,
      'salary': salaryController.text,
    };

    try {
      print('Job Data: ${json.encode(jobData)}');
      final response = await http.post(
        Uri.parse('https://backend-findjob.onrender.com/job'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jobData),
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job added successfully')),
        );
      } else {
        throw Exception('Failed to add job: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding job: $e')),
      );
      print('Error adding job: $e');
    }
  }

  List<String> selectedBenefits = [];

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDeadline) {
      setState(() {
        selectedDeadline = picked;
        deadlineController.text =
            "${picked.toLocal()}".split(' ')[0]; // Format date to YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Thêm công việc',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.deepPurple,
          )),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Tên công việc',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: experienceController,
              decoration: InputDecoration(
                labelText: 'Kinh nghiệm  (Năm)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Vị trí',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: salaryController,
              decoration: InputDecoration(
                labelText: 'Lương',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: deadlineController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày hết hạn (DD-MM-YYYY)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDeadline(context),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: 'full_time', child: Text('Full Time')),
                DropdownMenuItem(value: 'part_time', child: Text('Part Time')),
                DropdownMenuItem(value: 'freelance', child: Text('Freelance')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Loại công việc',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedCompany,
              items: companies
                  .map((company) => DropdownMenuItem(
                        value: company['_id'].toString(),
                        child: Text(company['nameCompany'] ?? 'Unknown'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCompany = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Công ty',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category['_id'].toString(),
                        child: Text(category['name'] ?? 'Unknown'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Danh mục',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: selectedUser,
              items: users
                  .map((user) => DropdownMenuItem(
                        value: user['_id'].toString(),
                        child: Text(user['name'] ?? 'Unknown'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Người dùng',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...benefits.map((benefit) {
              return CheckboxListTile(
                title: Text(benefit['name'] ?? 'Unknown'),
                value: selectedBenefits.contains(benefit['_id']),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedBenefits.add(benefit['_id']);
                    } else {
                      selectedBenefits.remove(benefit['_id']);
                    }
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: saveJob,
          style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,  
          foregroundColor: Colors.white,     
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Lưu'),
        )

      ],
    );
  }
}

class EditJobFormDialog extends StatefulWidget {
  final dynamic job;

  const EditJobFormDialog({Key? key, required this.job}) : super(key: key);

  @override
  State<EditJobFormDialog> createState() => _EditJobFormDialogState();
}

class _EditJobFormDialogState extends State<EditJobFormDialog> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController salaryController;
  late TextEditingController expController;
  late TextEditingController deadlineController;

  String? selectedType;
  // String? selectedCompany;
  // String? selectedCategory;
  // String? selectedUser;
  // List<String>? selectedBenefits = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.job['title'] ?? '');
    descriptionController =
        TextEditingController(text: widget.job['description'] ?? '');
    locationController =
        TextEditingController(text: widget.job['location'] ?? '');
    salaryController =
        TextEditingController(text: widget.job['salary']?.toString() ?? '');
    expController = TextEditingController(text: widget.job['exp'] ?? '');
    deadlineController =
        TextEditingController(text: widget.job['deadline'] ?? '');
    selectedType = widget.job['type'];
    // selectedCompany = widget.job['company']?['_id'].toString();
    // selectedCategory = widget.job['category']?['_id'].toString();
    // selectedUser = widget.job['postedBy']?['_id'].toString();
    // selectedBenefits = List<String>.from(widget.job['benefits'] ?? []);
  }

  Future<void> updateJob() async {
    final jobData = {
      'title': titleController.text,
      'description': descriptionController.text,
      'location': locationController.text,
      'salary': salaryController.text,
      'exp': expController.text,
      'deadline': deadlineController.text,
      'type': selectedType,
      // 'company': selectedCompany,
      // 'category': selectedCategory,
      // 'postedBy': selectedUser,
      // 'benefits': selectedBenefits,
    };

    try {
      final response = await http.put(
        Uri.parse(
            'https://backend-findjob.onrender.com/job/${widget.job['_id']}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jobData),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Job updated successfully')),
        );
      } else {
        throw Exception('Failed to update job');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating job: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chỉnh sửa công việc',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.deepPurple,
          )),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Tên công việc',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Mô tả ',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Vị trí',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: salaryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Lương',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: expController,
              decoration: const InputDecoration(
                labelText: 'Kinh nghiệm (Năm)',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: deadlineController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Ngày hết hạn',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDeadline(context),
                ),
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: 'full_time', child: Text('Full Time')),
                DropdownMenuItem(value: 'part_time', child: Text('Part Time')),
                DropdownMenuItem(value: 'freelance', child: Text('Freelance')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Loại công việc',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: updateJob,
          child: const Text('Cập nhật'),
        ),
      ],
    );
  }

  Future<void> _selectDeadline(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        deadlineController.text =
            "${picked.toLocal()}".split(' ')[0]; // Format date to YYYY-MM-DD
      });
    }
  }
}
