import 'package:disable_home_back_button/custom_show_dialog.dart';
import 'package:disable_home_back_button/timed_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart'; // Import this to use exit(0)

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppCloseExample(),
    );
  }
}

class AppCloseExample extends StatelessWidget {
  const AppCloseExample({super.key});

  void _closeApp() {
    // Close the app programmatically
    exit(0);
  }

  Future<void> _clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      if (cacheDir.existsSync()) {
        cacheDir.deleteSync(recursive: true);
        print("Cache cleared successfully.");
      }
    } catch (e) {
      print("Error clearing cache: $e");
    }
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Close App"),
          content: const Text(
              "Are you sure you want to close the app and clear all cache?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _clearCache(); // Clear cache
                _closeApp(); // Close the app
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Close App Example"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _showExitConfirmationDialog(context),
                child: const Text("Close App"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const TimedPage())),
                child: const Text("Timed Page"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => // Show the reusable dialog
                    AddToCartDialog.show(context),
                child: const Text("Show dialog Test"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
