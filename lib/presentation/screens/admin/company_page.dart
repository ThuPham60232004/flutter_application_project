import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  List<dynamic> companies = [];
  List<dynamic> users = [];
  final _formKey = GlobalKey<FormState>();

  String? selectedManagerId;
  List<String> selectedEmployeeIds = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCompanies();
    fetchUsers();
  }

  Future<void> fetchCompanies() async {
    final response = await http
        .get(Uri.parse('https://backend-findjob.onrender.com/company'));
    if (response.statusCode == 200) {
      setState(() {
        companies = json.decode(response.body);
      });
    }
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://backend-findjob.onrender.com/user'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
      });
    }
  }

  Future<void> addOrUpdateCompany(String? id) async {
    if (_formKey.currentState!.validate()) {
      final url = id == null
          ? 'https://backend-findjob.onrender.com/company'
          : 'https://backend-findjob.onrender.com/company/$id';
      final method = id == null ? 'POST' : 'PUT';

      final response = await http.Request(method, Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = json.encode({
          'nameCompany': nameController.text,
          'location': locationController.text,
          'description': descriptionController.text,
          'website': websiteController.text,
          'managedBy': selectedManagerId,
          'employees': selectedEmployeeIds,
        });

      final streamedResponse = await response.send();
      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        fetchCompanies();
        Navigator.pop(context);
      }
    }
  }

  Future<void> deleteCompany(String id) async {
    final response = await http
        .delete(Uri.parse('https://backend-findjob.onrender.com/company/$id'));
    if (response.statusCode == 200) {
      fetchCompanies();
    }
  }

  void showForm([Map<String, dynamic>? company]) {
    if (company != null) {
      nameController.text = company['nameCompany'] ?? '';
      locationController.text = company['location'] ?? '';
      descriptionController.text = company['description'] ?? '';
      websiteController.text = company['website'] ?? '';
      selectedManagerId = company['managedBy'] ?? null;
      selectedEmployeeIds = List<String>.from(company['employees'] ?? []);
    } else {
      nameController.clear();
      locationController.clear();
      descriptionController.clear();
      websiteController.clear();
      selectedManagerId = null;
      selectedEmployeeIds = [];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  company == null ? 'Thêm Công Ty' : 'Chỉnh Sửa Công Ty',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,  // Màu văn bản deepPurple
                  ),
                  textAlign: TextAlign.center,  // Căn giữa văn bản
                ),

                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Tên Công Ty',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Cần nhập' : null,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Địa Chỉ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Cần nhập' : null,
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Mô Tả',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: websiteController,
                    decoration: InputDecoration(
                      labelText: 'Website',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedManagerId,
                    decoration: InputDecoration(
                      labelText: 'Quản Lý Bởi',
                      border: OutlineInputBorder(),
                    ),
                    items: users.map((user) {
                      return DropdownMenuItem(
                        value: user['_id'].toString(),
                        child: Text(user['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedManagerId = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedManagerId,
                    decoration: InputDecoration(
                      labelText: 'Quản Lý Bởi',
                      border: OutlineInputBorder(),
                    ),
                    items: users.map<DropdownMenuItem<String>>((user) {
                      return DropdownMenuItem<String>(
                        value: user['_id'],
                        child: Text(user['name'] ?? ''),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedManagerId = value;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Nhân Viên',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    onTap: () async {
                      final selectedUsers = await showDialog<List<String>>(
                        context: context,
                        builder: (BuildContext context) {
                          final List<String> tempSelectedEmployeeIds = [
                            ...selectedEmployeeIds
                          ];
                          return AlertDialog(
                            title: Text('Chọn Nhân Viên'),
                            content: StatefulBuilder(
                              builder: (context, setDialogState) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: users.map((user) {
                                      return CheckboxListTile(
                                        title: Text(user['name'] ?? ''),
                                        value: tempSelectedEmployeeIds
                                            .contains(user['_id']),
                                        onChanged: (isChecked) {
                                          setDialogState(() {
                                            if (isChecked == true) {
                                              tempSelectedEmployeeIds
                                                  .add(user['_id']);
                                            } else {
                                              tempSelectedEmployeeIds
                                                  .remove(user['_id']);
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Hủy'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                      context, tempSelectedEmployeeIds);
                                },
                                child: Text('Chọn'),
                              ),
                            ],
                          );
                        },
                      );

                      if (selectedUsers != null) {
                        setState(() {
                          selectedEmployeeIds = selectedUsers;
                        });
                      }
                    },
                    controller: TextEditingController(
                      text: users
                          .where((user) =>
                              selectedEmployeeIds.contains(user['_id']))
                          .map((user) => user['name'])
                          .join(', '),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () => addOrUpdateCompany(company?['_id']),
                    child: Center(
                      child: Text(
                        company == null ? 'Thêm Công Ty' : 'Cập Nhật Công Ty',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,  
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản Lý Công Ty',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: companies.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        company['nameCompany'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(company['location'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () => showForm(company),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => deleteCompany(company['_id']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple, 
          onPressed: () => showForm(),
          child: Icon(
            Icons.add,
            color: Colors.white,  
          ),
        ),
    );
  }
}
