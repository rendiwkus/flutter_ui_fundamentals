
import 'package:flutter/material.dart';

import 'models/course.dart';
import 'services/course_supabase_service.dart';

const String stage14StudentName = 'Rendi Wija Kusuma';
const String stage14StudentId = '2415051045';

class Stage14SupabaseUpdatePage extends StatefulWidget {
  const Stage14SupabaseUpdatePage({super.key});

  @override
  State<Stage14SupabaseUpdatePage> createState() =>
      _Stage14SupabaseUpdatePageState();
}

class _Stage14SupabaseUpdatePageState
    extends State<Stage14SupabaseUpdatePage> {
  final SupabaseCourseService _service = SupabaseCourseService();

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _updatingId;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  // Membaca daftar course langsung dari Supabase.
  Future<void> _loadCourses() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _service.fetchCourses();

      if (!mounted) return;

      setState(() {
        _courses = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Membuka dialog edit dengan nilai course yang lama.
  Future<void> _showEditDialog(Course course) async {
    if (_updatingId != null) return;

    if (course.id == null || course.id!.isEmpty) {
      _showMessage('ID course tidak ditemukan.');
      return;
    }

    final formKey = GlobalKey<FormState>();
    final codeController = TextEditingController(
      text: course.code,
    );
    final titleController = TextEditingController(
      text: course.title,
    );
    final creditsController = TextEditingController(
      text: course.credits.toString(),
    );

    String status = course.status;
    bool saving = false;

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text('Edit Course'),
                content: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: codeController,
                          textCapitalization:
                              TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Kode Course',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Kode wajib diisi.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            labelText: 'Nama Course',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Nama wajib diisi.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: creditsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Jumlah SKS',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty) {
                              return 'Jumlah SKS wajib diisi.';
                            }

                            final credits = int.tryParse(
                              value.trim(),
                            );

                            if (credits == null || credits < 0) {
                              return 'Masukkan angka 0 atau lebih.';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Aktif',
                              child: Text('Aktif'),
                            ),
                            DropdownMenuItem(
                              value: 'Nonaktif',
                              child: Text('Nonaktif'),
                            ),
                          ],
                          onChanged: saving
                              ? null
                              : (value) {
                                  if (value == null) return;

                                  setDialogState(() {
                                    status = value;
                                  });
                                },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: saving
                        ? null
                        : () {
                            Navigator.pop(dialogContext);
                          },
                    child: const Text('Batal'),
                  ),
                  FilledButton.icon(
                    onPressed: saving
                        ? null
                        : () async {
                            if (!formKey.currentState!
                                .validate()) {
                              return;
                            }

                            final credits = int.parse(
                              creditsController.text.trim(),
                            );

                            setDialogState(() {
                              saving = true;
                            });

                            if (mounted) {
                              setState(() {
                                _updatingId = course.id;
                              });
                            }

                            try {
                              final updatedCourse = Course(
                                id: course.id,
                                code: codeController.text.trim(),
                                title: titleController.text.trim(),
                                credits: credits,
                                status: status,
                              );

                              await _service.updateCourse(
                                updatedCourse,
                              );

                              if (!mounted) return;

                              Navigator.pop(dialogContext);

                              await _loadCourses();

                              if (!mounted) return;

                              if (_errorMessage == null) {
                                _showMessage(
                                  'Course berhasil diperbarui.',
                                );
                              } else {
                                _showMessage(
                                  'Update berhasil, tetapi daftar '
                                  'gagal dimuat ulang.',
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;

                              setDialogState(() {
                                saving = false;
                              });

                              _showMessage(
                                'Gagal memperbarui course: $e',
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _updatingId = null;
                                });
                              }
                            }
                          },
                    icon: saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      saving ? 'Menyimpan...' : 'Simpan Perubahan',
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      codeController.dispose();
      titleController.dispose();
      creditsController.dispose();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 14 - UPDATE Supabase'),
        actions: [
          IconButton(
            tooltip: 'Refresh data',
            onPressed: _isLoading ? null : _loadCourses,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    stage14StudentName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('NIM: $stage14StudentId'),
                  const Divider(),
                  const Text(
                    'Edit course untuk memperbarui data '
                    'langsung di database Supabase.',
                  ),
                ],
              ),
            ),
            if (_isLoading) const LinearProgressIndicator(),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Gagal memuat data:\n$_errorMessage',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _loadCourses,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _courses.isEmpty
                  ? Center(
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              _errorMessage == null
                                  ? 'Belum ada course di Supabase.'
                                  : 'Data belum dapat ditampilkan.',
                              textAlign: TextAlign.center,
                            ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadCourses,
                      child: ListView.builder(
                        physics:
                            const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
                          final isUpdating =
                              _updatingId == course.id;

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.menu_book),
                              ),
                              title: Text(course.title),
                              subtitle: Text(
                                '${course.code} • '
                                '${course.credits} SKS • '
                                '${course.status}',
                              ),
                              trailing: IconButton(
                                tooltip: 'Edit course',
                                onPressed: _updatingId != null
                                    ? null
                                    : () => _showEditDialog(course),
                                icon: isUpdating
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.edit_outlined,
                                        color: Colors.indigo,
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
