import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_project/presentation/screens/client/create_profile.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<List<Map<String, dynamic>>> profileList;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    profileList = fetchProfiles();
  }

  Future<List<Map<String, dynamic>>> fetchProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('id');

    if (userId == null) {
      throw Exception('User ID not found in shared_preferences');
    }

    try {
      final response = await http
          .get(Uri.parse('https://backend-findjob.onrender.com/profile'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data
            .map<Map<String, dynamic>>(
                (item) => Map<String, dynamic>.from(item as Map))
            .toList();
      } else {
        throw Exception('Failed to load profiles');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void navigateToDetail(Map<String, dynamic> profile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailScreen(
          profile: profile,
          userId: profile['user']['_id'],
        ),
      ),
    );
  }

  void navigateToCreateProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: navigateToCreateProfile,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: profileList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No profiles found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final profile = snapshot.data![index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: profile['profileImage'] != null
                        ? FileImage(File(profile['profileImage']))
                        : const AssetImage('assets/icons/nen.png'),
                  ),
                  title: Text(profile['user']['name'] as String? ?? 'No Name'),
                  subtitle:
                      Text(profile['user']['email'] as String? ?? 'No Email'),
                  onTap: () => navigateToDetail(profile),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ProfileDetailScreen extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String userId;
  const ProfileDetailScreen({
    Key? key,
    required this.profile,
    required this.userId,
  }) : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  late Future<Map<String, dynamic>> profileData;
  late Map<String, dynamic> profile;
  bool isEditable = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    profileData = fetchProfileData();
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    try {
      final response = await http.get(Uri.parse(
          'https://backend-findjob.onrender.com/profile/${widget.userId}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> saveProfileChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('id');

    if (userId == null) {
      throw Exception('User ID not found in shared_preferences');
    }

    final response = await http.put(
      Uri.parse(
          'https://backend-findjob.onrender.com/profile/${widget.userId}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(profile),
    );

    if (response.statusCode == 200) {
      setState(() {
        isEditable = false;
      });
    } else {
      throw Exception('Failed to save profile changes');
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        profile['profileImage'] = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              isEditable ? Icons.save : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              if (isEditable) {
                saveProfileChanges();
              } else {
                setState(() {
                  isEditable = true;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            profile = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: profile['profileImage'] != null
                                ? FileImage(File(profile['profileImage']))
                                : const AssetImage('assets/icons/nen.png'),
                          ),
                          const SizedBox(height: 10),
                          if (isEditable)
                            IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: pickProfileImage,
                            ),
                          const SizedBox(height: 10),
                          buildEditableField("Vai trò",
                              profile['title'] ?? 'No Title', 'title'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildSectionHeader('Thông tin cá nhân', () {},
                        showAddButton: false),
                    buildCard([
                      buildEditableField("Tên người dùng",
                          profile['user']?['name'] ?? "No Name", 'user.name'),
                      buildEditableField("Email",
                          profile['user']?['email'] ?? "No Data", 'user.email'),
                      buildEditableField(
                          "Số điện thoại",
                          profile['contactInfo']?['phone'] ?? "No Data",
                          'contactInfo.phone'),
                    ]),
                    buildSectionHeader('Học vấn', addNewEducation,
                        showAddButton: false),
                    buildCard(
                      (profile['education'] as List<dynamic>? ?? [])
                          .map((education) {
                        return Column(
                          children: [
                            buildEditableField(
                              "Tên trường",
                              education['schoolName'] ?? '',
                              'education[${profile['education']?.indexOf(education)}].schoolName',
                            ),
                            buildEditableField(
                              "Chuyên ngành",
                              education['fieldOfStudy'] ?? '',
                              'education[${profile['education']?.indexOf(education)}].fieldOfStudy',
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ),
                    buildSectionHeader(
                        'Kinh nghiệm làm việc', addNewExperience),
                    buildCard(
                      (profile['experiences'] as List<dynamic>? ?? [])
                          .map((experience) {
                        return Column(
                          children: [
                            buildEditableField(
                              "Công ty",
                              experience['companyName'] ?? '',
                              'experiences[${profile['experiences']?.indexOf(experience)}].companyName',
                            ),
                            buildEditableField(
                              "Chức vụ",
                              experience['jobTitle'] ?? '',
                              'experiences[${profile['experiences']?.indexOf(experience)}].jobTitle',
                            ),
                            const Divider(),
                          ],
                        );
                      }).toList(),
                    ),
                    buildSectionHeader('Kỹ năng', addNewSkill),
                    buildCard(
                      (profile['skills'] as List<dynamic>? ?? []).map((skill) {
                        return buildEditableField(
                          "Kỹ năng",
                          skill['name'] ?? '',
                          'skills[${profile['skills']?.indexOf(skill)}].name',
                        );
                      }).toList(),
                    ),
                    buildSectionHeader('Ngôn ngữ', addNewLanguage,
                        showAddButton: isEditable),
                    buildCard(
                      (profile['languages'] as List<dynamic>? ?? [])
                          .map((language) {
                        return buildEditableField(
                          "Ngôn ngữ",
                          language['name'] ?? '',
                          'languages[${profile['languages']?.indexOf(language)}].name',
                        );
                      }).toList(),
                    ),
                    buildSectionHeader('Chứng chỉ', addNewCertification,
                        showAddButton: isEditable),
                    buildCard(
                      (profile['certifications'] as List<dynamic>? ?? [])
                          .map((certification) {
                        return buildEditableField(
                          "Chứng chỉ",
                          certification['name'] ?? '',
                          'certifications[${profile['certifications']?.indexOf(certification)}].name',
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildSectionHeader(String title, VoidCallback onAdd,
      {bool showAddButton = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          if (showAddButton)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.deepPurple),
              onPressed: onAdd,
            ),
        ],
      ),
    );
  }

  Widget buildCard(List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget buildEditableField(String label, String value, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: value,
        readOnly: !isEditable,
        onChanged: (newValue) {
          setState(() {
            updateProfile(key, newValue);
          });
        },
        decoration: InputDecoration(
          labelText: label,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  void updateProfile(String key, String value) {
    final keys = key.split('.');
    var tempProfile = profile;

    for (int i = 0; i < keys.length - 1; i++) {
      if (keys[i].contains('[')) {
        final match = RegExp(r'(\w+)\[(\d+)\]').firstMatch(keys[i]);
        final field = match?.group(1);
        final index = int.parse(match!.group(2)!);
        tempProfile = tempProfile[field]?[index];
      } else {
        tempProfile = tempProfile[keys[i]];
      }
    }
    tempProfile[keys.last] = value;
  }

  void addNewEducation() {
    setState(() {
      profile['education'] = (profile['education'] as List<dynamic>? ?? []);
      profile['education'].add({'schoolName': '', 'fieldOfStudy': ''});
    });
  }

  void addNewExperience() {
    setState(() {
      profile['experiences'] = (profile['experiences'] as List<dynamic>? ?? []);
      profile['experiences'].add({'companyName': '', 'jobTitle': ''});
    });
  }

  void addNewSkill() {
    setState(() {
      profile['skills'] = (profile['skills'] as List<dynamic>? ?? []);
      profile['skills'].add({'name': '', 'proficiencyLevel': 'Beginner'});
    });
  }

  void addNewLanguage() {
    setState(() {
      profile['languages'] = (profile['languages'] as List<dynamic>? ?? []);
      profile['languages'].add({'name': '', 'proficiencyLevel': 'Basic'});
    });
  }

  void addNewCertification() {
    setState(() {
      profile['certifications'] =
          (profile['certifications'] as List<dynamic>? ?? []);
      profile['certifications'].add({'name': '', 'issuedBy': ''});
    });
  }
}
