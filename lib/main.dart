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
      title: 'Tahap 3 - LayoutBuilder',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ResponsiveBreakpointPage(),
    );
  }
}

class ResponsiveBreakpointPage extends StatelessWidget {
  const ResponsiveBreakpointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - LayoutBuilder'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return const CompactLayout();
          } else if (constraints.maxWidth < 840) {
            return const MediumLayout();
          } else {
            return const ExpandedLayout();
          }
        },
      ),
    );
  }
}

// ============================================================
// COMPACT LAYOUT
// Lebar < 600
// ============================================================

class CompactLayout extends StatelessWidget {
  const CompactLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.phone_android,
            size: 70,
          ),

          const SizedBox(height: 20),

          const Text(
            'COMPACT',
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
              fontSize: 20,
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

          const SizedBox(height: 20),

          const Text(
            'Layout untuk layar kecil / phone',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// MEDIUM LAYOUT
// Lebar 600 - 839
// ============================================================

class MediumLayout extends StatelessWidget {
  const MediumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.tablet_android,
            size: 80,
          ),

          const SizedBox(height: 20),

          const Text(
            'MEDIUM',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 10),
              Text(
                studentName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            'NIM: $studentId',
            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Layout untuk layar medium / large phone / small tablet',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// EXPANDED LAYOUT
// Lebar >= 840
// ============================================================

class ExpandedLayout extends StatelessWidget {
  const ExpandedLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.desktop_windows,
            size: 100,
          ),

          const SizedBox(width: 40),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'EXPANDED',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                studentName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'NIM: $studentId',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Layout untuk tablet / desktop',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}