import 'package:flutter/material.dart';
import 'package:serial_com/payment_pos_com_windows.dart';
import 'package:serial_com/payment_pos_com_windows_with_package.dart';

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
      // home: const InitUsb(), // Use this for the USB version of the code in Android
      home: const PymentPostComWinWithPackage(), //Use this for the package version of the code in Windows
      // home: const PymentPostComWin(),// Use this for the code in Windows without the package
      // home: const SerialDemoScreen(),
    );
  }
}
