class Job {
  final String id;
  final String title;
  final String? description;
  final String? location;
  final double salary;
  final String? type;
  final String idCompany;
  final String postedBy;
  final String idCategory;
  Job(
    {
    required this.id,
    required this.title,
    this.description,
    this.location,
    required this.salary,
    this.type,
    required this.idCompany,
    required this.postedBy,
    required this.idCategory,}
  );
  factory Job.fromJson(Map<String, dynamic> json){
    return Job(
      id: json['_id'] ?? 'Unknown ID',
      title: json['title']??'No title',
      description: json['description']??'No description',
      location: json['location']??'No location',
      salary: json['salary']??0,
      type: json['type']??'full_time',
      idCompany: json['idCompany']??'No idCompany',
      postedBy: json['postedBy']??'No posted',
      idCategory: json['idCategory']??'No ID Category',
    );
  }
}
