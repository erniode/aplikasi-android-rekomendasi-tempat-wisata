class Place {
  final int id;
  final String title;
  final String description;
  final String image; // asset path
  final double lat;
  final double lng;
  final String category;
  final int visits;
  final String openingHours;
  final String bestMonth;

  Place({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.lat,
    required this.lng,
    required this.category,
    required this.visits,
    required this.openingHours,
    required this.bestMonth,
  });
}
