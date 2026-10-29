
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';

class CourseSupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Course>> getCourses() async {
    final data = await supabase
        .from('courses')
        .select()
        .order('id');

    return (data as List)
        .map(
          (item) => Course.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
  
  Future<void> createCourse(Course course) async {
  await supabase
      .from('courses')
      .insert(course.toJson());
  }

}
