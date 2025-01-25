class User {
  final String id;
  final String token;
  final String name;
  final String profileImage;
  final String? email;
  final String? phone;
  final String? role;
  final String? resume;
  final String? companyId;
  final bool? isEmployee;

  User({
    required this.id,
    required this.token,
    required this.name,
    required this.profileImage,
    required this.email,
    this.phone,
    required this.role,
    this.resume,
    this.companyId,
    required this.isEmployee,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? 'Unknown ID', 
      token: json['token'] ?? '',
      name: json['name']?? 'Unknown Name',
      profileImage: json['img'] ??'',
      email: json['email'] ,
      phone: json['phone']?.toString(),
      role: json['role'] ?? 'job_seeker',
      resume: json['resume'],
      companyId: json['company'],
      isEmployee: json['isEmployee'] ?? false|| json['isEmployee'] == 'false', 
    );
  }
}
