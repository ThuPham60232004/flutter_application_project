class Application {
  final String id;
  final String userId;
  final String jobId;
  final String status;
  Application(
    { 
      required this.id,
      required this.userId,
      required this.jobId,
      required this.status
    });
  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['_id'] ?? 'Unknown ID',
      userId: json['user']?? 'No ID User',
      jobId: json['job']??'No ID Job',
      status: json['status']??'No Pending',
    );
  }
}
