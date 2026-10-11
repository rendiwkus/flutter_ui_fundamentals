
import 'package:flutter/material.dart';

import 'models/course.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

class Stage8CourseModelPage extends StatelessWidget {
  const Stage8CourseModelPage({super.key});

  // Contoh satu data yang masih berbentuk JSON/Map.
  static const Map<String, dynamic> sampleJson = {
    'code': 'IF101',
    'title': 'Flutter Fundamentals',
    'credits': 3,
    'status': 'Aktif',
  };

  @override
  Widget build(BuildContext context) {
    // Mengubah Map menjadi objek Course.
    final Course course = Course.fromJson(sampleJson);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Tahap 8 - Course Model'),
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Identitas mahasiswa wajib terlihat.
          Card(
            elevation: 0,
            color: const Color(0xFF172554),
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
                      letterSpacing: 1.2,
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
            'Hasil Parsing JSON',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data Map berhasil diubah menjadi objek Course menggunakan '
            'factory Course.fromJson().',
            style: TextStyle(color: Colors.black54, height: 1.5),
          ),
          const SizedBox(height: 18),

          Card(
            elevation: 1,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 40,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _CourseInfoRow(
                    label: 'Kode Mata Kuliah',
                    value: course.code,
                  ),
                  _CourseInfoRow(
                    label: 'Jumlah SKS',
                    value: '${course.credits} SKS',
                  ),
                  _CourseInfoRow(
                    label: 'Status',
                    value: course.status,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Card(
            elevation: 0,
            color: const Color(0xFFE0E7FF),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data sumber (Map)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172554),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sampleJson.entries
                        .map((entry) => '${entry.key}: ${entry.value}')
                        .join('\n'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _CourseInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
