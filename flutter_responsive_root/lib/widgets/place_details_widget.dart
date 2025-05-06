import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/models/place.dart';

class PlaceDetailsWidget extends StatelessWidget {
  PlaceDetailsWidget({super.key, required this.place});
  final Place place;
  final Color? color = Colors.teal[700];

  @override
  Widget build(BuildContext context) {
    final double fontSize = MediaQuery.of(context).size.width * 0.025;
    return ListView(
      children: [
        Image.network(place.imageUrl, height: 250, fit: BoxFit.cover),
        buildTitle(place.name, fontSize),
        builButtons(color, fontSize),
        buildDescription(place.description, fontSize),
      ],
    );
  }

  Widget buildTitle(String title, double fontSize) => Container(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                title,
                minFontSize: 16,
                maxFontSize: 24,
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              AutoSizeText(
                place.location ?? '',
                minFontSize: 14,
                maxFontSize: 18,
                style: TextStyle(color: Colors.grey, fontSize: fontSize),
              ),
            ],
          ),
        ),
        Icon(Icons.star, color: Colors.yellow[700], size: 30),
        const SizedBox(width: 8),
        AutoSizeText(
          '41',
          minFontSize: 20,
          maxFontSize: 28,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget builButtons(Color? color, double fontSize) => Row(
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

  Widget buildDescription(String description, double fontSize) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: AutoSizeText(description, minFontSize: 16, maxFontSize: 24, style: TextStyle(fontSize: fontSize)),
  );
}
