
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah Favorit'),
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          final favoriteCourses = provider.courses
              .where((course) => provider.isFavorite(course.code))
              .toList();

          if (provider.isLoading && provider.courses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null && provider.courses.isEmpty) {
            return Center(
              child: Text('Gagal memuat data: ${provider.error}'),
            );
          }

          if (favoriteCourses.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Belum ada mata kuliah favorit.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final course = favoriteCourses[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.menu_book,
                    color: Colors.indigo,
                  ),
                  title: Text(course.title),
                  subtitle: Text(
                    '${course.code} • ${course.credits} SKS',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseDetailPage(
                          course: course,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    tooltip: 'Hapus dari favorit',
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(course.code);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
