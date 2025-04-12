import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/widgets/responsive_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  ResponsiveWidget(mobile: buildMobile(), tablet: buildTablet(), desktop: buildDesktop());
  }

  Widget buildMobile() => Container(color: Colors.green, child: const Center(child: Text('Mobile')));

  Widget buildTablet() => Container(color: Colors.red, child: const Center(child: Text('Tablet')));
  
  Widget buildDesktop() => Container(color: Colors.blue, child: const Center(child: Text('Desktop')));


}