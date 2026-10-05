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
      title: 'Tahap 4 - Expanded, Flexible, Wrap',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ResponsiveLayoutPage(),
    );
  }
}

class ResponsiveLayoutPage extends StatelessWidget {
  const ResponsiveLayoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4 - Expanded, Flexible, Wrap'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 8),
            const Text(
              'NIM: 2415051045',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),

            // DUA PANEL DENGAN EXPANDED FLEX 2:1
            const Text(
              'Pembagian Panel Expanded 2:1',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 180,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: buildPanel(
                      title: 'Panel A',
                      description: 'Flex 2',
                      icon: Icons.dashboard,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: buildPanel(
                      title: 'Panel B',
                      description: 'Flex 1',
                      icon: Icons.widgets,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // SKILL CHIPS DENGAN WRAP
            const Text(
              'Skills',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                Chip(
                  avatar: Icon(Icons.code),
                  label: Text('Dart'),
                ),
                Chip(
                  avatar: Icon(Icons.phone_android),
                  label: Text('Flutter'),
                ),
                Chip(
                  avatar: Icon(Icons.web),
                  label: Text('Responsive UI'),
                ),
                Chip(
                  avatar: Icon(Icons.storage),
                  label: Text('JSON'),
                ),
                Chip(
                  avatar: Icon(Icons.navigation),
                  label: Text('Navigation'),
                ),
                Chip(
                  avatar: Icon(Icons.design_services),
                  label: Text('UI Design'),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Keterangan:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            const Text(
              'Expanded membagi ruang berdasarkan nilai flex. '
              'Panel A menggunakan flex 2 sehingga mendapatkan '
              'ruang dua kali lebih besar dibanding Panel B yang '
              'menggunakan flex 1.',
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 12),

            const Text(
              'Wrap membuat Chip berpindah ke baris berikutnya '
              'ketika ruang horizontal tidak mencukupi.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPanel({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}