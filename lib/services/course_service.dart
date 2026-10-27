
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  // Mengambil data course dari file JSON lokal.
  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;

    return list.map((item) {
      return Course.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // Mengambil data course dari REST API menggunakan HTTP GET.
  Future<List<Course>> fetchCoursesFromApi() async {
    final url = Uri.parse(
      'https://course-api-pearl.vercel.app/courses',
    );

    final response = await http.get(url);

    debugPrint('HTTP Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      if (data is! List) {
        throw const FormatException(
          'Format respons API bukan berupa daftar data.',
        );
      }

      final courses = data.map<Course>((item) {
        return Course.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();

      debugPrint('Jumlah course: ${courses.length}');

      return courses;
    }

    throw Exception(
      'Gagal mengambil data course. '
      'Status HTTP: ${response.statusCode}',
    );
  }
}
