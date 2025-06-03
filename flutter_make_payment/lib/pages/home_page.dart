import 'package:flutter/material.dart';
import 'package:flutter_make_payment/data/places.dart';
import 'package:flutter_make_payment/models/place.dart';
import 'package:flutter_make_payment/pages/make_payment_page.dart';
import 'package:flutter_make_payment/widgets/drawer_widget.dart';
import 'package:flutter_make_payment/widgets/responsive_widget.dart';

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
    final bool isTablet = ResponsiveWidget.isTablet(context);
    return Scaffold(
      appBar: !isMobile && !isTablet ? AppBar(title: Text('Tour App')) : null,
      drawer: isMobile ? Drawer(child: DrawerWidget()) : null,
      body: ResponsiveWidget(mobile: buildMobile(), tablet: buildTablet(), desktop: buildDesktop()),
    );
  }

  Widget buildMobile() => MakePaymentPage();
  // Widget buildMobile() => PlaceGalleryWidget(onPlaceChanged: (value) {});

  Widget buildTablet() => MakePaymentPage();

  Widget buildDesktop() => Row(children: [Expanded(child: DrawerWidget()), Expanded(flex: 3, child: buildBody())]);

  Widget buildBody() => Container();
  // SingleChildScrollView(
  //   child: Container(
  //     color: Colors.grey[200],
  //     padding: const EdgeInsets.all(10.0),
  //     height: MediaQuery.of(context).size.height,
  //     child: Column(
  //       children: [
  //         Expanded(child: PlaceGalleryWidget(onPlaceChanged: (place) => changePlace(place), isHorizontal: true)),
  //         Expanded(flex: 2, child: PlaceDetailsWidget(place: selectedPlace)),
  //       ],
  //     ),
  //   ),
  // );
}
