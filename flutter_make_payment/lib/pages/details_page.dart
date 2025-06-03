import 'package:flutter/material.dart';
import 'package:flutter_make_payment/models/place.dart';
import 'package:flutter_make_payment/widgets/place_details_widget.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(place.name)), body: PlaceDetailsWidget(place: place));
  }
}
