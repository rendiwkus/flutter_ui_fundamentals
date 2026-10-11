
import 'package:flutter/material.dart';

import 'models/course.dart';
import 'services/course_service.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

class Stage9CourseServicePage extends StatefulWidget {
  const Stage9CourseServicePage({super.key});

  @override
  State<Stage9CourseServicePage> createState() =>
      _Stage9CourseServicePageState();
}

class _Stage9CourseServicePageState
    extends State<Stage9CourseServicePage> {
  final CourseService _service = CourseService();

  late Future<List<Course>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  void _loadCourses() {
    _coursesFuture = _service.loadCourses();
  }

  void _retry() {
    setState(() {
      _loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Tahap 9 - Course Service'),
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: const Color(0xFF172554),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IDENTITAS MAHASISWA',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: $studentId',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Daftar Mata Kuliah',
            style: TextStyle(
              color: Color(0xFF172554),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Data dibaca dari assets/data/student_data.json '
            'melalui CourseService.',
            style: TextStyle(color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Course>>(
            future: _coursesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 42,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Gagal memuat data mata kuliah.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _retry,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final courses = snapshot.data ?? [];

              if (courses.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Belum ada data mata kuliah.'),
                  ),
                );
              }

              return Column(
                children: courses.map((course) {
                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE0E7FF),
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      title: Text(
                        course.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Kode: ${course.code}\n'
                          'SKS: ${course.credits}\n'
                          'Status: ${course.status}',
                        ),
                      ),
                      isThreeLine: true,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
