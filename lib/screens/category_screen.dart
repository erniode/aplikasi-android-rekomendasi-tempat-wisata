import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final places = Provider.of<PlaceProvider>(context).places;
    final categories = ['Dataran tinggi', 'Pantai', 'Sering dikunjungi'];

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: ListView(
        children: categories.map((cat) {
          final items = places
              .where((p) => p.category.toLowerCase() == cat.toLowerCase())
              .toList();

          return ExpansionTile(
            title: Text(cat),
            children: items.map((p) {
              return ListTile(
                leading: Image.asset(p.image, width: 64, fit: BoxFit.cover),
                title: Text(p.title),
                subtitle: Text(
                  p.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
