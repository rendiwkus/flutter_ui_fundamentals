import 'package:flutter/material.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

void main() {
  runApp(const MyApp());
}

const List<Map<String, dynamic>> courses = [
  {
    'title': 'Pemrograman Mobile',
    'code': 'PM101',
    'credits': 3,
  },
  {
    'title': 'Pemrograman Web',
    'code': 'PW101',
    'credits': 3,
  },
  {
    'title': 'Basis Data',
    'code': 'BD101',
    'credits': 3,
  },
  {
    'title': 'Jaringan Komputer',
    'code': 'JK101',
    'credits': 3,
  },
  {
    'title': 'Kecerdasan Buatan',
    'code': 'AI101',
    'credits': 3,
  },
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 12 - Interaction',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const CoursesPage(),
    );
  }
}

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 12 - Interaction'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            'Daftar Course',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap card untuk memilih dan tekan lama '
            'untuk melihat informasi.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          for (final course in courses)
            CourseCard(
              course: course,
            ),
        ],
      ),
    );
  }
}

class CourseCard extends StatefulWidget {
  final Map<String, dynamic> course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  bool isFavorite = false;

  void showCourseInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.course['title']} - '
          '${widget.course['code']} - '
          '${widget.course['credits']} SKS',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${widget.course['title']} dipilih.',
              ),
            ),
          );
        },
        onLongPress: showCourseInfo,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 26,
                child: Icon(
                  Icons.menu_book,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.course['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.course['code']} • '
                      '${widget.course['credits']} SKS',
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
                icon: Icon(
                  isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                tooltip: isFavorite
                    ? 'Hapus dari favorite'
                    : 'Tambah ke favorite',
              ),
            ],
          ),
        ),
      ),
    );
  }
}