
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';

class SupabaseCourseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Membaca course langsung dari tabel Supabase.
  Future<List<Course>> fetchCourses() async {
    final response = await _client
        .from('courses')
        .select()
        .order('id', ascending: true);

    return (response as List)
        .map(
          (item) => Course.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  // Menambahkan course baru ke tabel Supabase.
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
}
