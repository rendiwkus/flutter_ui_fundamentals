
import '../models/course.dart';
import '../services/course_service.dart';
import '../services/course_supabase_service.dart';

class CourseRepository {
  final CourseService service;
  final SupabaseCourseService supabaseService;

  CourseRepository(
    this.service, {
    SupabaseCourseService? supabaseService,
  }) : supabaseService = supabaseService ?? SupabaseCourseService();

  // Tahap sebelumnya: data lokal.
  Future<List<Course>> getCourses() async {
    return service.loadCourses();
  }

  // Tahap sebelumnya: REST API.
  Future<List<Course>> fetchCoursesFromApi() async {
    return service.fetchCoursesFromApi();
  }

  // Tahap 16: READ dari Supabase.
  Future<List<Course>> fetchCoursesFromSupabase() async {
    return supabaseService.fetchCourses();
  }

  // Tahap 16: CREATE ke Supabase.
  Future<void> createCourse({
    required String code,
    required String title,
    required int credits,
    required String status,
  }) async {
    await supabaseService.createCourse(
      code: code,
      title: title,
      credits: credits,
      status: status,
    );
  }

  // Tahap 16: UPDATE di Supabase.
  Future<void> updateCourse(Course course) async {
    await supabaseService.updateCourse(course);
  }

  // Tahap 16: DELETE di Supabase.
  Future<void> deleteCourseFromSupabase(String id) async {
    final numericId = int.tryParse(id);

    if (numericId == null) {
      throw Exception('ID course harus berupa angka.');
    }

    await supabaseService.deleteCourse(numericId);
  }

  // Mempertahankan DELETE tahap sebelumnya.
  Future<void> deleteCourse(String id) async {
    await service.deleteCourse(id);
  }
}
