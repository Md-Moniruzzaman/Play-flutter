class Place {
  final String name;
  final String description;
  final String imageUrl;
  final String? location; // Optional location field

  Place({
    required this.name,
    required this.description,
    required this.imageUrl,
    this.location,
  });
  
}