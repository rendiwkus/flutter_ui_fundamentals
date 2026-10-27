
import 'package:flutter/material.dart';

import 'models/course.dart';
import 'services/course_service.dart';

class Stage2RestApiPage extends StatefulWidget {
  const Stage2RestApiPage({super.key});

  @override
  State<Stage2RestApiPage> createState() =>
      _Stage2RestApiPageState();
}

class _Stage2RestApiPageState extends State<Stage2RestApiPage> {
  final CourseService _courseService = CourseService();

  List<Course> _courses = [];
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
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.toString();
      });
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _fetchCourses,
              icon: const Icon(Icons.cloud_download),
              label: const Text('Ambil Data dari API'),
            ),
            const SizedBox(height: 12),

            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (_statusCode != null)
              Text(
                'Status HTTP: $_statusCode',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            if (_errorMessage != null)
              Text(
                'Error: $_errorMessage',
                style: const TextStyle(color: Colors.red),
              ),

            const SizedBox(height: 8),

            Expanded(
              child: _courses.isEmpty && !_isLoading
                  ? const Center(
                      child: Text(
                        'Tekan tombol untuk mengambil data course.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        final course = _courses[index];

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(course.title),
                            subtitle: Text(
                              'Kode: ${course.code}\n'
                              'SKS: ${course.credits}\n'
                              'Status: ${course.status}',
                            ),
                            isThreeLine: true,
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
