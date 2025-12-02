import 'package:flutter/foundation.dart';
import '../models/place.dart';

class PlaceProvider extends ChangeNotifier {
  List<Place> _places = dummyPlaces;

  List<Place> get places => _places;

  Place? findById(int id) {
    try {
      return _places.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  void markVisited(int id) {
    final idx = _places.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _places[idx] = Place(
        id: _places[idx].id,
        title: _places[idx].title,
        description: _places[idx].description,
        image: _places[idx].image,
        lat: _places[idx].lat,
        lng: _places[idx].lng,
        category: _places[idx].category,
        visits: _places[idx].visits + 1,
      );

      notifyListeners();
    }
  }
}

List<Place> dummyPlaces = [
  Place(
    id: 1,
    title: "Pantai Natsepa",
    description: "Pantai berpasir putih dekat Ambon dengan pemandangan indah",
    image: "assets/images/natsepa.jpeg",
    lat: -3.686,
    lng: 128.282,
    category: "pantai",
    visits: 100,
  ),
  Place(
    id: 2,
    title: "Bukit Paralayang Airlouw",
    description: "Tempat lihat sunset yang indah",
    image: "assets/images/paralayang.jpg",
    lat: -3.686,
    lng: 128.282,
    category: "Dataran tinggi",
    visits: 100,
  ),
];
