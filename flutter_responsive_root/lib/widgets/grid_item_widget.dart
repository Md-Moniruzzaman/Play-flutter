import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/models/place.dart';
import 'package:flutter_responsive_root/pages/details_page.dart';

class GridItemWidget extends StatelessWidget {
  final Place place;
  const GridItemWidget({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsPage(place: place))),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(place.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            subtitle: Text(place.location ?? '', style: const TextStyle(color: Colors.white70)),
            trailing: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                // Handle favorite action
              },
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: Image.network(place.imageUrl, fit: BoxFit.cover),
          ),
        ),
      ),

      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Expanded(
      //       child: ClipRRect(
      //         borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      //         child: Image.network(place.imageUrl, fit: BoxFit.cover),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Text(place.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //       child: Text(place.description, style: const TextStyle(color: Colors.grey)),
      //     ),
      //   ],
      // ),
    );
  }
}
