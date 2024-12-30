class User {
  final String token;
  final String name;
  final String profileImage;

  User({required this.token, required this.name, required this.profileImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'] ?? '',
      name: json['details']['name'] ?? '',
      profileImage: json['details']['img'] ?? '',
    );
  }
}
