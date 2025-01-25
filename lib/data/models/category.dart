class Category {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  Category({
    required this.id,
    required this.name,
    this.description,
    this.icon,
  });
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? 'Unknown ID',
      name: json['name']??'Unknown name',
      description: json['description']?? 'Unknown description',
      icon: json['icon']?? 'unknown_icon',
    ); 
  }
}
