import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MakePaymentPage extends StatefulWidget {
  const MakePaymentPage({super.key});

  @override
  State<MakePaymentPage> createState() => _MakePaymentPageState();
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  @override
  Widget build(BuildContext context) {
    final double fontSize = MediaQuery.of(context).size.width * 0.025;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('Make Payment', minFontSize: 20, maxFontSize: 28, style: TextStyle(fontSize: fontSize)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AutoSizeText('Payment Page', minFontSize: 14, maxFontSize: 24, style: TextStyle(fontSize: fontSize)),
            // const SizedBox(height: 20),
            buildAmountShow(context, fontSize),
            const SizedBox(height: 20),
            buildCardPaymentOption(context, fontSize),
            const SizedBox(height: 20),
            buildMobileBankingOption(context, fontSize),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle payment logic here
              },
              child: const Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAmountShow(BuildContext context, double fontSize) {
    return Expanded(
      flex: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            AutoSizeText(
              'Total Amount',
              textAlign: TextAlign.center,

              style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              minFontSize: 48,
              maxFontSize: 52,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    '৳ 100.00',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                    minFontSize: 65,
                    maxFontSize: 85,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the card payment option
  Widget buildCardPaymentOption(BuildContext context, double fontSize) {
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  // color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Light underline
                      width: 1.0,
                    ),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black, // Shade 1 elevation (very subtle)
                  //     blurRadius: 1.0,
                  //     offset: Offset(0, 1), // Small downward shadow
                  //   ),
                  // ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/gif_images/card_pay.gif', // Your GIF file in assets
                      // width: 30,
                      height: 50,
                    ),
                    SizedBox(width: 8),
                    AutoSizeText(
                      'Pay with Card',
                      minFontSize: 18,
                      maxFontSize: 24,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                // height: 100, // Adjust height as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCardOption(context, fontSize, 'assets/images/logo_city_bank.png', 'City Bank'),
                    buildCardOption(context, fontSize, 'assets/images/logo_eastern_bank.png', 'EBL'),
                    buildCardOption(context, fontSize, 'assets/images/logo_ab_bank.png', 'AB Bank'),
                    buildCardOption(context, fontSize, 'assets/images/brac_bank.jpg', 'BRAC Bank'),
                    buildCardOption(context, fontSize, 'assets/images/logo_dbbl.png', 'DBBL'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build the mobile banking payment option
  Widget buildMobileBankingOption(BuildContext context, double fontSize) {
    return Expanded(
      flex: 2,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  // color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // Light underline
                      width: 1.0,
                    ),
                  ),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black, // Shade 1 elevation (very subtle)
                  //     blurRadius: 1.0,
                  //     offset: Offset(0, 1), // Small downward shadow
                  //   ),
                  // ],
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/gif_images/mobile_pay.gif', // Your GIF file in assets
                      // width: 30,
                      height: 50,
                    ),
                    SizedBox(width: 8),
                    AutoSizeText(
                      'Pay with Mobile Banking',
                      minFontSize: 18,
                      maxFontSize: 24,
                      style: TextStyle(fontSize: fontSize),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width - 20,
                // height: 100, // Adjust height as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCardOption(context, fontSize, 'assets/images/Bkash-Logo.png', 'Bkash'),
                    buildCardOption(context, fontSize, 'assets/images/nagad_logo.png', 'Nagad'),
                    buildCardOption(context, fontSize, 'assets/images/Upay_logo.png', 'Upay'),
                    buildCardOption(context, fontSize, 'assets/images/rocket_logo.png', 'Rocket'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build individual card option
  Widget buildCardOption(BuildContext context, double fontSize, String imagePath, String cardName) {
    return GestureDetector(
      onTap: () {
        // Handle card selection logic here
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$cardName payment process is under development')));
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          // color: Colors.blue[50],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100, // Light shadow
              blurRadius: 4.0,
              offset: const Offset(0, 2), // Slight downward shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Image.asset(imagePath, height: 60), // Card image
            // SizedBox(width: 8),
            // AutoSizeText(cardName, minFontSize: 14, maxFontSize: 20, style: TextStyle(fontSize: fontSize)),
          ],
        ),
      ),
    );
  }
}
