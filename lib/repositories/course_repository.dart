
import '../models/course.dart';
import '../services/course_service.dart';

class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  // Mengambil data course dari REST API
  Future<List<Course>> getCourses() {
    return service.fetchCoursesFromApi();
  }

  // Menghapus course melalui REST API
  Future<void> deleteCourse(String id) {
    return service.deleteCourse(id);
  }
}
