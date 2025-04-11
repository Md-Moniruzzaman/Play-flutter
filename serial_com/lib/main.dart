import 'package:flutter/material.dart';
import 'package:serial_com/payment_pos_com_windows.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const InitUsb(),
      home: const PymentPostComWin(),
      // home: const SerialDemoScreen(),
    );
  }
}
