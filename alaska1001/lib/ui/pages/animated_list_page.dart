import 'package:flutter/material.dart';

class AnimatedListPage extends StatefulWidget {
  const AnimatedListPage({super.key});

  @override
  State<AnimatedListPage> createState() => _AnimatedListPageState();
}

class _AnimatedListPageState extends State<AnimatedListPage> {
  bool startAnimation = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    final sizeW = MediaQuery.of(context).size.width;
    final sizeh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text('Animated list'),
      ),
      body: SafeArea(
          child: ListView.builder(
        primary: false,
        physics: const BouncingScrollPhysics(),
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 80,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            height: 55,
            curve: Curves.linear,
            duration: Duration(milliseconds: 300 + (index * 100)),
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: sizeW / 30),
            transform:
                Matrix4.translationValues(startAnimation ? 0 : sizeW, 0, 0),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${index + 1} hello! lorem impsum",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600))
              ],
            ),
          );
        },
      )),
    );
  }
}
