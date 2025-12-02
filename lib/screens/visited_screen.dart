import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';

class VisitedScreen extends StatelessWidget {
  const VisitedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<PlaceProvider>(
      context,
    ).places.where((p) => p.visits > 0).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Sudah dikunjungi')),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (ctx, i) {
          final p = places[i];
          return ListTile(
            leading: Image.asset(p.image, width: 64, fit: BoxFit.cover),
            title: Text(p.title),
            subtitle: Text('Telah dikunjungi ${p.visits} kali'),
          );
        },
      ),
    );
  }
}
