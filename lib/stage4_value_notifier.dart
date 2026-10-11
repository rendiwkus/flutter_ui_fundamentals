
import 'package:flutter/material.dart';

class Stage4ValueNotifierPage extends StatefulWidget {
  const Stage4ValueNotifierPage({super.key});

  @override
  State<Stage4ValueNotifierPage> createState() =>
      _Stage4ValueNotifierPageState();
}

class _Stage4ValueNotifierPageState
    extends State<Stage4ValueNotifierPage> {
  // ValueNotifier menyimpan nilai dan memberi tahu listener
  // ketika nilainya berubah.
  final ValueNotifier<int> counter = ValueNotifier<int>(0);

  void incrementCounter() {
    counter.value++;
  }

  void decrementCounter() {
    if (counter.value > 0) {
      counter.value--;
    }
  }

  void resetCounter() {
    counter.value = 0;
  }

  @override
  void dispose() {
    // Bersihkan ValueNotifier saat halaman ditutup.
    counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - ValueNotifier'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Rendi Wija Kusuma',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text('NIM: 2415051045'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Icon(
                Icons.notifications_active_outlined,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'ValueNotifier Counter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Widget ini mendengarkan perubahan counter.value.
              ValueListenableBuilder<int>(
                valueListenable: counter,
                builder: (context, value, child) {
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          const Text(
                            'Nilai Counter',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '$value',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            value == 0
                                ? 'Belum ada perubahan'
                                : 'Nilai berhasil diperbarui',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: decrementCounter,
                    icon: const Icon(Icons.remove),
                    label: const Text('Kurangi'),
                  ),
                  ElevatedButton.icon(
                    onPressed: incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
                  OutlinedButton.icon(
                    onPressed: resetCounter,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Perubahan nilai ValueNotifier akan memperbarui '
                'widget yang mendengarkannya tanpa perlu '
                'memanggil setState() untuk counter.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
