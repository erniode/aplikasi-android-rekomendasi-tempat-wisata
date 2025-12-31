import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';
  final String category;

  const DetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<PlaceProvider>(context).places;
    final items = places
        .where((p) => p.category.toLowerCase() == category.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: Colors.white, // warna dasar putih
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.orange, // warna utama orange
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final p = items[i];

          return Card(
            color: Colors.white, // card tetap putih
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shadowColor: Colors.orange.withOpacity(0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(p.title),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                p.image,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              p.description.isNotEmpty
                                  ? p.description
                                  : 'Deskripsi tidak tersedia.',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Kategori: ${p.category}',
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Koordinat: ${p.lat}, ${p.lng}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Jumlah Kunjungan: ${p.visits}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Tutup'),
                        ),
                      ],
                    );
                  },
                );
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  p.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                p.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                p.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
