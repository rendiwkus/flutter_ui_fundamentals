import 'package:flutter/material.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 8 - Passing Data',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CourseListPage(),
    );
  }
}

// =====================================================
// DATA COURSE
// =====================================================

const List<Map<String, dynamic>> courses = [
  {
    'title': 'Pemrograman Mobile',
    'code': 'PM101',
    'credits': 3,
    'status': 'Aktif',
  },
  {
    'title': 'Pemrograman Web',
    'code': 'PW101',
    'credits': 3,
    'status': 'Aktif',
  },
  {
    'title': 'Basis Data',
    'code': 'BD101',
    'credits': 3,
    'status': 'Aktif',
  },
  {
    'title': 'Jaringan Komputer',
    'code': 'JK101',
    'credits': 3,
    'status': 'Aktif',
  },
  {
    'title': 'Kecerdasan Buatan',
    'code': 'AI101',
    'credits': 3,
    'status': 'Aktif',
  },
];

// =====================================================
// COURSE LIST PAGE
// =====================================================

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Course'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // IDENTITAS
          const Text(
            studentName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            'NIM: 2415051045',
            style: TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Pilih salah satu course:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // MENAMPILKAN COURSE
          for (final course in courses)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.menu_book),
                ),
                title: Text(
                  course['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${course['code']} • ${course['credits']} SKS',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),

                // KETIKA COURSE DITEKAN
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
              ),
            ),
        ],
      ),
    );
  }
}

// =====================================================
// COURSE DETAIL PAGE
// =====================================================

class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Course'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.menu_book,
              size: 80,
            ),

            const SizedBox(height: 24),

            const Text(
              'Detail Course',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            // TITLE
            const Text(
              'Title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              course['title'],
              style: const TextStyle(
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 20),

            // CODE
            const Text(
              'Code',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              course['code'],
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20),

            // CREDITS
            const Text(
              'Credits',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              '${course['credits']} SKS',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 20),

            // STATUS
            const Text(
              'Status',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              course['status'],
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 20),

            // IDENTITAS MAHASISWA
            const Text(
              'Mahasiswa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              studentName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'NIM: 2415051045',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}