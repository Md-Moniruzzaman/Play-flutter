// pubspec.yaml dependencies
// flutter_stripe: ^9.5.0
// http: ^0.14.0

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_YOUR_PUBLISHABLE_KEY'; // Replace with your key
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Demo',
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatelessWidget {
  Future<void> _pay() async {
    try {
      // 1. Call backend to get client secret
      final response = await http.post(
        Uri.parse('https://your-backend.com/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'amount': 5000}), // $50.00
      );

      final jsonResponse = json.decode(response.body);
      final clientSecret = jsonResponse['clientSecret'];

      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Your Business Name',
        ),
      );

      // 3. Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      print("Payment successful");
    } catch (e) {
      print("Error during payment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stripe Payment')),
      body: Center(
        child: ElevatedButton(
          onPressed: _pay,
          child: Text('Pay \$50'),
        ),
      ),
    );
  }
}
