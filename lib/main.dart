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
      title: 'Tahap 7 - Navigation',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// ===============================
// HOME PAGE
// ===============================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.home,
                size: 80,
              ),
              const SizedBox(height: 24),

              const Text(
                studentName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'NIM: 2415051045',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Ini adalah halaman utama.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 24),

              // TOMBOL MEMBUKA DETAIL
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Buka Detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================
// DETAIL PAGE
// ===============================

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                size: 80,
              ),

              const SizedBox(height: 24),

              const Text(
                'Halaman Detail',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                studentName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'NIM: 2415051045',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 30),

              // TOMBOL KEMBALI MENGGUNAKAN NAVIGATOR.POP
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}