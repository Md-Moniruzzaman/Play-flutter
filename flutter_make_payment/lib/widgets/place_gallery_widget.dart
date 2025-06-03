import 'package:flutter/material.dart';
import 'package:flutter_make_payment/data/places.dart';
import 'package:flutter_make_payment/models/place.dart';
import 'package:flutter_make_payment/widgets/grid_item_widget.dart';

class PlaceGalleryWidget extends StatelessWidget {
  const PlaceGalleryWidget({super.key, required this.onPlaceChanged, this.isHorizontal = false});
  final ValueChanged<Place> onPlaceChanged;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: GridView.count(
        crossAxisCount: isHorizontal ? 1 : 2,
        scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical,
        physics: const BouncingScrollPhysics(),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children:
            allPlaces
                .map<Widget>((place) => GridItemWidget(place: place, onChangePlace: (place) => onPlaceChanged(place)))
                .toList(),
      ),
    );
  }
}
