import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  List users = [];
  List companies = [];
  String? selectedCompany;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'name': '',
    'email': '',
    'password': '',
    'phone': '',
    'role': 'job_seeker',
    'company': null,
    'isVerified': false,
    'status': 'active',
    'img': null,
  };
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchCompanies();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse('https://backend-findjob.onrender.com/user'));
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCompanies() async {
    try {
      final response = await http
          .get(Uri.parse('https://backend-findjob.onrender.com/company'));
      if (response.statusCode == 200) {
        setState(() {
          companies = json.decode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final response = await http.post(
          Uri.parse('https://backend-findjob.onrender.com/user/add/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(_formData),
        );

        if (response.statusCode == 200) {
          fetchUsers();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User added successfully!')),
          );
        } else {
          print('Failed to add user: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add user: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  Future<void> updateUser(String userId) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        Map<String, String> headers = {'Content-Type': 'application/json'};
        String body = json.encode(_formData);

        await http.put(
          Uri.parse('https://backend-findjob.onrender.com/user/$userId'),
          headers: headers,
          body: body,
        );
        fetchUsers();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await http.delete(
          Uri.parse('https://backend-findjob.onrender.com/user/$userId'));
      fetchUsers();
    } catch (e) {
      print(e);
    }
  }

  void showUserForm({Map? user}) {
    if (user != null) {
      _formData['name'] = user['name'];
      _formData['email'] = user['email'];
      _formData['password'] = user['password'];
      _formData['phone'] = user['phone'].toString();
      _formData['role'] = user['role'];
      _formData['company'] = user['company'];
      _formData['isVerified'] = user['isVerified'];
      _formData['status'] = user['status'];
      selectedCompany = user['company'];
    } else {
      _formData.clear();
      _formData['role'] = 'job_seeker';
      _formData['isVerified'] = false;
      _formData['status'] = 'active';
      selectedCompany = null;
      selectedImage = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _formData['name'],
                    decoration: InputDecoration(labelText: 'Name'),
                    onSaved: (value) => _formData['name'] = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a name' : null,
                  ),
                  TextFormField(
                    initialValue: _formData['email'],
                    decoration: InputDecoration(labelText: 'Email'),
                    onSaved: (value) => _formData['email'] = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter an email' : null,
                  ),
                  TextFormField(
                    initialValue: _formData['password'],
                    decoration: InputDecoration(labelText: 'Password'),
                    onSaved: (value) => _formData['password'] = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter a password' : null,
                    obscureText: true,
                  ),
                  TextFormField(
                    initialValue: _formData['phone'],
                    decoration: InputDecoration(labelText: 'Phone'),
                    onSaved: (value) => _formData['phone'] = value ?? '',
                  ),
                  DropdownButtonFormField<String>(
                    value: _formData['role'],
                    items: ['job_seeker', 'job_poster', 'admin']
                        .map((role) => DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _formData['role'] = value),
                    decoration: InputDecoration(labelText: 'Role'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _formData['status'],
                    items: ['active', 'suspended', 'deleted']
                        .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _formData['status'] = value),
                    decoration: InputDecoration(labelText: 'Status'),
                  ),
                  SwitchListTile(
                    value: _formData['isVerified'] ?? false,
                    title: Text('Verified'),
                    onChanged: (value) =>
                        setState(() => _formData['isVerified'] = value),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedCompany,
                    items: companies.map<DropdownMenuItem<String>>((company) {
                      return DropdownMenuItem<String>(
                        value: company['_id'],
                        child: Text(company['nameCompany']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCompany = value;
                        _formData['company'] = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Company'),
                  ),
                  ElevatedButton.icon(
                    onPressed: pickImage,
                    icon: Icon(Icons.image),
                    label: Text('Upload Image'),
                  ),
                  if (selectedImage != null)
                    Image.file(
                      File(selectedImage!.path),
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (user == null) {
                  addUser();
                } else {
                  updateUser(user['_id']);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            child: ListTile(
              title: Text(user['name']),
              subtitle: Text(user['email']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => showUserForm(user: user),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteUser(user['_id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showUserForm(),
        label: Text('Add User'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
