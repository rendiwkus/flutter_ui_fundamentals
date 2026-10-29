
import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  // Mengambil course dari sumber lokal.
  // Dipertahankan untuk kompatibilitas dengan tahap sebelumnya.
  Future<List<Course>> getCourses() async {
    return service.loadCourses();
  }

  // Mengambil course dari REST API.
  Future<List<Course>> fetchCoursesFromApi() async {
    return service.fetchCoursesFromApi();
  }

  // Tahap 13: menambahkan course ke Supabase.
  Future<void> createCourse({
    required String code,
    required String title,
    required int credits,
    required String status,
  }) async {
    await service.createCourse(
      code: code,
      title: title,
      credits: credits,
      status: status,
    );
  }

  // Mempertahankan operasi DELETE Tahap 12.
  Future<void> deleteCourse(String id) async {
    await service.deleteCourse(id);
  }
}
