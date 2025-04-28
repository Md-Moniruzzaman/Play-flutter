import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/widgets/drawer_widget.dart';
import 'package:flutter_responsive_root/widgets/place_gallery_widget.dart';
import 'package:flutter_responsive_root/widgets/responsive_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveWidget.isMobile(context);
    return Scaffold(
      appBar: AppBar(title: Text('Tour App')),
      drawer: isMobile ? Drawer(child: DrawerWidget()) : null,
      body: ResponsiveWidget(mobile: buildMobile(), tablet: buildTablet(), desktop: buildDesktop()),
    );
  }

  Widget buildMobile() => PlaceGalleryWidget();

  Widget buildTablet() => Container(color: Colors.red, child: const Center(child: Text('Tablet')));

  Widget buildDesktop() => Container(color: Colors.blue, child: const Center(child: Text('Desktop')));
}
