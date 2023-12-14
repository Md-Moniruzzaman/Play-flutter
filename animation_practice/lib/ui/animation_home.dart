import 'package:animation_practice/ui/list_view_animaiton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimationHome extends StatefulWidget {
  const AnimationHome({super.key});

  @override
  State<AnimationHome> createState() => _AnimationHomeState();
}

class _AnimationHomeState extends State<AnimationHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> items = List.generate(100, (index) => 'Item $index');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 1.5, end: 1.0).animate(_controller);

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
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ListViewAnimation()));
              },
              child: const Text('List View'))
        ],
      )

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
