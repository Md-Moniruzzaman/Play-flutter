import 'package:flutter/material.dart';

class TabbarHomePage extends StatefulWidget {
  const TabbarHomePage({super.key, this.title});

  final String? title;

  @override
  _TabbarHomePageState createState() => _TabbarHomePageState();
}

class _TabbarHomePageState extends State<TabbarHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
              Tab(
                icon: Icon(Icons.airplanemode_active),
              )
            ],
          ),
        ),
        body: const TabBarView(children: [
          OnePage(
            color: Colors.black,
          ),
          OnePage(
            color: Colors.green,
          ),
          OnePage(
            color: Colors.red,
          ),
          OnePage(
            color: Colors.blue,
          ),
        ]),
      ),
    );
  }
}

class OnePage extends StatefulWidget {
  final Color? color;

  const OnePage({super.key, this.color});

  @override
  _OnePageState createState() => _OnePageState();
}

class _OnePageState extends State<OnePage>
    with AutomaticKeepAliveClientMixin<OnePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      primary: false,
      physics: BouncingScrollPhysics(),
      itemCount: 100,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${index + 1} hello! lorem impsum",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
