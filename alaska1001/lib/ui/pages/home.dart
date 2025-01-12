import 'package:alaska1001/ui/pages/animated_list_page.dart';
import 'package:alaska1001/ui/pages/gradientPage.dart';
import 'package:alaska1001/ui/pages/tabbar_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pageController = PageController();
  int _counter = 0;
  dynamic selected;
  var heart = false;

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      extendBody: true,
      appBar: AppBar(
        title: const Text('PageController'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TabbarHomePage())),
            icon: const Icon(Icons.arrow_forward),
          ),
          IconButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AnimatedListPage())),
            icon: const Icon(Icons.abc),
          ),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        items: [
          BottomBarItem(
            badge: const Text(
              '1',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            badgeColor: Colors.red,
            badgePadding: const EdgeInsets.all(50),
            showBadge: true,
            icon: const Icon(
              Icons.house_outlined,
            ),
            selectedIcon: const Icon(Icons.house_rounded),
            selectedColor: Colors.teal,
            backgroundColor: Colors.teal,
            title: const Text('Home'),
          ),
          // BottomBarItem(
          //   icon: const Icon(Icons.star_border_rounded),
          //   selectedIcon: const Icon(Icons.star_rounded),
          //   selectedColor: Colors.red,
          //   // unSelectedColor: Colors.purple,
          //   // backgroundColor: Colors.orange,
          //   title: const Text('Star'),
          // ),
          BottomBarItem(
              icon: const Icon(
                Icons.style_outlined,
              ),
              selectedIcon: const Icon(
                Icons.style,
              ),
              backgroundColor: Colors.green,
              selectedColor: Colors.deepOrangeAccent,
              title: const Text('Style')),
          BottomBarItem(
              icon: const Icon(
                Icons.person_outline,
              ),
              selectedIcon: const Icon(
                Icons.person,
              ),
              backgroundColor: Colors.red,
              selectedColor: Colors.deepPurple,
              title: const Text('Profile')),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        currentIndex: selected ?? 0,
        onTap: (index) {
          // pageController.animateTo(700.0,
          //     duration: const Duration(microseconds: 700),
          //     curve: Curves.linear);
          setState(() {
            selected = index;
            pageController.jumpToPage(index);
          });
        },
        option: BubbleBarOptions(
          // iconSize: 32,
          // barAnimation: BarAnimation.fade,
          // iconStyle: IconStyle.animated,
          // opacity: 0.3,

          // for bublebar option

          barStyle: BubbleBarStyle.horizontal,
          // barStyle: BubbleBarStyle.vertical,
          // bubbleFillStyle: BubbleFillStyle.fill,
          bubbleFillStyle: BubbleFillStyle.outlined,
          // borderRadius: BorderRadius.circular(50),
          opacity: 0.3,
          inkEffect: false,
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) => setState(() => selected = value),
        children: const [
          OnePage(
            color: Colors.teal,
          ),
          OnePage(
            color: Colors.green,
          ),
          Gradientpage(
            color: Colors.red,
          ),
          // OnePage(
          //   color: Colors.blue,
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            heart = !heart;
          });
        },
        backgroundColor: Colors.white,
        child: Icon(
          heart ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
          color: Colors.red,
        ),
      ),
    );
  }

  bool get wantKeepAlive => true;
}

class MyIcons {
  static const IconData myIcon = IconData(0xe800, fontFamily: 'MyFlutterApp');
}
