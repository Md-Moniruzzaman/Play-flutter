import 'package:flutter/material.dart';

class AddToCartDialog extends StatefulWidget {
  const AddToCartDialog({super.key});

  @override
  State<AddToCartDialog> createState() => _AddToCartDialogState();

  // Static method to show the dialog
  static Future<void> show(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => const AddToCartDialog(),
    );
  }
}

class _AddToCartDialogState extends State<AddToCartDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  int _cartCount = 1; // Starting number for the cart count

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and scale animation.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();
  }

  void _incrementCartCount() {
    setState(() {
      _cartCount++;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated Cart Counter on Top
            SizedBox(
              height: 80,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -1), // Start from top
                      end: const Offset(0, 0), // End at center
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  '$_cartCount',
                  key: ValueKey<int>(_cartCount), // Unique key for animation
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Cart Icon
            const Icon(Icons.shopping_cart, size: 80, color: Colors.blue),

            const SizedBox(height: 20),

            const Text(
              "Item Added to Cart!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _incrementCartCount();
              },
              child: const Text("Add Another Item"),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
