
import 'package:flutter/material.dart';

// ======================================================
// MODEL STATE: ChangeNotifier
// ======================================================

class CounterNotifier extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners();
    }
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

// ======================================================
// HALAMAN DEMO
// ======================================================

class Stage5ChangeNotifierPage extends StatefulWidget {
  const Stage5ChangeNotifierPage({super.key});

  @override
  State<Stage5ChangeNotifierPage> createState() =>
      _Stage5ChangeNotifierPageState();
}

class _Stage5ChangeNotifierPageState
    extends State<Stage5ChangeNotifierPage> {
  late final CounterNotifier counterNotifier;

  @override
  void initState() {
    super.initState();
    counterNotifier = CounterNotifier();
  }

  @override
  void dispose() {
    counterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - ChangeNotifier'),
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
              const SizedBox(height: 28),
              const Icon(
                Icons.notifications_active_outlined,
                size: 64,
                color: Colors.indigo,
              ),
              const SizedBox(height: 12),
              const Text(
                'ChangeNotifier Counter',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // UI mendengarkan perubahan dari ChangeNotifier.
              ListenableBuilder(
                listenable: counterNotifier,
                builder: (context, child) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          const Text('Nilai Counter'),
                          const SizedBox(height: 12),
                          Text(
                            '${counterNotifier.count}',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            counterNotifier.count == 0
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
                    onPressed: counterNotifier.decrement,
                    icon: const Icon(Icons.remove),
                    label: const Text('Kurangi'),
                  ),
                  ElevatedButton.icon(
                    onPressed: counterNotifier.increment,
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                  ),
                  OutlinedButton.icon(
                    onPressed: counterNotifier.reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'ChangeNotifier memisahkan state dan logika perubahan '
                'dari tampilan. notifyListeners() memberi tahu widget '
                'yang mendengarkan bahwa state telah berubah.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
