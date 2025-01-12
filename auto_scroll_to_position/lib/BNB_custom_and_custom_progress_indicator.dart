import 'package:flutter/material.dart';
// import 'package:kiosk/theme/color/my_colors.dart';

class BNBCutomAndProgressIndicator extends StatefulWidget {
  const BNBCutomAndProgressIndicator({super.key});

  @override
  State<BNBCutomAndProgressIndicator> createState() => _HomePageState();
}

class _HomePageState extends State<BNBCutomAndProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation controller for progress, duration 1 second
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {}); // Rebuild to animate
      });

    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test progressbar'),
        ),
        body: Stack(
          children: [
            Positioned(
              bottom: 10, // Adjusted to sit at the top of BNBCustopPainter
              left: 0,
              child: SizedBox(
                height: 170,
                width: size.width,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(size.width, 170),
                      painter: ProgressCustomPainter(
                          _animation.value), // Pass animation value
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 170,
                width: size.width,
                child: Stack(
                  children: [
                    // Custom Bottom Navigation with Rounded Top Edges
                    CustomPaint(
                      size: Size(size.width, 170),
                      painter: BNBCustopPainter(),
                    ),
                    // The progress indicator will sit above this CustomPaint
                  ],
                ),
              ),
            ),
            // Positioned(
            //   bottom: 180,
            //   left: size.width * 0.33,
            //   // right: size.width * 0.33,
            //   child: Container(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Text(
            //           'PAYMENT METHOD',
            //           style: TextStyle(
            //               fontSize: 16,
            //               fontWeight: FontWeight.bold,
            //               color: MyColors().black),
            //         ),
            //         const SizedBox(height: 8),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset(
            //               'assets/images/visa.png', // Replace with the actual image path
            //               height: 40, // Set the height for the image
            //               width: 100, // Set the width for the image
            //               fit: BoxFit.cover,
            //             ),
            //             const SizedBox(width: 10), // Add space between the images
            //             Image.asset(
            //               'assets/images/bkash.png', // Replace with the actual image path
            //               height: 40, // Set the height for the image
            //               width: 110, // Set the width for the image
            //               fit: BoxFit.cover,
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Positioned(
            //   // bottom: size.width * 0.50,
            //   top: size.width * 0.68,
            //   left: size.width * 0.22,
            //   // right: size.width * 0.2,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Container(
            //         decoration: BoxDecoration(
            //           border: Border.all(color: MyColors().mainShade),
            //           borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(15),
            //             bottomRight: Radius.circular(15),
            //           ),
            //         ),
            //         height: size.height * .20,
            //         width: size.width * 0.25,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             const Text(
            //               'DINE IN',
            //               style: TextStyle(
            //                   fontSize: 25, fontWeight: FontWeight.bold),
            //             ),
            //             const SizedBox(height: 10),
            //             Image.asset(
            //               'assets/images/DINEIN.png',
            //               height: 130,
            //               width: 130,
            //               fit: BoxFit.cover,
            //             ),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 60),
            //       Container(
            //         decoration: BoxDecoration(
            //           border: Border.all(color: MyColors().mainShade),
            //           borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(15),
            //             bottomRight: Radius.circular(15),
            //           ),
            //         ),
            //         height: size.height * .20,
            //         width: size.width * 0.25,
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             const Text(
            //               'TAKEWAY',
            //               style: TextStyle(
            //                   fontSize: 25, fontWeight: FontWeight.bold),
            //             ),
            //             const SizedBox(height: 10),
            //             Image.asset(
            //               'assets/images/TAKEAWY.jpg',
            //               height: 120,
            //               width: 120,
            //               fit: BoxFit.cover,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Column(
            //   children: [
            //     Container(
            //       color: MyColors().white,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 150),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             Container(
            //               height: 35,
            //               width: 40,
            //               color: MyColors().mainColor,
            //             ),
            //             Container(
            //               height: 35,
            //               width: 40,
            //               color: MyColors().mainColor,
            //             ),
            //             Container(
            //               height: 35,
            //               width: 40,
            //               color: MyColors().mainColor,
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       height: 20,
            //     ),
            //     Container(
            //       decoration: BoxDecoration(
            //         boxShadow: [
            //           BoxShadow(
            //             color: const Color.fromARGB(255, 157, 152, 152)
            //                 .withOpacity(0.20),
            //             // spreadRadius: 2,
            //             blurRadius: 10,
            //             offset: const Offset(
            //               0,
            //               1,
            //             ),
            //           ),
            //         ],
            //         // borderRadius: BorderRadius.circular(15.0),
            //       ),
            //       child: Padding(
            //         padding: const EdgeInsets.all(10),
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.circular(5),
            //           child: Image.asset(
            //             'assets/images/select_page_img.jpg',
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       height: 10,
            //     ),
            //     Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         const Text(
            //           'ORDER HERE',
            //           style: TextStyle(
            //             fontSize: 80,
            //             fontWeight: FontWeight.bold,
            //             height: 0.9,
            //           ),
            //           textHeightBehavior: TextHeightBehavior(
            //             applyHeightToFirstAscent: false,
            //             applyHeightToLastDescent: false,
            //           ),
            //         ),
            //         const Text(
            //           'TO SKIP THE QUEUE',
            //           style: TextStyle(
            //             fontSize: 30,
            //             fontWeight: FontWeight.bold,
            //             height: 0.9,
            //           ),
            //         ),
            //         Text(
            //           'Width: ${size.width}',
            //           style: const TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             height: 0.9,
            //           ),
            //         ),
            //         Text(
            //           'Height: ${size.height}',
            //           style: const TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //             height: 0.9,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}

class BNBCustopPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = MyColors().mainColor
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    Path path = Path()..moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width * .5, 0, size.width, size.height * 0.50);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawShadow(path, Colors.white, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ProgressCustomPainter extends CustomPainter {
  final double progress; // Animation value from 0 to 1

  ProgressCustomPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    // Define the full background path (static path)
    Path path = Path()..moveTo(0, size.height * 0.50);
    path.quadraticBezierTo(
      size.width * .5, 0, // Control point
      size.width, size.height * 0.50, // End point
    );
    path.lineTo(size.width, size.height); // Close to bottom-right
    path.lineTo(0, size.height); // Close to bottom-left
    path.close();

    // Draw the full background curve (static, grey)
    canvas.drawPath(path, backgroundPaint);

    // Create a gradient shader that animates based on progress
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const [
        // MyColors().mainColor, // End color
        Colors.red,
        Colors.white, // Start color
      ],
      stops: [
        progress, // Sharp transition at the progress point
        progress, // The same progress point for the sharp change
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width * progress, size.height));

    // Apply the gradient shader to the paint
    paint.shader = gradient;

    // Draw the progress path with the animated gradient
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint when animation updates (progress changes)
  }
}
