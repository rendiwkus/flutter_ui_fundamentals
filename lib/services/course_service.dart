
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';

class CourseService {
  // API yang digunakan pada tahap HTTP sebelumnya.
  static const String baseUrl =
      'https://course-api-pearl.vercel.app';

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

  // HTTP GET: mengambil course dari REST API.
  Future<List<Course>> fetchCoursesFromApi() async {
    final response = await http.get(
      Uri.parse('$baseUrl/courses'),
    );

    debugPrint('HTTP Status: ${response.statusCode}');

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal mengambil course. '
        'Status HTTP: ${response.statusCode}',
      );
    }

    final dynamic data = jsonDecode(response.body);

    if (data is! List) {
      throw const FormatException(
        'Respons API bukan berupa daftar course.',
      );
    }

    return data.map<Course>((item) {
      return Course.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
    }).toList();
  }

  // HTTP DELETE: menghapus course dari REST API.
  // Fungsi ini dipertahankan untuk Tahap 12.
  Future<void> deleteCourse(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/courses/$id'),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        'Gagal menghapus course. '
        'Status HTTP: ${response.statusCode}',
      );
    }
  }

  // TAHAP 13: menambahkan course ke tabel Supabase.
  Future<void> createCourse({
    required String code,
    required String title,
    required int credits,
    required String status,
  }) async {
    final supabase = Supabase.instance.client;

    await supabase.from('courses').insert({
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    });
  }
}
