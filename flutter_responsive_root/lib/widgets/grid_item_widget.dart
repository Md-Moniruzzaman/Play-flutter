import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_responsive_root/models/place.dart';
import 'package:flutter_responsive_root/pages/details_page.dart';
import 'package:flutter_responsive_root/widgets/responsive_widget.dart';

class GridItemWidget extends StatelessWidget {
  final Place place;
  final ValueChanged<Place> onChangePlace;
  const GridItemWidget({super.key, required this.place, required this.onChangePlace});

  @override
  Widget build(BuildContext context) {
    final fontSize = MediaQuery.of(context).size.width * 0.025;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        onTap: () {
          final isMobile = ResponsiveWidget.isMobile(context);
          final isTablet = ResponsiveWidget.isTablet(context);

          if (isMobile || isTablet) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => DetailsPage(place: place)));
          } else {
            // Handle desktop navigation
            // For example, you might want to show a dialog or a new page
            onChangePlace(place);
          }
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: AutoSizeText(
              place.name,
              maxLines: 1,
              minFontSize: 16,
              maxFontSize: 24,
              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            ),
            subtitle: AutoSizeText(
              place.location ?? '',
              maxLines: 1,
              minFontSize: 16,
              maxFontSize: 24,
              style: TextStyle(color: Colors.white70, fontSize: fontSize),
            ),
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
    );
  }
}
