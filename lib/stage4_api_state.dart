
import 'package:flutter/material.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

class Stage4ValueNotifierPage extends StatefulWidget {
  const Stage4ValueNotifierPage({super.key});

  @override
  State<Stage4ValueNotifierPage> createState() =>
      _Stage4ValueNotifierPageState();
}

class _Stage4ValueNotifierPageState
    extends State<Stage4ValueNotifierPage> {
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  void _increment() {
    _counter.value++;
  }

  void _decrement() {
    _counter.value--;
  }

  void _reset() {
    _counter.value = 0;
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - ValueNotifier'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              studentName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            const Text('NIM: $studentId'),
            const SizedBox(height: 32),
            const Text(
              'Contoh State dengan ValueNotifier',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<int>(
              valueListenable: _counter,
              builder: (context, value, child) {
                return Column(
                  children: [
                    const Icon(
                      Icons.touch_app,
                      size: 56,
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
                          ? 'Nilai masih nol'
                          : value > 0
                              ? 'Nilai positif'
                              : 'Nilai negatif',
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  label: const Text('Kurangi'),
                ),
                ElevatedButton.icon(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
                OutlinedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'ValueNotifier menyimpan nilai yang dapat berubah. '
              'ValueListenableBuilder membangun ulang bagian UI '
              'yang mendengarkan perubahan nilai tersebut.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
