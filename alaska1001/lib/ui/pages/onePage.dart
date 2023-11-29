// import 'package:flutter/material.dart';

// class Gradientpage extends StatefulWidget {
//   final Color? color;

//   const Gradientpage({super.key, this.color});

//   @override
//   _GradientpageState createState() => _GradientpageState();
// }

// class _GradientpageState extends State<Gradientpage>
//     with AutomaticKeepAliveClientMixin<Gradientpage> {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Center(
//       child: Container(
//         decoration: const BoxDecoration(
//             gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           stops: [
//             0.1,
//             0.4,
//             0.6,
//             0.9,
//           ],
//           colors: [
//             Colors.yellow,
//             Colors.red,
//             Colors.indigo,
//             Colors.teal,
//           ],
//         )),
//         child: const Center(
//           child: Text(
//             'Hello Gradient!',
//             style: TextStyle(
//               fontSize: 48.0,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   bool get wantKeepAlive => true;
// }
