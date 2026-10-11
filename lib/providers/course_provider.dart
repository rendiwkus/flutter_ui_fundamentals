
import 'package:flutter/foundation.dart';

/// Mengelola state favorite untuk Course Explorer.
///
/// Class ini akan disediakan melalui Provider agar bisa
/// diakses oleh widget di dalam widget tree.
class CourseProvider extends ChangeNotifier {
  final Set<String> _favorites = {};

  /// Daftar ID course yang sedang menjadi favorite.
  Set<String> get favorites => Set.unmodifiable(_favorites);

  /// Jumlah course yang menjadi favorite.
  int get favoriteCount => _favorites.length;

  /// Memeriksa apakah sebuah course sudah menjadi favorite.
  bool isFavorite(String courseId) {
    return _favorites.contains(courseId);
  }

  /// Menambahkan atau menghapus course dari favorite.
  void toggleFavorite(String courseId) {
    if (_favorites.contains(courseId)) {
      _favorites.remove(courseId);
    } else {
      _favorites.add(courseId);
    }

    // Memberi tahu listener bahwa state telah berubah.
    notifyListeners();
  }
}
