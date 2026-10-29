
class Course {
  final String? id;
  final String code;
  final String title;
  final int credits;
  final String status;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString(),
      code: json['code']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      credits: json['credits'] is int
          ? json['credits'] as int
          : int.tryParse(json['credits']?.toString() ?? '') ?? 0,
      status: json['status']?.toString() ?? 'Aktif',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    };
  }
}
