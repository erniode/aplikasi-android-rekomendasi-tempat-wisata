import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';
import '../providers/auth_provider.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final id = ModalRoute.of(context)!.settings.arguments as int? ?? 1;
    final place = Provider.of<PlaceProvider>(
      context,
      listen: false,
    ).findById(id);

    if (place == null) {
      return const Scaffold(
        body: Center(child: Text('Tempat tidak ditemukan')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              place.image,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(place.description),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (!auth.isLoggedIn) {
                        Navigator.of(context).pushNamed('/login');
                        return;
                      }
                      // mark visited
                      Provider.of<PlaceProvider>(
                        context,
                        listen: false,
                      ).markVisited(place.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ditandai sudah dikunjungi'),
                        ),
                      );
                    },
                    child: const Text('Tandai sudah dikunjungi'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
