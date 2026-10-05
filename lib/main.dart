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
      title: 'Tahap 2 - MediaQuery',
      home: const MediaQueryPage(),
    );
  }
}

class MediaQueryPage extends StatelessWidget {
  const MediaQueryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil ukuran layar
    final size = MediaQuery.of(context).size;

    // Mengambil orientasi layar
    final orientation = MediaQuery.of(context).orientation;

    // Menentukan apakah layar Compact atau Wide
    final screenType = size.width < 600 ? 'Compact' : 'Wide';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - MediaQuery'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                studentName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'NIM: $studentId',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'Width: ${size.width.toStringAsFixed(0)} px',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Height: ${size.height.toStringAsFixed(0)} px',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Orientation: $orientation',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                screenType,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}