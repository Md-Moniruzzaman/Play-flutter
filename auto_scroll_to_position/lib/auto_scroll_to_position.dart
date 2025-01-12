import 'package:flutter/material.dart';

class AutoScrollToPosition extends StatefulWidget {
  const AutoScrollToPosition({super.key});

  @override
  State<AutoScrollToPosition> createState() => _AutoScrollToPositionState();
}

class _AutoScrollToPositionState extends State<AutoScrollToPosition> {
  final ScrollController _scrollController = ScrollController();
  int selectedCategoryIndex = 3;
  List<String> categories = [
    "Cate 1",
    "Cate 2",
    "Cate 3",
    "Cate 4",
    "Cate 5",
    "Cate 6",
    "Cate 7",
    "Cate 8",
    "Cate 9",
    "Cate 10",
  ];
  List<String> items = List.generate(10, (index) => 'Item ${index + 1}');
  List<String> subItems = List.generate(10, (index) => 'subItems ${index + 1}');
  // Map<int, bool> selectedColor = {};

  // This method scrolls to a specific item based on the selected category

  @override
  void initState() {
    super.initState();
    // categories.forEach((val) {
    //   selectedColor[categories.indexOf(val)] = false;
    //   // print(categories.indexOf(val));
    // });
    // selectedColor[selectedCategoryIndex] = true;
    _scrollController.addListener(_onScroll);

    // Pre-scroll to Category 3 when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToCategory(selectedCategoryIndex);
    });
  }

// Method to calculate the dynamic height of each item (ListTile + GridView)
  double getItemHeight(int index) {
    const double listTileHeight = 50.0; // Fixed height of the ListTile
    const double gridItemHeight = 110.0; // Height of each item in the grid
    const double gridSpacing = 4.0; // Spacing between grid items
    int crossAxisCount = 2; // Number of items per row in the grid

    // Calculate the number of rows required to display all sub-items
    int numberOfRows = (subItems.length / crossAxisCount).ceil();

    // Calculate the total height of the grid
    double gridHeight =
        (gridItemHeight * numberOfRows) + (gridSpacing * (numberOfRows - 1));

    // Return the total height of the ListTile + GridView
    return listTileHeight + gridHeight;
  }

  // Scroll listener to detect which category should be selected base on the scroll position
  void _onScroll() {
    double scrollPosition = _scrollController.offset;
    double screenHeight = MediaQuery.of(context).size.height;
    double cumulativeHeight = 0;

    for (int i = 0; i < items.length; i++) {
      double itemHeight = getItemHeight(i);
      cumulativeHeight += itemHeight;

      // Check if the item is within 300px from the top of the viewport
      if (scrollPosition + screenHeight * 0.4 <= cumulativeHeight &&
          scrollPosition + screenHeight >= cumulativeHeight) {
        setState(() {
          selectedCategoryIndex = i;
        });
        break;
      }
    }
  }

// This method scrolls to a specific item based on the selected category
  void scrollToCategory(int categoryIndex) {
    // Calculate the position to scroll to based on the category index
    double position = 0;
    for (int i = 0; i < categoryIndex; i++) {
      position += getItemHeight(i);
    }
    // double position = categoryIndex * getItemHeight(categoryIndex);
    _scrollController.animateTo(
      position,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Auto Scroll Example'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  // scrollToCategory(selectedCategoryIndex);
                  return GestureDetector(
                    onTap: () {
                      // Scroll to the corresponding category when tapped
                      // categories.forEach((val) {
                      //   selectedColor[categories.indexOf(val)] = false;
                      // });
                      // selectedColor[index] = true;
                      scrollToCategory(index);
                      // setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Chip(
                        label: Text(categories[index]),
                        backgroundColor: selectedCategoryIndex == index
                            ? Colors.blue.withOpacity(0.7)
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  );
                },
              ),
            ),

            // List of items and grid of subitems
            Expanded(
              flex: 6,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: getItemHeight(index),
                    child: Column(
                      children: [
                        ListTile(
                          minTileHeight: 50,
                          tileColor: Colors.grey.withOpacity(0.3),
                          title: Text(items[index]),
                        ),
                        Expanded(
                          child: GridView.builder(
                              shrinkWrap:
                                  true, // Allow the GridView to fit within the column
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio:
                                          1.45, // Adjust this for item height and width
                                      crossAxisCount:
                                          2, // 2 items per row in th grid
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4),
                              itemCount: subItems.length,
                              itemBuilder: (context, subIndex) {
                                return Card(
                                  color: Colors.blueAccent.withOpacity(0.5),
                                  child: Center(
                                    child: Text(
                                      subItems[subIndex],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
            // Category selector
          ]),
        ),
      ),
    );
  }
}
