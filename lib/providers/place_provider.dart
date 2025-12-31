import 'package:flutter/foundation.dart';
import '../models/place.dart';
import '../data/dummy_place.dart';

class PlaceProvider with ChangeNotifier {
  List<Place> _places = List.from(dummyPlaces);
  final List<Place> _favorites = [];
  final List<Place> _visited = [];

  List<Place> get places => _places;
  List<Place> get favorites => _favorites;
  List<Place> get visited => _visited;

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

  bool isFavorite(Place place) => _favorites.any((p) => p.id == place.id);

  void toggleFavorite(Place place) {
    if (isFavorite(place)) {
      _favorites.removeWhere((p) => p.id == place.id);
    } else {
      _favorites.add(place);
    }
    notifyListeners();
  }

  bool isVisited(Place place) => _visited.any((p) => p.id == place.id);

  void markAsVisited(Place place) {
    if (!isVisited(place)) {
      _visited.add(place);
      notifyListeners();
    }
  }
}
