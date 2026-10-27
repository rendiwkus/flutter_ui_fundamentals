
import 'package:flutter/material.dart';

import 'services/course_service.dart';

class Stage2RestApiPage extends StatefulWidget {
  const Stage2RestApiPage({super.key});

  @override
  State<Stage2RestApiPage> createState() => _Stage2RestApiPageState();
}

class _Stage2RestApiPageState extends State<Stage2RestApiPage> {
  final CourseService _courseService = CourseService();

  List<Map<String, dynamic>> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;
  int? _statusCode;

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _statusCode = null;
    });

    try {
      final courses = await _courseService.fetchCoursesFromApi();

      if (!mounted) return;

      setState(() {
        _courses = courses;
        _statusCode = 200;
      });

      debugPrint('Status code: $_statusCode');
      debugPrint('Jumlah data: ${_courses.length}');
      debugPrint('Respons JSON: $_courses');
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
      });

      debugPrint('Terjadi kesalahan: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - REST API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengujian HTTP GET',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const SelectableText(
              'GET https://course-api-pearl.vercel.app/courses',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchCourses,
              child: Text(
                _isLoading ? 'Memuat data...' : 'Ambil Data API',
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator()),
            if (_statusCode != null)
              Text('Status code: $_statusCode'),
            if (_statusCode == 200)
              Text('Jumlah data: ${_courses.length}'),
            if (_errorMessage != null)
              SelectableText(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${course['id'] ?? index + 1}'),
                      ),
                      title: Text(
                        '${course['title'] ?? 'Tanpa judul'}',
                      ),
                      subtitle: Text(
                        'Kode: ${course['code'] ?? '-'}'
                        ' • SKS: ${course['credits'] ?? '-'}'
                        ' • Status: ${course['status'] ?? '-'}',
                      ),
                    ),
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
