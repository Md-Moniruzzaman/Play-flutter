import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/data/places.dart';
import 'package:flutter_responsive_root/data/states.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width * 0.024;
    return ListView.builder(
      itemCount: allStates.length + 1,
      itemBuilder: (context, index) {
        return index == 0 ? buildHeader(context, fontSize) : buildMenueList(context, index, fontSize);
      },
    );
  }

  Widget buildHeader(BuildContext context, double fontSize) {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/e/eb/Machu_Picchu%2C_Peru.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tour App', style: TextStyle(color: Colors.white, fontSize: 24)),
          const SizedBox(height: 10),
          AutoSizeText(
            'Explore the world',
            maxLines: 1,
            minFontSize: 16,
            maxFontSize: 24,
            style: TextStyle(color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget buildMenueList(BuildContext context, index, double fontSize) {
    return ListTile(
      leading: const Icon(Icons.location_city),
      title: AutoSizeText(
        allStates[index - 1],
        maxLines: 1,
        minFontSize: 16,
        maxFontSize: 24,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w300),
      ),
      onTap: () {},
    );
  }
}
