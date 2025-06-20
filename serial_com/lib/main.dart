import 'package:flutter/material.dart';
import 'package:serial_com/InitUsb.dart';
import 'package:serial_com/payment_pos_com_windows.dart';
import 'package:serial_com/payment_pos_com_windows_with_package.dart';
import 'package:serial_com/serial_com_wizar_card_reader_with_package.dart';
import 'package:serial_com/wizar_pos_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const InitUsb(), // Use this for the USB version of the code in Android
      // home: const PymentPostComWinWithPackage(), //Use this for the package version of the code in Windows
      // home: const PymentPostComWin(),// Use this for the code in Windows without the package
      // home: const SerialDemoScreen(),
      home: const SerialComWizarCardReaderWithPackage(),
    );
  }
}
