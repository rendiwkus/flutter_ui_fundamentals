import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(
    'assets/data/student_data.json',
  );

  return jsonDecode(jsonString) as Map<String, dynamic>;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Future untuk mengambil data JSON
  late Future<Map<String, dynamic>> studentFuture;

  // Controller untuk input
  final TextEditingController nameController =
      TextEditingController();

  String greeting = 'Belum ada pesan';

  @override
  void initState() {
    super.initState();

    // Future hanya dipanggil satu kali
    studentFuture = loadStudentData();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // ==========================================================
  // REUSABLE WIDGET 1
  // SUMMARY CARD
  // ==========================================================

  Widget buildSummaryCard({
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F9FD),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: const Color(0xFFD5E1EC),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF607080),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // REUSABLE WIDGET 2
  // COURSE CARD
  // ==========================================================

  Widget buildCourseCard(
    Map<String, dynamic> course,
  ) {
    final String code = course['code'] as String;
    final String title = course['title'] as String;
    final int credits = course['credits'] as int;
    final String status = course['status'] as String;

    String statusText;
    Color statusColor;

    if (status == 'done') {
      statusText = 'Selesai';
      statusColor = Colors.green;
    } else if (status == 'active') {
      statusText = 'Berjalan';
      statusColor = Colors.orange;
    } else {
      statusText = 'Direncanakan';
      statusColor = Colors.grey;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: const Color(0xFFD5DEE8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul materi
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF263238),
            ),
          ),

          const SizedBox(height: 5),

          // Kode dan SKS
          Text(
            '$code • $credits SKS',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF607080),
            ),
          ),

          const SizedBox(height: 5),

          // Status conditional
          Text(
            statusText,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // INPUT & STATE
  // ==========================================================

  void showGreeting() {
    setState(() {
      if (nameController.text.trim().isEmpty) {
        greeting = 'Input masih kosong';
      } else {
        greeting =
            'Halo, ${nameController.text.trim()}!';
      }
    });
  }

  // ==========================================================
  // KASUS A - RENDERFLEX OVERFLOW
  // ==========================================================
  //
  // PERBAIKAN:
  // Text dibungkus Expanded agar tidak keluar
  // dari lebar Row.
  //

  Widget buildSafeLongTextRow(
    String nim,
    String name,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          size: 18,
          color: Color(0xFF1565C0),
        ),

        const SizedBox(width: 8),

        // Expanded mencegah RenderFlex Overflow
        Expanded(
          child: Text(
            '$nim - $name - Ini adalah teks panjang untuk menguji layout Flutter.',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF607080),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Learning Dashboard',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ======================================================
      // FUTURE BUILDER
      // ======================================================

      body: FutureBuilder<Map<String, dynamic>>(
        future: studentFuture,

        builder: (context, snapshot) {
          // ==================================================
          // LOADING STATE
          // ==================================================

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ==================================================
          // ERROR STATE
          // ==================================================

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Gagal memuat data JSON',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ==================================================
          // DATA JSON
          // ==================================================

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Data tidak tersedia',
              ),
            );
          }

          final data = snapshot.data!;

          final student =
              data['student'] as Map<String, dynamic>;

          final courses =
              data['courses'] as List<dynamic>;

          // Data mahasiswa
          final String nim =
              student['nim'] as String;

          final String name =
              student['name'] as String;

          final String major =
              student['major'] as String;

          // Jumlah topik
          final int totalCourses =
              courses.length;

          // Jumlah materi selesai
          final int completedCourses =
              courses.where((course) {
            final item =
                course as Map<String, dynamic>;

            return item['status'] == 'done';
          }).length;

          // Progress
          final int progress =
              totalCourses == 0
                  ? 0
                  : ((completedCourses /
                              totalCourses) *
                          100)
                      .round();

          // ==================================================
          // CONTENT
          // ==================================================

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                28,
                12,
                28,
                20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  // ==========================================
                  // IDENTITY CARD
                  // ==========================================

                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F7FC),
                      borderRadius:
                          BorderRadius.circular(9),
                      border: Border.all(
                        color: const Color(0xFFBBD6EC),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NIM: $nim',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          'Nama: $name',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF263238),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          major,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF607080),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ==========================================
                  // PROFILE
                  // ==========================================

                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 29,
                        backgroundColor:
                            Color(0xFFD9E2E8),
                        backgroundImage: AssetImage(
                          'assets/images/profile.jpg',
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Flutter UI Fundamentals',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    Color(0xFF263238),
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              'Pertemuan 4',
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                    Color(0xFF607080),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // SUMMARY
                  // ==========================================

                  Row(
                    children: [
                      buildSummaryCard(
                        label: 'Topik',
                        value: '$totalCourses',
                      ),

                      buildSummaryCard(
                        label: 'Progress',
                        value: '$progress%',
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ==========================================
                  // DAFTAR MATERI
                  // ==========================================

                  const Text(
                    'Daftar Materi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),

                  const SizedBox(height: 9),

                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course =
                          courses[index]
                              as Map<String, dynamic>;

                      return buildCourseCard(
                        course,
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // ==========================================
                  // INPUT & STATE
                  // ==========================================

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText:
                          'Nama untuk Greeting',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(9),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: showGreeting,
                      child: const Text(
                        'Tampilkan Greeting',
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==========================================
                  // DEBUGGING - KASUS A
                  // ==========================================

                  const Text(
                    'Debugging Check',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  ),

                  const SizedBox(height: 7),

                  buildSafeLongTextRow(
                    nim,
                    name,
                  ),

                  const SizedBox(height: 12),

                  // ==========================================
                  // KETERANGAN
                  // ==========================================

                  const Text(
                    'Data list dimuat dari JSON statik',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF607080),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}