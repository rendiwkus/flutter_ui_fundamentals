
import 'package:flutter/material.dart';

import 'models/course.dart';
import 'services/course_supabase_service.dart';

class Stage13SupabaseInsertPage extends StatefulWidget {
  const Stage13SupabaseInsertPage({super.key});

  @override
  State<Stage13SupabaseInsertPage> createState() =>
      _Stage13SupabaseInsertPageState();
}

class _Stage13SupabaseInsertPageState
    extends State<Stage13SupabaseInsertPage> {
  final SupabaseCourseService _service = SupabaseCourseService();

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  List<Course> _courses = [];

  String _status = 'Aktif';
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  // Mengambil data dari Supabase, bukan dari file JSON.
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

  // Menyimpan data baru ke Supabase.
  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    final credits = int.tryParse(
      _creditsController.text.trim(),
    );

    if (credits == null || credits < 0) {
      _showMessage('Jumlah SKS harus berupa angka 0 atau lebih.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _service.createCourse(
        code: _codeController.text.trim(),
        title: _titleController.text.trim(),
        credits: credits,
        status: _status,
      );

      if (!mounted) return;

      _codeController.clear();
      _titleController.clear();
      _creditsController.clear();

      setState(() {
        _status = 'Aktif';
      });

      // Membaca ulang data setelah insert berhasil.
      await _loadCourses();

      if (!mounted) return;

      if (_errorMessage == null) {
        _showMessage('Course berhasil disimpan ke Supabase.');
      } else {
        _showMessage(
          'Course tersimpan, tetapi daftar gagal dimuat ulang.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage('Gagal menyimpan course: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  String? _validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi.';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 13 - Supabase Insert'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang data Supabase',
            onPressed: _isLoading ? null : _loadCourses,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tambah Mata Kuliah',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _codeController,
                        textCapitalization:
                            TextCapitalization.characters,
                        decoration: const InputDecoration(
                          labelText: 'Kode Mata Kuliah',
                          hintText: 'Contoh: PM101',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final error = _validateRequired(
                            value,
                            'Kode mata kuliah',
                          );

                          if (error != null) return error;

                          if (value!.trim().length > 30) {
                            return 'Kode maksimal 30 karakter.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Mata Kuliah',
                          hintText: 'Contoh: Pemrograman Mobile',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final error = _validateRequired(
                            value,
                            'Nama mata kuliah',
                          );

                          if (error != null) return error;

                          if (value!.trim().length > 150) {
                            return 'Nama maksimal 150 karakter.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _creditsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah SKS',
                          hintText: 'Contoh: 3',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final error = _validateRequired(
                            value,
                            'Jumlah SKS',
                          );

                          if (error != null) return error;

                          final number = int.tryParse(value!.trim());

                          if (number == null || number < 0) {
                            return 'Masukkan angka 0 atau lebih.';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        initialValue: _status,
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
                        onChanged: _isSaving
                            ? null
                            : (value) {
                                if (value == null) return;

                                setState(() {
                                  _status = value;
                                });
                              },
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isSaving ? null : _createCourse,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.cloud_upload_outlined),
                          label: Text(
                            _isSaving
                                ? 'Menyimpan...'
                                : 'Simpan ke Supabase',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Data dari Supabase',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text('${_courses.length} course'),
              ],
            ),
            const SizedBox(height: 12),

            if (_isLoading && _courses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),

            if (_errorMessage != null) ...[
              Text(
                'Gagal membaca data Supabase:\n$_errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _loadCourses,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],

            if (!_isLoading &&
                _errorMessage == null &&
                _courses.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Belum ada course di tabel Supabase. '
                  'Tambahkan data menggunakan formulir di atas.',
                  textAlign: TextAlign.center,
                ),
              ),

            ..._courses.map(
              (course) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.menu_book),
                  ),
                  title: Text(course.title),
                  subtitle: Text(
                    '${course.code} • ${course.credits} SKS • '
                    '${course.status}',
                  ),
                  trailing: const Icon(
                    Icons.cloud_done_outlined,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
