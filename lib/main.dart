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
      title: 'Tahap 6 - Scrollable Content',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ProfileFormPage(),
    );
  }
}

class ProfileFormPage extends StatelessWidget {
  const ProfileFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6 - Scrollable Content'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IDENTITAS MAHASISWA
            const Text(
              studentName,
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
              'Form Profil Mahasiswa',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // NAMA
            const Text(
              'Nama Lengkap',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan nama lengkap',
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            // NIM
            const Text(
              'NIM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan NIM',
                prefixIcon: Icon(Icons.badge),
              ),
            ),

            const SizedBox(height: 20),

            // EMAIL
            const Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan email',
                prefixIcon: Icon(Icons.email),
              ),
            ),

            const SizedBox(height: 20),

            // ALAMAT
            const Text(
              'Alamat',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan alamat',
                prefixIcon: Icon(Icons.home),
              ),
            ),

            const SizedBox(height: 20),

            // PROGRAM STUDI
            const Text(
              'Program Studi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan program studi',
                prefixIcon: Icon(Icons.school),
              ),
            ),

            const SizedBox(height: 20),

            // SEMESTER
            const Text(
              'Semester',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan semester',
                prefixIcon: Icon(Icons.calendar_month),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save),
                label: const Text('Simpan Profil'),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Catatan: Halaman ini menggunakan '
              'SingleChildScrollView agar seluruh form '
              'tetap dapat diakses ketika tinggi konten '
              'melebihi tinggi layar.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),

            // JARAK TAMBAHAN AGAR KONTEN LEBIH TINGGI DARI LAYAR
            const SizedBox(height: 300),
          ],
        ),
      ),
    );
  }
}