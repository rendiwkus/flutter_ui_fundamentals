
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/course_provider.dart';

class Stage7WatchReadConsumerPage extends StatelessWidget {
  const Stage7WatchReadConsumerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Tahap 7 - Provider'),
        backgroundColor: const Color(0xFF172554),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          StudentIdentityCard(),
          SizedBox(height: 20),
          _PageIntroduction(),
          SizedBox(height: 20),

          // watch(): mendengarkan perubahan jumlah favorite.
          FavoriteCountCard(),

          SizedBox(height: 24),
          Text(
            'Daftar Course',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172554),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tekan ikon hati untuk menambah atau menghapus favorite.',
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(height: 12),

          CourseFavoriteItem(
            courseId: 'flutter-basic',
            title: 'Flutter Fundamentals',
            description: 'Dasar pengembangan aplikasi Flutter',
            icon: Icons.phone_android,
          ),
          CourseFavoriteItem(
            courseId: 'ui-design',
            title: 'UI/UX Design',
            description: 'Prinsip desain antarmuka aplikasi',
            icon: Icons.design_services,
          ),
          CourseFavoriteItem(
            courseId: 'dart-programming',
            title: 'Dart Programming',
            description: 'Dasar bahasa pemrograman Dart',
            icon: Icons.code,
          ),

          SizedBox(height: 20),
          _ConceptExplanation(),
        ],
      ),
    );
  }
}

// ======================================================
// IDENTITAS MAHASISWA
// ======================================================

class StudentIdentityCard extends StatelessWidget {
  const StudentIdentityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFF172554),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 30,
                color: Color(0xFF172554),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rendi Wija Kusuma',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'NIM: 2415051045',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Praktikum State Management',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// PENGANTAR HALAMAN
// ======================================================

class _PageIntroduction extends StatelessWidget {
  const _PageIntroduction();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Memahami Provider',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172554),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Pelajari cara membaca state, menjalankan aksi, '
          'dan membangun ulang bagian UI yang diperlukan.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ======================================================
// WATCH: MENDENGARKAN JUMLAH FAVORITE
// ======================================================

class FavoriteCountCard extends StatelessWidget {
  const FavoriteCountCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.favorite,
                color: Color(0xFFE11D48),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Favorite',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Course tersimpan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Text(
              '${provider.favoriteCount}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172554),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// CONSUMER: MEMBANGUN ULANG BAGIAN STATUS FAVORITE
// ======================================================

class CourseFavoriteItem extends StatelessWidget {
  final String courseId;
  final String title;
  final String description;
  final IconData icon;

  const CourseFavoriteItem({
    super.key,
    required this.courseId,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFDBEAFE),
          child: Icon(icon, color: const Color(0xFF1D4ED8)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description),
              const SizedBox(height: 8),

              // Consumer membatasi area yang mendengarkan state.
              Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  final favorite = provider.isFavorite(courseId);

                  return Row(
                    children: [
                      Icon(
                        favorite
                            ? Icons.check_circle
                            : Icons.info_outline,
                        size: 16,
                        color: favorite
                            ? Colors.green
                            : Colors.black45,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        favorite
                            ? 'Tersimpan di favorite'
                            : 'Belum menjadi favorite',
                        style: TextStyle(
                          fontSize: 12,
                          color: favorite
                              ? Colors.green.shade700
                              : Colors.black54,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        trailing: IconButton(
          tooltip: 'Ubah favorite',

          // read(): menjalankan aksi tanpa memasang listener.
          onPressed: () {
            context
                .read<CourseProvider>()
                .toggleFavorite(courseId);
          },
          icon: Consumer<CourseProvider>(
            builder: (context, provider, child) {
              final favorite = provider.isFavorite(courseId);

              return Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.pink : Colors.grey,
                size: 27,
              );
            },
          ),
        ),
      ),
    );
  }
}

// ======================================================
// RINGKASAN KONSEP
// ======================================================

class _ConceptExplanation extends StatelessWidget {
  const _ConceptExplanation();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFEFF6FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Konsep',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D4ED8),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'watch()  : membaca state dan mendengarkan perubahan.',
            ),
            SizedBox(height: 8),
            Text(
              'read()     : mengambil provider untuk menjalankan aksi.',
            ),
            SizedBox(height: 8),
            Text(
              'Consumer : mendengarkan perubahan pada bagian UI tertentu.',
            ),
          ],
        ),
      ),
    );
  }
}
