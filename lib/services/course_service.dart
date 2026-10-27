import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  static const String baseUrl =
      'https://course-api-pearl.vercel.app';

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

  Future<List<Course>> fetchCoursesFromApi() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courses'),
    );

    debugPrint('HTTP GET Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);

      if (data is! List) {
        throw const FormatException(
          'Format respons API bukan berupa daftar data.',
        );
      }

      return data.map<Course>((item) {
        return Course.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    }

    throw Exception(
      'Gagal mengambil data course. '
      'Status HTTP: ${response.statusCode}',
    );
  }

  Future<void> deleteCourse(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$id'),
    );

    debugPrint('HTTP DELETE Status: ${response.statusCode}');

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal menghapus course. '
        'Status HTTP: ${response.statusCode}',
      );
    }
  }
}