import 'package:flutter/material.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 14 - Feedback',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController(text: studentName);

  final TextEditingController nimController =
      TextEditingController(text: studentId);

  final TextEditingController commentController =
      TextEditingController();

  bool isLoading = false;
  String resultMessage = '';

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    commentController.dispose();
    super.dispose();
  }

  // Menampilkan Dialog konfirmasi sebelum aksi penting.
  Future<void> showConfirmationDialog() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
            'Apakah Anda yakin ingin mengirim feedback ini?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Kirim'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      submitFeedback();
    }
  }

  // Menampilkan SnackBar setelah form valid.
  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Data feedback berhasil disimpan.',
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Simulasi proses loading singkat.
  Future<void> submitFeedback() async {
    setState(() {
      isLoading = true;
      resultMessage = '';
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
      resultMessage =
          'Feedback berhasil dikirim oleh ${nameController.text}.';
    });

    // SnackBar ditampilkan setelah proses selesai.
    showSuccessSnackBar();
  }

  void validateAndSubmit() {
    // Jalankan validasi Form terlebih dahulu.
    if (formKey.currentState!.validate()) {
      // Jika valid, tampilkan Dialog konfirmasi.
      showConfirmationDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 14 - Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                'Feedback Course',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              const Text(
                'Isi feedback kemudian kirim setelah validasi.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // =========================
              // FIELD NAMA
              // =========================
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =========================
              // FIELD NIM
              // =========================
              TextFormField(
                controller: nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'NIM wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // =========================
              // FIELD KOMENTAR
              // =========================
              TextFormField(
                controller: commentController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Komentar',
                  hintText: 'Minimal 5 karakter',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.comment),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Komentar wajib diisi';
                  }

                  if (value.trim().length < 5) {
                    return 'Komentar minimal 5 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // =========================
              // TOMBOL KIRIM
              // =========================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : validateAndSubmit,
                  icon: const Icon(Icons.send),
                  label: const Text('Kirim Feedback'),
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // LOADING
              // =========================
              if (isLoading)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text(
                        'Mengirim feedback...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

              // =========================
              // HASIL
              // =========================
              if (resultMessage.isNotEmpty && !isLoading)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            resultMessage,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}