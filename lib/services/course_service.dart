
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/course.dart';

class CourseService {
  // Memuat data lokal yang sudah digunakan sebelumnya.
  Future<List<Course>> loadCourses() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;

    return list
        .map(
          (e) => Course.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  // Mengambil data kursus dari REST API.
  Future<List<Map<String, dynamic>>> fetchCoursesFromApi() async {
    final url = Uri.parse(
      'https://course-api-pearl.vercel.app/courses',
    );

    final response = await http.get(url);

    // Periksa status code sebelum memproses JSON.
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is! List) {
        throw const FormatException(
          'Format respons API bukan berupa daftar data.',
        );
      }

      return data.map<Map<String, dynamic>>((item) {
        return Map<String, dynamic>.from(item as Map);
      }).toList();
    }

    throw Exception(
      'Gagal mengambil data. Status code: ${response.statusCode}',
    );
  }
}
