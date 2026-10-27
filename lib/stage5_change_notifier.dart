
import 'package:flutter/material.dart';

const String studentName = 'Rendi Wija Kusuma';
const String studentId = '2415051045';

class Stage5ChangeNotifierPage extends StatefulWidget {
  const Stage5ChangeNotifierPage({super.key});

  @override
  State<Stage5ChangeNotifierPage> createState() =>
      _Stage5ChangeNotifierPageState();
}

class _Stage5ChangeNotifierPageState
    extends State<Stage5ChangeNotifierPage> {
  late final CourseCounterNotifier counter;

  @override
  void initState() {
    super.initState();
    counter = CourseCounterNotifier();
  }

  @override
  void dispose() {
    counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5 - ChangeNotifier'),
      ),
      body: AnimatedBuilder(
        animation: counter,
        builder: (context, child) {
          return Padding(
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
                const Icon(
                  Icons.school,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Jumlah Course Dipilih',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  '${counter.selectedCount}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: counter.decrease,
                      icon: const Icon(Icons.remove),
                      label: const Text('Kurangi'),
                    ),
                    ElevatedButton.icon(
                      onPressed: counter.increase,
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah'),
                    ),
                    OutlinedButton.icon(
                      onPressed: counter.reset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  counter.selectedCount == 0
                      ? 'Belum ada course dipilih.'
                      : 'Ada ${counter.selectedCount} course dipilih.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CourseCounterNotifier extends ChangeNotifier {
  int _selectedCount = 0;

  int get selectedCount => _selectedCount;

  void increase() {
    _selectedCount++;
    notifyListeners();
  }

  void decrease() {
    if (_selectedCount > 0) {
      _selectedCount--;
      notifyListeners();
    }
  }

  void reset() {
    _selectedCount = 0;
    notifyListeners();
  }
}
