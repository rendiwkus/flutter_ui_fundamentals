
import 'package:flutter/material.dart';

class Stage2DemoPage extends StatefulWidget {
  const Stage2DemoPage({super.key});

  @override
  State<Stage2DemoPage> createState() => _Stage2DemoPageState();
}

class _Stage2DemoPageState extends State<Stage2DemoPage> {
  // Parent menjadi pemilik state.
  bool isFavorite = false;

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2 - Prop Drilling'),
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
            'Satu State, Dua Child',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kedua child menerima status favorite dan callback '
            'dari parent melalui constructor.',
          ),
          const SizedBox(height: 16),

          FavoriteChild(
            title: 'Child A - Course Card',
            isFavorite: isFavorite,
            onToggle: toggleFavorite,
          ),

          const SizedBox(height: 12),

          FavoriteChild(
            title: 'Child B - Course Detail',
            isFavorite: isFavorite,
            onToggle: toggleFavorite,
          ),

          const SizedBox(height: 20),

          Card(
            color: isFavorite
                ? Colors.pink.shade50
                : Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'State pada parent: '
                '${isFavorite ? "Favorite" : "Bukan Favorite"}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'Tekan tombol pada Child A atau Child B. '
            'Keduanya berubah karena menggunakan state yang sama.',
          ),
        ],
      ),
    );
  }
}

class FavoriteChild extends StatelessWidget {
  final String title;
  final bool isFavorite;
  final VoidCallback onToggle;

  const FavoriteChild({
    super.key,
    required this.title,
    required this.isFavorite,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          isFavorite ? 'Sudah favorite' : 'Belum favorite',
        ),
        leading: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.pink : Colors.grey,
        ),
        trailing: IconButton(
          tooltip: 'Ubah favorite',
          onPressed: onToggle,
          icon: const Icon(Icons.swap_horiz),
        ),
      ),
    );
  }
}
