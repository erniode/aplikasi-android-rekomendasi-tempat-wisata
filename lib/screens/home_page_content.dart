import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/place_provider.dart';
import '../providers/auth_provider.dart';
import 'detail_screen.dart';
import 'login_screen.dart';

class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final placeProv = Provider.of<PlaceProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final mostVisited = placeProv.places
      ..sort((a, b) => b.visits.compareTo(a.visits));
    final popular = mostVisited.take(5).toList();
    final nearby = placeProv.places.take(4).toList();

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Rekomendasi populer',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            if (popular.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                ),
                items: popular.map((p) {
                  return Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          if (!auth.isLoggedIn) {
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                            return;
                          }
                          Navigator.of(context).pushNamed(
                              DetailScreen.routeName,
                              arguments: p.id);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(p.image, fit: BoxFit.cover),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color.fromARGB(137, 231, 51, 51),
                                        const Color.fromARGB(0, 255, 10, 10),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Text(
                                    p.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              )
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Belum ada data rekomendasi.'),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Wisata dekat pusat kota',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            ...nearby.map(
              (p) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        p.image,
                        width: 72,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(p.title),
                    subtitle: Text(
                      p.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        if (!auth.isLoggedIn) {
                          Navigator.of(context)
                              .pushNamed(LoginScreen.routeName);
                          return;
                        }
                        Navigator.of(context)
                            .pushNamed(DetailScreen.routeName, arguments: p.id);
                      },
                      child: const Text('Lihat detailnya'),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
