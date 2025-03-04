import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  bool isLoading = true;
  bool isAddingJob = false;
  String errorMessage = '';
  List<dynamic> jobs = [];
  List<dynamic> categories = [];
  List<dynamic> benefits = [];
  List<dynamic> selectedBenefits = [];
  String? userId;
  String? companyId;
  String? selectedCategory;
  String? jobTitle;
  String? jobDescription;
  String? jobSalary;
  String? jobExp;
  late TextEditingController deadlineController;
  String? selectedType;
  DateTime? selectedDeadline;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    deadlineController = TextEditingController();
    _loadUserId();
    _fetchCategories();
    _fetchBenefits();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('id');
    });
    if (userId != null) {
      _fetchJobs(userId!);
    } else {
      setState(() {
        errorMessage = 'Không tìm thấy userId.';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchJobs(String userId) async {
    try {
      final response = await http.get(
          Uri.parse('https://backend-findjob.onrender.com/job/user/$userId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            jobs = data;
            companyId = data[0]['company']['_id'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'Không tìm thấy công việc nào.';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Không tìm thấy công việc nào.';
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Đã xảy ra lỗi: $error';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse('https://backend-findjob.onrender.com/category'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          categories = data;
        });
      } else {
        setState(() {
          errorMessage = 'Không thể lấy danh sách danh mục.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi: $e';
      });
    }
  }

  Future<void> _fetchBenefits() async {
    try {
      final response = await http
          .get(Uri.parse('https://backend-findjob.onrender.com/benefit'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          benefits = data;
        });
      } else {
        setState(() {
          errorMessage = 'Không thể lấy danh sách lợi ích.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi: $e';
      });
    }
  }

  Future<void> _selectDeadline(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDeadline ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDeadline) {
      setState(() {
        selectedDeadline = pickedDate;
        deadlineController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _submitJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    final jobData = {
      'title': jobTitle,
      'description': jobDescription,
      'company': companyId,
      'postedBy': userId,
      'category': selectedCategory,
      'benefits': selectedBenefits,
      'salary': jobSalary != null ? double.tryParse(jobSalary!) : null,
      'exp': jobExp,
      'deadline': selectedDeadline?.toIso8601String(),
      'type': selectedType,
    };

    try {
      final response = await http.post(
        Uri.parse('https://backend-findjob.onrender.com/job'),
        body: json.encode(jobData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          isAddingJob = false;
        });
        _fetchJobs(userId!);
        print('Job added successfully');
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Đã có lỗi xảy ra: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Lỗi: $e';
      });
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách công việc'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                isAddingJob = !isAddingJob;
              });
            },
          ),
        ],
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
      body: isAddingJob
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Tiêu đề công việc'),
                        onChanged: (value) => jobTitle = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập tiêu đề công việc';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Mô tả công việc'),
                        onChanged: (value) => jobDescription = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập mô tả công việc';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField(
                        value: selectedCategory,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue as String?;
                          });
                        },
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category['_id'],
                            child: Text(category['name']),
                          );
                        }).toList(),
                        decoration:
                            InputDecoration(labelText: 'Danh mục công việc'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Mức lương'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => jobSalary = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Kinh nghiệm'),
                        onChanged: (value) => jobExp = value,
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: selectedType,
                        items: const [
                          DropdownMenuItem(
                              value: 'full_time', child: Text('Full Time')),
                          DropdownMenuItem(
                              value: 'part_time', child: Text('Part Time')),
                          DropdownMenuItem(
                              value: 'freelance', child: Text('Freelance')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Job Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: deadlineController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Deadline (YYYY-MM-DD)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDeadline(context),
                          ),
                        ),
                      ),
                      Wrap(
                        children: benefits.map((benefit) {
                          return CheckboxListTile(
                            title: Text(benefit['name']),
                            value: selectedBenefits.contains(benefit['_id']),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value!) {
                                  selectedBenefits.add(benefit['_id']);
                                } else {
                                  selectedBenefits.remove(benefit['_id']);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitJob,
                        child: Text('Thêm công việc'),
                      ),
                      if (errorMessage.isNotEmpty) ...[
                        SizedBox(height: 20),
                        Text(errorMessage, style: TextStyle(color: Colors.red)),
                      ]
                    ],
                  ),
                ),
              ),
            )
          : isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Text(errorMessage,
                          style: TextStyle(color: Colors.red)))
                  : ListView.builder(
                      itemCount: jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobs[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text(job['title']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(job['company']['nameCompany'] ??
                                    'Chưa có tên công ty'),
                                SizedBox(height: 8),
                                Text(
                                  job['description'] != null
                                      ? (job['description'].length > 100
                                          ? job['description']
                                                  .substring(0, 100) +
                                              '...'
                                          : job['description'])
                                      : 'Không có mô tả',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
