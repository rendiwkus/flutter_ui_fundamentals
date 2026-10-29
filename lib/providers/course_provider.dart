
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

  bool isFavorite(String courseId) =>
      _favorites.contains(courseId);

  void toggleFavorite(String courseId) {
    if (_favorites.contains(courseId)) {
      _favorites.remove(courseId);
    } else {
      _favorites.add(courseId);
    }

    notifyListeners();
  }

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

  Future<bool> deleteCourse(String id) async {
    try {
      await repository.deleteCourse(id);
      await loadCourses();
      return error == null;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
