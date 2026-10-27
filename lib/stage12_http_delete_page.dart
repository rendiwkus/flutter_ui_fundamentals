import 'package:flutter/material.dart';

import 'models/course.dart';
import 'services/course_service.dart';

class Stage12HttpDeletePage extends StatefulWidget {
  const Stage12HttpDeletePage({super.key});

  @override
  State<Stage12HttpDeletePage> createState() =>
      _Stage12HttpDeletePageState();
}

class _Stage12HttpDeletePageState
    extends State<Stage12HttpDeletePage> {
  final CourseService service = CourseService();

  List<Course> courses = [];
  bool isLoading = false;
  String? errorMessage;
  String? deletingId;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await service.fetchCoursesFromApi();

      if (!mounted) return;

      setState(() {
        courses = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> confirmDelete(Course course) async {
    final id = course.id;

    if (id == null || id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID course tidak ditemukan dari API.'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${course.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await deleteCourse(id, course.title);
  }

  Future<void> deleteCourse(String id, String title) async {
    setState(() {
      deletingId = id;
    });

    try {
      await service.deleteCourse(id);

      if (!mounted) return;

      await loadCourses();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage == null
                ? '$title berhasil dihapus.'
                : 'Course terhapus, tetapi daftar gagal dimuat ulang.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus course: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          deletingId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 12 - HTTP DELETE'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: isLoading ? null : loadCourses,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (isLoading && courses.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (errorMessage != null && courses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: loadCourses,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (courses.isEmpty) {
            return const Center(
              child: Text('Tidak ada course.'),
            );
          }

          return RefreshIndicator(
            onRefresh: loadCourses,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final isDeleting = deletingId == course.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.menu_book),
                    ),
                    title: Text(course.title),
                    subtitle: Text(
                      '${course.code} • ${course.credits} SKS',
                    ),
                    trailing: isDeleting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : IconButton(
                            tooltip: 'Hapus course',
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: deletingId != null
                                ? null
                                : () => confirmDelete(course),
                          ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}