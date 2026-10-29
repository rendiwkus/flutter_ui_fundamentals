
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';

class SupabaseCourseService {
  final SupabaseClient _client = Supabase.instance.client;

  // READ: membaca course langsung dari Supabase.
  Future<List<Course>> fetchCourses() async {
    try {
      final response = await _client
          .from('courses')
          .select();

      debugPrint('Supabase response: $response');

      final courses = (response as List).map((item) {
        return Course.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();

      debugPrint('Jumlah course terbaca: ${courses.length}');

      return courses;
    } on PostgrestException catch (e) {
      debugPrint('Supabase error: ${e.message}');
      debugPrint('Supabase code: ${e.code}');
      debugPrint('Supabase details: ${e.details}');
      rethrow;
    } catch (e) {
      debugPrint('Error membaca course: $e');
      rethrow;
    }
  }

  // CREATE: menambahkan course baru.
  Future<void> createCourse({
    required String code,
    required String title,
    required int credits,
    required String status,
  }) async {
    await _client.from('courses').insert({
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
    });
  }

  // UPDATE: memperbarui course berdasarkan ID numerik.
  Future<void> updateCourse(Course course) async {
    final rawId = course.id;

    if (rawId == null || rawId.isEmpty) {
      throw Exception('ID course tidak ditemukan.');
    }

    final id = int.tryParse(rawId);

    if (id == null) {
      throw Exception(
        'ID course bukan angka. Periksa tipe kolom id di Supabase.',
      );
    }

    await _client
        .from('courses')
        .update({
          'code': course.code,
          'title': course.title,
          'credits': course.credits,
          'status': course.status,
        })
        .eq('id', id);
  }
}
