import 'package:flutter/material.dart';
import 'package:sistem_rekomendasi_wisata_maluku/screens/visited_screen.dart';
import 'package:sistem_rekomendasi_wisata_maluku/screens/category_screen.dart';
import 'home_page_content.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Daftar tabs dideklarasikan di sini
  // Perhatikan: const pada HomePageContent dan ProfileScreen masih bisa digunakan
  // jika mereka benar-benar const, tetapi const pada CategoryScreen dihilangkan.
  final List<Widget> tabs = [
    const HomePageContent(),
    const VisitedScreen(), // Menggunakan const jika widget tidak menerima argumen dinamis
    CategoryScreen(), // Hapus const: Karena widget ini menggunakan Provider
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Tidak perlu mendeklarasikan tabs lagi di dalam build, karena sudah dideklarasikan di atas.
    // Namun, jika kamu ingin mendeklarasikannya di sini agar lebih lokal:
    /*
    final tabs = [
      const HomePageContent(),
      const VisitedScreen(),
      CategoryScreen(), 
      const ProfileScreen(),
    ];
    */

    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() => _currentIndex = i);
        },
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 20), label: 'Beranda'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
              size: 20,
            ),
            label: 'Sudah dikunjungi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.category,
              size: 20,
            ),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 20), label: 'Profil'),
        ],
      ),
    );
  }
}
