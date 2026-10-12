import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  // Data mata kuliah
  List<Course> courses = [];

  // Status asynchronous
  bool isLoading = false;
  String? error;

  // Data favorit dari tahap sebelumnya
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

  // Memuat data mata kuliah
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
}
