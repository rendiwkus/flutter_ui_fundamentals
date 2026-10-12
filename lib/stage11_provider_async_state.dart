import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'providers/course_provider.dart';

const String stage11StudentName = 'Rendi Wija Kusuma';
const String stage11StudentId = '2415051045';

class Stage11ProviderAsyncStatePage extends StatefulWidget {
  const Stage11ProviderAsyncStatePage({super.key});

  @override
  State<Stage11ProviderAsyncStatePage> createState() =>
      _Stage11ProviderAsyncStatePageState();
}

class _Stage11ProviderAsyncStatePageState
    extends State<Stage11ProviderAsyncStatePage> {
  @override
  void initState() {
    super.initState();

    // Memuat data setelah halaman selesai dibangun.
    Future.microtask(() {
      if (!mounted) return;
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 11 - Async State'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang data',
            onPressed: () {
              context.read<CourseProvider>().loadCourses();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: const Text(stage11StudentName),
                    subtitle: Text('NIM: $stage11StudentId'),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Daftar Mata Kuliah',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      avatar: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 18,
                      ),
                      label: Text('${provider.favoriteCount} favorit'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(child: _buildCourseContent(provider)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseContent(CourseProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Memuat data mata kuliah...'),
          ],
        ),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(provider.error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CourseProvider>().loadCourses();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (provider.courses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48),
            SizedBox(height: 12),
            Text('Belum ada data mata kuliah.'),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: provider.courses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final Course course = provider.courses[index];
        final bool favorite = provider.isFavorite(course.code);

        return Card(
          child: ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(course.title),
            subtitle: Text(
              'Kode: ${course.code}\n'
              'SKS: ${course.credits} • Status: ${course.status}',
            ),
            isThreeLine: true,
            trailing: IconButton(
              tooltip: favorite ? 'Hapus dari favorit' : 'Tambahkan ke favorit',
              onPressed: () {
                context.read<CourseProvider>().toggleFavorite(course.code);
              },
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.red : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
