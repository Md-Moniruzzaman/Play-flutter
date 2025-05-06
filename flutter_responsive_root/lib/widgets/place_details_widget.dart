import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/models/place.dart';

class PlaceDetailsWidget extends StatelessWidget {
  PlaceDetailsWidget({super.key, required this.place});
  final Place place;
  final Color? color = Colors.teal[700];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.network(place.imageUrl, height: 250, fit: BoxFit.cover),
        buildTitle(place.name),
        builButtons(color),
        buildDescription(place.description),
      ],
    );
  }

  Widget buildTitle(String title) => Container(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(place.location ?? '', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        Icon(Icons.star, color: Colors.yellow[700], size: 30),
        const SizedBox(width: 8),
        Text('41', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget builButtons(Color? color) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    mainAxisSize: MainAxisSize.max,
    children: [
      builButton(color, Icons.call, "CALL"),
      builButton(color, Icons.near_me, "ROUTE"),
      builButton(color, Icons.share, "SHARE"),
    ],
  );

  Widget builButton([Color? color, IconData? icon, String? level]) => Container(
    margin: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(level ?? '', style: TextStyle(fontSize: 16, color: color)),
      ],
    ),
  );

  Widget buildDescription(String description) =>
      Padding(padding: const EdgeInsets.all(16.0), child: Text(description, style: const TextStyle(fontSize: 16)));
}
