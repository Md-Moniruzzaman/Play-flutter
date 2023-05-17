import 'package:bloc_weather/bottom_nav_bar_pages/bar_item_page.dart';
import 'package:bloc_weather/bottom_nav_bar_pages/home_page.dart';
import 'package:bloc_weather/bottom_nav_bar_pages/profile_page.dart';
import 'package:bloc_weather/bottom_nav_bar_pages/search_page.dart';
import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum PageTitle { Home, BarItem, Search, Accounts }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static const routeName = '/';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  final _pageKye = GlobalKey();
  int currentIndex = 0;
  bool bottomTap = false;
  final List page = [
    const HomePage(),
    const BarItemPage(),
    const SearchPage(),
    const ProfilePage(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }
  // List<String> pageTitle = ['Home', 'BarItem', 'Search', 'Accounts'];

  void onTap(int index) {
    setState(() {
      bottomTap = true;
      // _pageKye.currentState!.activate();
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(pageTitle[currentIndex]),
        title: Text(PageTitle.values[currentIndex].name),
        centerTitle: true,
      ),
      body: PageView.builder(
          key: _pageKye,
          controller: _pageController,
          itemCount: page.length,
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
              bottomTap = false;
            });
          },
          itemBuilder: (contex, index) {
            index = currentIndex;

            return page[index];
          }),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.red,
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'Bar', icon: Icon(Icons.bar_chart)),
          BottomNavigationBarItem(label: 'Search', icon: Icon(Icons.search)),
          BottomNavigationBarItem(label: 'Account', icon: Icon(Icons.person)),
        ],
        onTap: onTap,
      ),
    );
  }
}
