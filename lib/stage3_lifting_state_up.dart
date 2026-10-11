
import 'package:flutter/material.dart';

class Stage3DemoPage extends StatefulWidget {
  const Stage3DemoPage({super.key});

  @override
  State<Stage3DemoPage> createState() => _Stage3DemoPageState();
}

class _Stage3DemoPageState extends State<Stage3DemoPage> {
  // Parent menjadi satu-satunya pemilik state.
  bool isFavorite = false;

  // Callback untuk mengubah state dari child.
  void handleFavoriteChanged() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3 - Lifting State Up'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 20),
          const Text(
            'Single Source of Truth',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'State favorite disimpan oleh parent. '
            'Kedua child menggunakan nilai yang sama.',
          ),
          const SizedBox(height: 16),

          // Child pertama: menerima nilai dan callback.
          CourseFavoriteCard(
            isFavorite: isFavorite,
            onFavoriteChanged: handleFavoriteChanged,
          ),

          const SizedBox(height: 12),

          // Child kedua: membaca nilai state yang sama.
          FavoriteStatusPanel(
            isFavorite: isFavorite,
          ),

          const SizedBox(height: 20),
          Card(
            color: isFavorite
                ? Colors.green.shade50
                : Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'State Parent: '
                '${isFavorite ? "Favorite" : "Bukan Favorite"}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseFavoriteCard extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseFavoriteCard({
    super.key,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.school),
        title: const Text('Course Card'),
        subtitle: Text(
          isFavorite
              ? 'Tersimpan di favorite'
              : 'Belum disimpan',
        ),
        trailing: IconButton(
          tooltip: 'Ubah favorite',
          onPressed: onFavoriteChanged,
          icon: Icon(
            isFavorite
                ? Icons.favorite
                : Icons.favorite_border,
            color: isFavorite ? Colors.pink : Colors.grey,
          ),
        ),
      ),
    );
  }
}

class FavoriteStatusPanel extends StatelessWidget {
  final bool isFavorite;

  const FavoriteStatusPanel({
    super.key,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          isFavorite
              ? Icons.check_circle
              : Icons.info_outline,
          color: isFavorite ? Colors.green : Colors.grey,
        ),
        title: const Text('Favorite Status Panel'),
        subtitle: Text(
          isFavorite
              ? 'Course adalah favorite'
              : 'Course bukan favorite',
        ),
      ),
    );
  }
}
