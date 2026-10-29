
import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  // Data mata kuliah.
  List<Course> courses = [];

  // Status asynchronous.
  bool isLoading = false;
  String? error;

  // Data favorit dari tahap sebelumnya.
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

  // Memuat data mata kuliah dari repository.
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

  // Menambahkan course melalui repository ke Supabase.
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
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}