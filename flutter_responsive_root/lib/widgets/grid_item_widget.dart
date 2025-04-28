import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/models/place.dart';

class GridItemWidget extends StatelessWidget {
  final Place place;
  const GridItemWidget({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(clipBehavior: Clip.antiAlias,elevation: 6,);
  }
}
