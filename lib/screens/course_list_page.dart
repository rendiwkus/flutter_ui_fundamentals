import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';
import 'course_form_page.dart';
import '../widgets/course_card.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CourseProvider>().loadSupabaseCourses();
      }
    });
  }

  Future<void> _refresh() async {
    await context.read<CourseProvider>().loadSupabaseCourses();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openForm({Course? course}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CourseFormPage(course: course),
      ),
    );

    if (!mounted) return;
    if (result == true) {
      await _refresh();
      _showMessage(course == null
          ? 'Course berhasil ditambahkan.'
          : 'Course berhasil diperbarui.');
    }
  }

  Future<void> _confirmDelete(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus course?'),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${course.title}" (${course.code})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await context.read<CourseProvider>().deleteSupabaseCourse(
            course.id ?? '',
          );
      if (!mounted) return;
      _showMessage('Course berhasil dihapus.');
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal menghapus course: ${_cleanError(e)}');
    }
  }

  String _cleanError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Course Data Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Muat ulang',
            onPressed: () => _refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Course'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _StudentHeader(),
            ),
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading && provider.courses.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null && provider.courses.isEmpty) {
                    return _ErrorState(
                      message: _cleanError(Exception(provider.error!)),
                      onRetry: _refresh,
                    );
                  }

                  if (provider.courses.isEmpty) {
                    return _EmptyState(onAdd: () => _openForm());
                  }

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: provider.courses.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final course = provider.courses[index];
                        return CourseCard(
                          course: course,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailPage(course: course),
                              ),
                            );
                            if (mounted) await _refresh();
                          },
                          onEdit: () => _openForm(course: course),
                          onDelete: () => _confirmDelete(course),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Consumer<CourseProvider>(
              builder: (context, provider, _) {
                if (!provider.isLoading || provider.courses.isEmpty) {
                  return const SizedBox.shrink();
                }
                return const LinearProgressIndicator(minHeight: 2);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentHeader extends StatelessWidget {
  const _StudentHeader();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: const ListTile(
        leading: CircleAvatar(child: Icon(Icons.person)),
        title: Text(
          'Rendi Wija Kusuma',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('NIM: 2415051045'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school_outlined, size: 64),
            const SizedBox(height: 12),
            const Text(
              'Belum ada course',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Tambahkan course pertama ke database Supabase.'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Course'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 60, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => onRetry(),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
