import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListViewAnimation extends StatefulWidget {
  const ListViewAnimation({super.key});

  @override
  State<ListViewAnimation> createState() => _ListViewAnimationState();
}

class _ListViewAnimationState extends State<ListViewAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // late Animation<double> _animation;
  late Animation<Offset> _animation;

  final List<String> items = List.generate(100, (index) => 'Item $index');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // _animation = Tween<double>(begin: 2.5, end: .50).animate(_controller);
    _animation = Tween<Offset>(
            begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(_controller);

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Animation Home'),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return SlideTransition(
                  position: _animation,
                  child: ListTile(
                    title: Text(items[index]),
                  ),
                );
              },
            );
          },
        ),

        // AnimatedBuilder(
        //   animation: _animation,
        //   builder: (context, child) {
        //     return SizeTransition(
        //       sizeFactor: _animation,
        //       child: ListView.builder(
        //         itemCount: items.length,
        //         itemBuilder: (context, index) {
        //           return ListTile(
        //             title: Text(items[index]),
        //           );
        //         },
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
}
