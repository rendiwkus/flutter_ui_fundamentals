
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';

class SupabaseCourseService {
  final SupabaseClient _client = Supabase.instance.client;

  // READ: mengambil seluruh course dari Supabase.
  Future<List<Course>> fetchCourses() async {
    try {
      final response = await _client
          .from('courses')
          .select();

      return (response as List).map((item) {
        return Course.fromJson(
          Map<String, dynamic>.from(item as Map),
        );
      }).toList();
    } on PostgrestException catch (e) {
      debugPrint('Gagal membaca course: ${e.message}');
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

  // UPDATE: memperbarui course berdasarkan ID.
  Future<void> updateCourse(Course course) async {
    final rawId = course.id;

    if (rawId == null || rawId.isEmpty) {
      throw Exception('ID course tidak ditemukan.');
    }

    final id = int.tryParse(rawId);

    if (id == null) {
      throw Exception('ID course harus berupa angka.');
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

  // DELETE: menghapus course berdasarkan ID.
  Future<void> deleteCourse(int id) async {
    try {
      await _client
          .from('courses')
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      debugPrint('Gagal menghapus course: ${e.message}');
      rethrow;
    }
  }
}
