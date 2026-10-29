
import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];

  bool isLoading = false;
  String? error;

  final Set<String> _favorites = {};

  Set<String> get favorites => Set.unmodifiable(_favorites);

  int get favoriteCount => _favorites.length;

  bool isFavorite(String courseId) {
    return _favorites.contains(courseId);
  }

  void toggleFavorite(String courseId) {
    if (_favorites.contains(courseId)) {
      _favorites.remove(courseId);
    } else {
      _favorites.add(courseId);
    }

    notifyListeners();
  }

  // Tahap sebelumnya: membaca data lokal.
  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Tahap 16: membaca data Supabase.
  Future<void> loadSupabaseCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.fetchCoursesFromSupabase();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Tahap 16: CREATE dan refresh data.
  Future<void> createCourse(Course course) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await repository.createCourse(
        code: course.code,
        title: course.title,
        credits: course.credits,
        status: course.status,
      );

      courses = await repository.fetchCoursesFromSupabase();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Tahap 16: UPDATE dan refresh data.
  Future<void> updateSupabaseCourse(Course course) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await repository.updateCourse(course);
      courses = await repository.fetchCoursesFromSupabase();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Tahap 16: DELETE dan refresh data.
  Future<void> deleteSupabaseCourse(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await repository.deleteCourseFromSupabase(id);
      courses = await repository.fetchCoursesFromSupabase();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
