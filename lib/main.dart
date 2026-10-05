import 'package:flutter/material.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

void main() {
  runApp(const MyApp());
}

// DATA COURSE DALAM COLLECTION
const List<Course> courses = [
  Course(
    title: 'Pemrograman Mobile',
    description: 'Belajar membuat aplikasi mobile menggunakan Flutter.',
  ),
  Course(
    title: 'Pemrograman Web',
    description: 'Mempelajari dasar pengembangan aplikasi berbasis web.',
  ),
  Course(
    title: 'Basis Data',
    description: 'Mempelajari database, tabel, relasi, dan SQL.',
  ),
  Course(
    title: 'Jaringan Komputer',
    description: 'Mempelajari konsep jaringan dan komunikasi data.',
  ),
  Course(
    title: 'Kecerdasan Buatan',
    description: 'Mempelajari konsep dasar artificial intelligence.',
  ),
  Course(
    title: 'UI/UX Design',
    description: 'Mempelajari perancangan antarmuka dan pengalaman pengguna.',
  ),
];

class Course {
  final String title;
  final String description;

  const Course({
    required this.title,
    required this.description,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 5 - GridView Responsif',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CourseGridPage(),
    );
  }
}

class CourseGridPage extends StatelessWidget {
  const CourseGridPage({super.key});

  // MENENTUKAN JUMLAH KOLOM BERDASARKAN LEBAR LAYAR
  int columnsFor(double width) {
    if (width < 600) {
      return 1;
    }

    if (width < 840) {
      return 2;
    }

    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - GridView Responsif'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER IDENTITAS
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
            const SizedBox(height: 20),

            const Text(
              'Daftar Course',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // GRID RESPONSIF
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          columnsFor(constraints.maxWidth),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      return CourseCard(
                        course: courses[index],
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

// WIDGET CARD COURSE
class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.menu_book,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              course.title,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                course.description,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lihat Course',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}