
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

class Stage7WatchReadConsumerPage extends StatelessWidget {
  const Stage7WatchReadConsumerPage({super.key});

  static const List<Map<String, String>> courses = [
    {'code': 'PM101', 'title': 'Pemrograman Mobile'},
    {'code': 'PW101', 'title': 'Pemrograman Web'},
    {'code': 'BD101', 'title': 'Basis Data'},
    {'code': 'JK101', 'title': 'Jaringan Komputer'},
    {'code': 'AI101', 'title': 'Kecerdasan Buatan'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7 - Provider'),
      ),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(studentName),
              subtitle: Text('NIM: $studentId'),
            ),
          ),

          // WATCH: mendengarkan perubahan jumlah favorite.
          Consumer<CourseProvider>(
            builder: (context, provider, child) {
              final favoriteCount = provider.favorites.length;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  title: const Text('Jumlah Favorite'),
                  trailing: Text(
                    '$favoriteCount',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Mata Kuliah',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final course = courses[index];
                final code = course['code']!;
                final title = course['title']!;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.school),
                    ),
                    title: Text(title),
                    subtitle: Text('Kode: $code'),

                    // CONSUMER: hanya bagian tombol favorite
                    // yang perlu dibangun ulang saat state berubah.
                    trailing: Consumer<CourseProvider>(
                      builder: (context, provider, child) {
                        final isFavorite = provider.isFavorite(code);

                        return IconButton(
                          tooltip: isFavorite
                              ? 'Hapus dari favorite'
                              : 'Tambahkan ke favorite',
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),

                          // READ: menjalankan aksi tanpa listen.
                          onPressed: () {
                            context
                                .read<CourseProvider>()
                                .toggleFavorite(code);
                          },
                        );
                      },
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
