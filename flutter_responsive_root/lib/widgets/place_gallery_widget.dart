import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/data/places.dart';
import 'package:flutter_responsive_root/widgets/grid_item_widget.dart';

class PlaceGalleryWidget extends StatelessWidget {
  const PlaceGalleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        children: allPlaces.map<Widget>((place) => GridItemWidget(place: place)).toList(),
      ),
    );
  }
}
