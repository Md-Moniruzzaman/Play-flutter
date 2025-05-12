import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/data/places.dart';
import 'package:flutter_responsive_root/models/place.dart';
import 'package:flutter_responsive_root/widgets/drawer_widget.dart';
import 'package:flutter_responsive_root/widgets/place_details_widget.dart';
import 'package:flutter_responsive_root/widgets/place_gallery_widget.dart';
import 'package:flutter_responsive_root/widgets/responsive_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Place selectedPlace = allPlaces[0];

  void changePlace(Place place) => setState(() => selectedPlace = place);

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveWidget.isMobile(context);
    return Scaffold(
      appBar: AppBar(title: Text('Tour App')),
      drawer: isMobile ? Drawer(child: DrawerWidget()) : null,
      body: ResponsiveWidget(mobile: buildMobile(), tablet: buildTablet(), desktop: buildDesktop()),
    );
  }

  Widget buildMobile() => PlaceGalleryWidget(onPlaceChanged: (value) {});

  Widget buildTablet() => Row(
    children: [
      Expanded(flex: 2, child: DrawerWidget()),
      Expanded(flex: 5, child: PlaceGalleryWidget(onPlaceChanged: (value) {})),
    ],
  );

  Widget buildDesktop() => Row(children: [Expanded(child: DrawerWidget()), Expanded(flex: 3, child: buildBody())]);

  Widget buildBody() => SingleChildScrollView(
    child: Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(child: PlaceGalleryWidget(onPlaceChanged: (place) => changePlace(place), isHorizontal: true)),
          Expanded(flex: 2, child: PlaceDetailsWidget(place: selectedPlace)),
        ],
      ),
    ),
  );
}
