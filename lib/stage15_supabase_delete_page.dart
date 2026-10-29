
import 'package:flutter/material.dart';

import 'models/course.dart';
import 'services/course_supabase_service.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

class Stage15SupabaseDeletePage extends StatefulWidget {
  const Stage15SupabaseDeletePage({super.key});

  @override
  State<Stage15SupabaseDeletePage> createState() =>
      _Stage15SupabaseDeletePageState();
}

class _Stage15SupabaseDeletePageState
    extends State<Stage15SupabaseDeletePage> {
  final SupabaseCourseService service = SupabaseCourseService();

  List<Course> courses = [];
  bool isLoading = false;
  String? errorMessage;
  int? deletingId;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await service.fetchCourses();

      if (!mounted) return;

      setState(() {
        courses = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> confirmDelete(Course course) async {
    final rawId = course.id;
    final id = rawId == null ? null : int.tryParse(rawId);

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'ID course tidak valid. Data tidak dihapus.',
          ),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah kamu yakin ingin menghapus '
            '"${course.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    await deleteCourse(id, course.title);
  }

  Future<void> deleteCourse(int id, String title) async {
    setState(() {
      deletingId = id;
      errorMessage = null;
    });

    try {
      await service.deleteCourse(id);

      if (!mounted) return;

      // Refresh setelah DELETE berhasil.
      await loadCourses();

      if (!mounted) return;

      final refreshError = errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            refreshError == null
                ? '$title berhasil dihapus.'
                : '$title terhapus, tetapi daftar gagal dimuat ulang.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus course: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          deletingId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 15 - Supabase DELETE'),
        actions: [
          IconButton(
            tooltip: 'Refresh data',
            onPressed: isLoading ? null : loadCourses,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                title: const Text(studentName),
                subtitle: Text('NIM: $studentId'),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading && courses.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null && courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 12),
              const Text(
                'Gagal memuat data dari Supabase.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: loadCourses,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (courses.isEmpty) {
      return RefreshIndicator(
        onRefresh: loadCourses,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 160),
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Center(
              child: Text('Belum ada course di Supabase.'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: loadCourses,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final rawId = course.id;
          final id = rawId == null ? null : int.tryParse(rawId);
          final isDeleting = id != null && deletingId == id;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.menu_book),
              ),
              title: Text(course.title),
              subtitle: Text(
                '${course.code} • ${course.credits} SKS'
                '\nStatus: ${course.status}',
              ),
              isThreeLine: true,
              trailing: isDeleting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : IconButton(
                      tooltip: 'Hapus course',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: deletingId != null
                          ? null
                          : () => confirmDelete(course),
                    ),
            ),
          );
        },
      ),
    );
  }
}
