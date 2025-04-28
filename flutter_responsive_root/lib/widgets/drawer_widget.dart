import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/data/places.dart';
import 'package:flutter_responsive_root/data/states.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allStates.length + 1,
      itemBuilder: (context, index) {
        return index == 0 ? buildHeader(context) : buildMenueList(context, index);
      },
    );
  }

  Widget buildHeader(BuildContext context) {
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
          const Text(
            'Explore the world',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget buildMenueList(BuildContext context, index) {
    return ListTile(
      leading: const Icon(Icons.location_city),
      title: Text(allStates[index - 1]),
      onTap: () {
      },
    );
  }
}
