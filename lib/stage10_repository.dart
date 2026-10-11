
import 'package:flutter/material.dart';

import 'models/course.dart';
import 'repositories/course_repository.dart';
import 'services/course_service.dart';

class Stage10RepositoryPage extends StatefulWidget {
  const Stage10RepositoryPage({super.key});

  @override
  State<Stage10RepositoryPage> createState() =>
      _Stage10RepositoryPageState();
}

class _Stage10RepositoryPageState
    extends State<Stage10RepositoryPage> {
  late final CourseRepository _repository;
  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();

    _repository = CourseRepository(CourseService());
    _coursesFuture = _repository.getCourses();
  }

  void _reloadCourses() {
    setState(() {
      _coursesFuture = _repository.getCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 10 - Repository'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            icon: const Icon(Icons.refresh),
            onPressed: _reloadCourses,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rendi Wija Kusuma',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text('NIM: 2415051045'),
            const SizedBox(height: 16),
            const Text(
              'Data dimuat melalui CourseRepository '
              'dan CourseService.',
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Course>>(
                future: _coursesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 40,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Gagal memuat data:\n${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _reloadCourses,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  final courses = snapshot.data ?? [];

                  if (courses.isEmpty) {
                    return const Center(
                      child: Text('Belum ada data mata kuliah.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(course.credits.toString()),
                          ),
                          title: Text(course.title),
                          subtitle: Text(
                            '${course.code} • ${course.status}',
                          ),
                          trailing: const Icon(
                            Icons.check_circle_outline,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
