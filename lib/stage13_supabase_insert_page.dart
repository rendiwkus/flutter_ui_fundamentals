
import 'package:flutter/material.dart';

import 'services/course_service.dart';

class Stage13SupabaseInsertPage extends StatefulWidget {
  const Stage13SupabaseInsertPage({super.key});

  @override
  State<Stage13SupabaseInsertPage> createState() =>
      _Stage13SupabaseInsertPageState();
}

class _Stage13SupabaseInsertPageState
    extends State<Stage13SupabaseInsertPage> {
  final CourseService service = CourseService();

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _titleController = TextEditingController();
  final _creditsController = TextEditingController();

  String _status = 'Aktif';
  bool _isSaving = false;

  @override
  void dispose() {
    _codeController.dispose();
    _titleController.dispose();
    _creditsController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final credits = int.tryParse(
      _creditsController.text.trim(),
    );

    if (credits == null || credits <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah SKS harus berupa angka positif.'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await service.createCourse(
        code: _codeController.text.trim(),
        title: _titleController.text.trim(),
        credits: credits,
        status: _status,
      );

      if (!mounted) return;

      _formKey.currentState!.reset();
      _codeController.clear();
      _titleController.clear();
      _creditsController.clear();

      setState(() {
        _status = 'Aktif';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Course berhasil ditambahkan ke Supabase.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan course: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 13 - Supabase Insert'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.cloud_upload_outlined,
                  size: 64,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tambah Mata Kuliah',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Isi data berikut untuk menyimpan '
                  'course baru ke database Supabase.',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Kode Course',
                    hintText: 'Contoh: PM201',
                    prefixIcon: Icon(Icons.tag),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Kode course wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Mata Kuliah',
                    hintText: 'Contoh: Pemrograman Mobile Lanjut',
                    prefixIcon: Icon(Icons.menu_book),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama mata kuliah wajib diisi.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _creditsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah SKS',
                    hintText: 'Contoh: 3',
                    prefixIcon: Icon(Icons.credit_score),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final credits = int.tryParse(
                      value?.trim() ?? '',
                    );

                    if (credits == null || credits <= 0) {
                      return 'Masukkan jumlah SKS berupa angka positif.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    labelText: 'Status Course',
                    prefixIcon: Icon(Icons.check_circle_outline),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Aktif',
                      child: Text('Aktif'),
                    ),
                    DropdownMenuItem(
                      value: 'Tidak Aktif',
                      child: Text('Tidak Aktif'),
                    ),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() {
                              _status = value;
                            });
                          }
                        },
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveCourse,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isSaving
                          ? 'Menyimpan...'
                          : 'Simpan Course',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
