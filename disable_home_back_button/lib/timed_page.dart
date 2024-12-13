import 'package:flutter/material.dart';
import 'dart:async';

class TimedPage extends StatefulWidget {
  const TimedPage({super.key});

  @override
  _TimedPageState createState() => _TimedPageState();
}

class _TimedPageState extends State<TimedPage> {
  Timer? _timer; // Timer for 3 minutes
  Timer? _dialogTimer; // Timer for countdown in the dialog
  int _countdown = 30; // Countdown seconds
  bool _isDialogVisible = false;
  bool _isCallTimer = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dialogTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    // Timer for 3 minutes (180 seconds)
    _timer = Timer(const Duration(seconds: 30), _showDialog);
  }

  void _showDialog() {
    // Show the alert dialog with a countdown
    if (!_isDialogVisible) {
      setState(() {
        _isDialogVisible = true;
        _countdown = 30; // Reset countdown
      });

      // Show the dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing the dialog manually
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              if (_isCallTimer) {
                // Timer to update countdown
                _dialogTimer =
                    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
                  if (_countdown > 0) {
                    setDialogState(() {
                      _countdown--;
                      _isCallTimer = false;
                    });
                  } else {
                    // Close the dialog and stop the timer
                    timer.cancel();
                    if (mounted && _isDialogVisible) {
                      Navigator.of(context).pop(); // Close the dialog
                      setDialogState(() {
                        _isDialogVisible = false;
                      });
                      _callUserDefinedFunction(); // Call your custom function
                    }
                  }
                });
              }

              return AlertDialog(
                title: const Text("Alert"),
                content: Text(
                  "This dialog will close in $_countdown seconds.",
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          );
        },
      );
    }
  }

  void _callUserDefinedFunction() {
    // Your custom function logic
    print("User-defined function called after dialog closed.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timed Page Example"),
      ),
      body: const Center(
        child: Text(
          "This page will show an alert after 3 minutes.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
