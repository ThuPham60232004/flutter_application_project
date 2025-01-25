import 'dart:ffi';

class CV {
  final String id;
  final String userId;
  final String title;
  final String summary;
  final Array? experience;
  final Array? education;
  final Array? skills;
  final Array? languages;
  final Array? certifications;
  CV({
    required this.id,
    required this.userId,
    required this.title,
    required this.summary,
    this.experience,
    this.education,
    this.skills,
    this.languages,
    this.certifications,
  });
  factory CV.fromJson(Map<String, dynamic> json) {
    return CV(
      id: json['_id'] ?? 'Unknown ID',
      userId: json['user']??'No ID user',
      title: json['title']??'No title',
      summary: json['summary']??'No summary',
      experience: json['experience'],
      education: json['education'],
      skills: json['skills'],
      languages: json['languages'],
      certifications: json['certifications'],
    );
  }
}
