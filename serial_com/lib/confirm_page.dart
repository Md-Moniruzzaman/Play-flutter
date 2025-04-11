// import 'dart:async';
// import 'dart:convert';
// import 'dart:math';
// import 'package:confetti/confetti.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// // import 'package:image/image.dart' as img;
// import 'package:kiosk/model/order_model.dart';
// import 'package:kiosk/model/post_transaction_response_model.dart';
// import 'package:kiosk/service/all_services.dart';
// import 'package:kiosk/service/repositories.dart';
// import 'package:kiosk/theme/color/my_colors.dart';
// import 'package:kiosk/ui/landing_page.dart';
// import 'package:kiosk/utils/constants.dart';
// import 'package:kiosk/widget/BNB_custom_painter.dart';
// import 'package:kiosk/widget/BNB_custom_painter2.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
// import 'package:usb_serial/usb_serial.dart';

// class ConfirmPage extends StatefulWidget {
//   const ConfirmPage({super.key, required this.isCard, required this.isBikash});
//   final bool isCard;
//   final bool isBikash;

//   @override
//   State<ConfirmPage> createState() => _ConfirmPageState();
// }

// class _ConfirmPageState extends State<ConfirmPage> with SingleTickerProviderStateMixin {
//   //For Printer
//   bool printBinded = false;
//   int paperSize = 0;
//   String serialNumber = "";
//   String printerVersion = "";

//   PostTransactionResponse? postTransactionResponse;
//   bool isLoading = true;
//   bool isProgressStarted = false;
//   late AnimationController _controller;
//   final double _kSize = 100;
//   double _progressValue = 0.0;
//   final _controllerConfetti = ConfettiController();

//   // Card payment Gateway integration
//   UsbPort? _port;
//   StreamSubscription<Uint8List>? _subscription;
//   List<UsbDevice> _devices = [];
//   Map<String, dynamic> cardResponse = {};

//   /// Session Handle
//   Timer? _dialogTimer; // Timer for countdown in the dialog
//   int _countdown = 60; // Countdown seconds
//   bool _isDialogVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     _getDevices();
//     // _sendRequest();
//     //For Printer
//     _bindingPrinter();

//     // sendOrder();
//     // Initialize the loading animation controller

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 8),
//     )..repeat();

//     // Simulate the initial loading animation for 6 seconds
//     if (widget.isCard) {
//       Future.delayed(
//         const Duration(seconds: 1),
//         () {
//           _sendRequest();
//         },
//       );
//     } else if (widget.isBikash) {
//       theNewOrder.pTmedDetail.tmedObjectNum = 14;
//       theNewOrder.pTmedDetail.tmedReference = 14;
//       sendOrder('Bkash');
//       setState(() {
//         isLoading = false;
//       });
//     } else {
//       _dialogTimer?.cancel();
//       Navigator.pop(context);
//     }
//     qrReferenceId = '';
//     bkashResponseData = {};
//   }

//   // Findout usb connected devices
//   Future<void> _getDevices() async {
//     // UsbDevice? _usbDevice;
//     _devices = await UsbSerial.listDevices();
//     for (var ele in _devices) {
//       if (ele.pid.toString() == productId && ele.vid.toString() == vendorId) {
//         // _showMyDialog(context, ele);
//         _connectDevice(ele);
//       }
//     }
//   }

//   Future<void> _connectDevice(UsbDevice? device) async {
//     if (device != null) {
//       try {
//         _port = await device.create();

//         if (_port != null) {
//           // Attempt to open the port
//           bool isPortOpen = await _port!.open();
//           if (isPortOpen) {
//             await _port!.setDTR(true);
//             await _port!.setRTS(true);
//             // Set port parameters if opened successfully
//             _port!.setPortParameters(baudRate, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

//             // Set port parameters if opened successfully
//             // _port!.setPortParameters(115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

//             // Start listening for data
//             _listenForData();
//           } else {
//             print('Print is no open.');
//           }
//         } else {
//           print('Port is null, device not connected properly.');
//         }
//       } catch (e) {
//         print(e);
//       }
//     } else {}
//   }

//   void _listenForData() {
//     List<int> buffer = [];
//     var recHex = '';
//     var jsnoString = '';
//     var byteData = '';
//     Map<String, dynamic> cardRes = {};

//     _subscription = _port!.inputStream!.listen((Uint8List data) {
//       buffer.addAll(data); // Add incoming data to the buffer
//       byteData = buffer.toString();

//       // Check if the first byte received is ACK (0x06)
//       if (buffer.isNotEmpty && buffer.first == 0x06) {
//         print("Received ACK (0x06) from device");
//         final hexString = buffer.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
//         recHex = hexString;

//         buffer.removeAt(0); // Remove the ACK from the buffer
//         return; // Exit early as we only need to process the ACK
//       }
//       // Check if we have enough data to process (STX + 2 bytes for length + data + ETX)
//       while (buffer.length >= 4) {
//         // Find the start (STX) and end (ETX) markers
//         int startIdx = buffer.indexOf(0x02); // Find STX (0x02)
//         int endIdx = buffer.indexOf(0x03); // Find ETX (0x03)

//         if (startIdx != -1 && endIdx != -1 && endIdx > startIdx) {
//           // Extract the data length (2 bytes after STX)
//           final lengthBytes = buffer.sublist(startIdx + 1, startIdx + 3);
//           final dataLength = (lengthBytes[0] << 8) | lengthBytes[1];

//           // Ensure that the full data (length + ETX) is available
//           if (buffer.length >= startIdx + 3 + dataLength + 1) {
//             final completeMessage = buffer.sublist(startIdx + 3, startIdx + 3 + dataLength);

//             // Convert the message to a hex string (for debugging)
//             final hexString = completeMessage.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
//             recHex = hexString;
//             // Decode the extracted data to UTF-8 (JSON string)
//             String utf8String;
//             try {
//               utf8String = utf8.decode(completeMessage, allowMalformed: true);
//             } catch (e) {
//               utf8String = 'Error decoding data: $e';
//             }

//             // Print the hex and decoded UTF-8 message
//             print('Hex String: $hexString');
//             print('Decoded String: $utf8String');

//             // Parse JSON message if valid
//             try {
//               final Map<String, dynamic> jsonMessage = json.decode(utf8String);
//               print('Decoded JSON: $jsonMessage');
//               jsnoString = jsonMessage.toString();
//               cardRes = jsonMessage;

//               /// Check Amount
//               final double orderAmount = theNewOrder.pTotalsResponse.subTotal;
//               final String orderAmountStr =
//                   orderAmount.toStringAsFixed(2); // Make sure always have 2 decimal point in Order Amount

//               final String removedDecPointFromOrderAmount =
//                   orderAmountStr.replaceAll('.', ''); // Remove decimal point from Amount for Card transaction
//               if (cardRes['RespCode'] == "00" && cardRes['TransAmount'].toString() == removedDecPointFromOrderAmount) {
//                 final String cardAssociation = cardRes['CardAssociation'];
//                 if (cardAssociation.toUpperCase() == "AMEX") {
//                   theNewOrder.pTmedDetail.tmedObjectNum = 12;
//                   theNewOrder.pTmedDetail.tmedReference = 12;
//                 } else if (cardAssociation.toUpperCase() == "MASTERCARD") {
//                   theNewOrder.pTmedDetail.tmedObjectNum = 10;
//                   theNewOrder.pTmedDetail.tmedReference = 10;
//                 } else if (cardAssociation.toUpperCase() == "VISA") {
//                   theNewOrder.pTmedDetail.tmedObjectNum = 11;
//                   theNewOrder.pTmedDetail.tmedReference = 11;
//                 }
//                 _sendAck();
//                 theNewOrder.cardRespLog = cardRes.toString();
//                 paymentLog(theNewOrder);
//                 sendOrder(cardAssociation);
//               } else if (cardRes['RespCode'] == "00" &&
//                   cardRes['TransAmount'].toString() != removedDecPointFromOrderAmount) {
//                 final paymentAmount =
//                     cardRes['TransAmount'].toString().replaceRange(-2, cardRes['TransAmount'].toString().length, '');
//                 final orderAmount = removedDecPointFromOrderAmount
//                     .toString()
//                     .replaceRange(-2, cardRes['TransAmount'].toString().length, '');
//                 if (!mounted) return;
//                 _dialogTimer?.cancel();
//                 paymentLog(theNewOrder);
//                 _showMyDialog(context,
//                     "Sorry! Your payment amount: $paymentAmount does not match your ordered total amount: $orderAmount.");
//               } else {
//                 _sendAck();
//                 theNewOrder.cardRespLog = cardRes.toString();
//                 paymentLog(theNewOrder);
//                 setState(() {});
//                 if (!mounted) return;
//                 _dialogTimer?.cancel();
//                 Navigator.pop(context);
//                 // _showMyDialog(context, cardRes.toString());
//                 // setState(() {});
//               }
//               // You can add further logic to handle the parsed JSON
//             } catch (e) {
//               print('Error parsing JSON: $e');
//             }

//             // Remove processed data from the buffer
//             buffer.removeRange(0, startIdx + 3 + dataLength + 1);
//           }
//         } else {
//           // If no complete message is found, break and wait for more data
//           break;
//         }
//       }
//     });
//   }

//   Future<void> _sendAck() async {
//     await _port!.write(Uint8List.fromList([0x06])); // Send ACK
//   }

//   Future<void> _sendRequest() async {
//     final double orderAmount = theNewOrder.pTotalsResponse.subTotal;
//     final String orderAmountStr =
//         orderAmount.toStringAsFixed(2); // Make sure always have 2 decimal point in Order Amount

//     final String removedDecPointFromOrderAmount =
//         orderAmountStr.replaceAll('.', ''); // Remove decimal point from Amount for Card transaction
//     // print(theNewOrder.phoneNum);
//     final customerPhoneNum = theNewOrder.phoneNum;
//     // JSON data to be sent
//     final requestData = {
//       "SysTrace": terminalId,
//       "SysSN": theNewOrder.orderSl,
//       "TransType": "3",
//       "TransAmount": removedDecPointFromOrderAmount,
//       "PhoneNum": customerPhoneNum,
//     };

//     // save request data for log
//     theNewOrder.cardReqLog = requestData.toString();

//     // paymentLog(theNewOrder);

//     // Encode JSON data to bytes
//     final dataBytes = utf8.encode(json.encode(requestData));
//     final dataLength = dataBytes.length;

//     // Calculate length in high and low bytes
//     final lengthHigh = (dataLength >> 8) & 0xFF;
//     final lengthLow = dataLength & 0xFF;

//     // Construct the message
//     final message = <int>[
//       0x02, // STX
//       lengthHigh,
//       lengthLow,
//       ...dataBytes,
//       0x03, // ETX
//     ];
//     // final hexString =
//     //     message.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
//     // print(hexString);
//     // Convert to Uint8List for transmission
//     final messageBytes = Uint8List.fromList(message);

//     await _port!.write(messageBytes);
//   }

//   void sendOrder(String tmedName) async {
//     for (int i = 0; i < 3; i++) {
//       postTransactionResponse = await Repositories().sentOrder(theNewOrder);
//       if (postTransactionResponse != null) {
//         break; // Correct keyword to exit the loop
//       }
//     }

//     // postTransactionResponse = await Repositories().sentOrder(theNewOrder);

//     if (postTransactionResponse != null) {
//       theNewOrder.checkNum = postTransactionResponse!.guestCheck.checkNum;
//       theNewOrder.checkSeq = postTransactionResponse!.guestCheck.checkSeq;
//       final isDataPost = await Repositories().postOrder(theNewOrder, tmedName, 'micros_done');

//       setState(
//         () {
//           isLoading = false; // End the loading animation
//           _controller.stop();
//           _controllerConfetti.stop(); // Stop the rotation of the animation
//           _startProgressIndicator(); // Start progress indicator after loading
//         },
//       );
//       // _showMyDialog(context, "Sorry! Your Order don't created. $isDataPost");
//     } else {
//       if (!mounted) return;
//       final isDataPost = await Repositories().postOrder(theNewOrder, tmedName, 'micros_failed');
//       _dialogTimer?.cancel();
//       _showMyDialog(context, "Sorry! Your Order don't created. Please Cantact to RGM.");
//     }
//   }

//   void paymentLog(OrderModel thOrder) async {
//     final isDataPost = await Repositories().log_payment(thOrder, "card");
//   }

//   // Method to start the progress indicator
//   void _startProgressIndicator() {
//     setState(() {
//       isProgressStarted = true; // Start showing the progress bar
//       _progressValue = 1.0;
//       _controllerConfetti.play(); // Set the initial value to 100%
//     });

//     // Smoothly update the progress bar every 100 milliseconds
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       setState(() {
//         _progressValue -= 0.02; // Decrement by a small amount for smoothness
//         if (_progressValue <= 0) {
//           _progressValue = 0.0;
//           timer.cancel();
//           String orderNumber =
//               postTransactionResponse != null ? postTransactionResponse!.guestCheck.checkNum.toString() : '1001';
//           AllServices().printOrderNumber(orderNumber);
//           _navigateToHome();
//         }
//       });
//     });
//   }

//   //   Navigate to home page
//   void _navigateToHome() {
//     Future.delayed(
//       const Duration(seconds: 2),
//       () {
//         theNewOrder = OrderModel.buildEmpty();
//         _dialogTimer?.cancel();
//         if (!mounted) return;
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const LandingPage(),
//           ),
//           (Route<dynamic> route) => false,
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _controllerConfetti.dispose();
//     _dialogTimer?.cancel();
//     if (_port != null) {
//       _port!.close();
//     }
//     super.dispose();
//   }

//   /// must binding ur printer at first init in app
//   Future<bool?> _bindingPrinter() async {
//     final bool? result = await SunmiPrinter.bindingPrinter();
//     return result;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: MyColors().white,
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Container(
//                   color: MyColors().white,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 170),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           height: 35,
//                           width: 40,
//                           color: MyColors().mainColor,
//                         ),
//                         Container(
//                           height: 35,
//                           width: 40,
//                           color: MyColors().mainColor,
//                         ),
//                         Container(
//                           height: 35,
//                           width: 40,
//                           color: MyColors().mainColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 // ..._devices.map((toElement) {
//                 //   return Text(toElement.deviceId.toString() +
//                 //       toElement.productName.toString() +
//                 //       toElement.pid.toString() +
//                 //       toElement.vid.toString());
//                 // }),
//                 Text(
//                   'YOU ARE ALMOST DONE',
//                   style: TextStyle(
//                     color: MyColors().black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 26,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 //==================== Custom Loading Animation ==================
//                 Center(
//                   child: SizedBox(
//                     height: 150,
//                     width: 150,
//                     child: AnimatedSwitcher(
//                       duration: const Duration(milliseconds: 700),
//                       transitionBuilder: (child, animation) {
//                         return ScaleTransition(
//                           scale: animation,
//                           child: child,
//                         );
//                       },
//                       child: isLoading
//                           ? RotationTransition(
//                               turns: _controller,
//                               child: LoadingAnimationWidget.hexagonDots(
//                                 color: MyColors().mainColor,
//                                 size: _kSize,
//                               ),
//                             )
//                           : const Icon(
//                               Icons.check_circle,
//                               key: ValueKey('done'),
//                               color: Colors.green,
//                               size: 80,
//                             ),
//                     ),
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     ConfettiWidget(
//                       confettiController: _controllerConfetti,
//                       blastDirection: -pi / 2,
//                       emissionFrequency: 0.05,
//                       gravity: 0.1,
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 isLoading
//                     ? Text(
//                         'PLEASE INSERT/TAP YOUR CARD IN PAYMENT DEVICE ',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: MyColors().blackish,
//                           fontSize: 18,
//                         ),
//                       )
//                     : Text(
//                         'Congratulation!',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: MyColors().blackish,
//                           fontSize: 18,
//                         ),
//                       ),
//                 isLoading
//                     ? Text(
//                         'PLACED IN RIGHT OF YOU',
//                         style: TextStyle(
//                           color: MyColors().blackish,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       )
//                     : Text(
//                         'Your order has been successfully completed!',
//                         style: TextStyle(
//                           color: MyColors().blackish,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),

//                 // const SizedBox(height: 20),

//                 isLoading
//                     ? Column(
//                         children: [
//                           Image.asset(
//                             'assets/images/payment_rule.gif',
//                             height: 250,
//                             width: 250,
//                           ),
//                           StatefulBuilder(
//                             builder: (BuildContext context, StateSetter setDialogState) {
//                               // Start the countdown timer only if it hasn't been started
//                               if (_dialogTimer == null || !_dialogTimer!.isActive) {
//                                 // Timer to update countdown
//                                 _dialogTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
//                                   // Check if the widget is still mounted before calling setState
//                                   if (mounted && _countdown > 0) {
//                                     setDialogState(() {
//                                       _countdown--;
//                                     });
//                                   } else {
//                                     // Close the dialog and stop the timer
//                                     timer.cancel();
//                                     _dialogTimer?.cancel();
//                                     paymentLog(theNewOrder);
//                                     Navigator.pop(context);
//                                     // clearOrderAndbackToWelcomePage(
//                                     //     context); // Call your custom function
//                                     // if (mounted && _isDialogVisible) {
//                                     //   setDialogState(() {
//                                     //     _isDialogVisible = false;
//                                     //   });

//                                     // }
//                                   }
//                                 });
//                               }

//                               return RichText(
//                                 text: TextSpan(
//                                   text: 'PLEASE COMPLETE YOUR PAYMENT WITH IN  ',
//                                   style: TextStyle(
//                                     color: MyColors().blackish,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.normal,
//                                   ),
//                                   children: <TextSpan>[
//                                     TextSpan(
//                                       text: '$_countdown SECOND',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         color: MyColors().mainColor,
//                                         fontSize: 18,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       )
//                     : const Text(''),
//                 const SizedBox(height: 10),

//                 isLoading
//                     ? Text(
//                         'PLEASE CLICK CANCEL ON THE PAYMENT DEVICE TO TARMINATE THE TRANSACTION',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: MyColors().blackish,
//                         ),
//                       )
//                     : const Text(''),

//                 if (!isLoading && isProgressStarted) ...[
//                   Text(
//                     'THANK YOU!',
//                     style: TextStyle(
//                       color: MyColors().black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 26,
//                     ),
//                   ),
//                   postTransactionResponse != null
//                       ? Text(
//                           '"Your order number is ${postTransactionResponse!.guestCheck.checkNum}. Please check the display',
//                           style: TextStyle(
//                             color: MyColors().blackish,
//                             fontSize: 20,
//                           ),
//                         )
//                       : Text(
//                           '"Your order number is 1001. Please check the display',
//                           style: TextStyle(
//                             color: MyColors().blackish,
//                             fontSize: 20,
//                           ),
//                         ),
//                   Text(
//                     'for updates."',
//                     style: TextStyle(
//                       color: MyColors().blackish,
//                       fontSize: 20,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     padding: const EdgeInsets.all(13),
//                     decoration: BoxDecoration(
//                         color: MyColors().white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: MyColors().mainColor)),
//                     height: 60,
//                     width: 150,
//                     child: Text(
//                       postTransactionResponse != null
//                           ? postTransactionResponse!.guestCheck.checkNum.toString()
//                           : '1001',
//                       style: TextStyle(
//                         fontSize: 25,
//                         fontWeight: FontWeight.bold,
//                         color: MyColors().mainColor,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ],
//             ),

//             // Bottom Section with dynamic color change
//             // Bottom Section with dynamic color change
//             Positioned(
//               bottom: 20,
//               left: 0,
//               child: SizedBox(
//                 height: 170,
//                 width: size.width,
//                 child: Stack(
//                   children: [
//                     CustomPaint(size: Size(size.width, 170), painter: ProgressCustomPainter(_progressValue)
//                         // BNBCustopPainter2(
//                         //     _progressValue), // Pass the progress value here
//                         ),
//                   ],
//                 ),
//               ),
//             ),

//             Positioned(
//               bottom: 0,
//               left: 0,
//               child: SizedBox(
//                 height: 170,
//                 width: size.width,
//                 child: Stack(
//                   children: [
//                     CustomPaint(
//                       size: Size(size.width, 170),
//                       painter: BNBCustopPainter(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             if (isProgressStarted) ...[
//               Positioned(
//                 bottom: 0,
//                 left: 1,
//                 child: Image.asset(
//                   'assets/images/printer-unscreen.gif',
//                   height: 100,
//                   width: 100,
//                 ),
//               ),
//             ],

//             Positioned(
//               bottom: 0,
//               right: 0,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                 decoration: BoxDecoration(
//                   color: MyColors().mainColor,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                   ),
//                 ),
//                 child: const Text(
//                   'Powered by: Transcom Technology',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _showMyDialog(
//       BuildContext context,
//       // UsbDevice toElement
//       String res) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button to close
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Alert!'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 // const Text('This is a Card alert dialog.'),
//                 Text(res),
//                 // ListTile(
//                 //     title: Text(toElement.productName.toString()),
//                 //     subtitle: Row(
//                 //       children: [
//                 //         Text("deviceId: ${toElement.deviceId.toString()}"),
//                 //         Text("pid: ${toElement.pid.toString()}"),
//                 //         Text("vid: ${toElement.vid.toString()}"),
//                 //       ],
//                 //     ))
//                 // ...cardMsg.map((toElement) {
//                 //   return ListTile(
//                 //       title: Text(toElement.productName.toString()),
//                 //       subtitle: Row(
//                 //         children: [
//                 //           Text("deviceId: ${toElement.deviceId.toString()}"),
//                 //           Text("pid: ${toElement.pid.toString()}"),
//                 //           Text("vid: ${toElement.vid.toString()}"),
//                 //         ],
//                 //       ));
//                 // })
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             // TextButton(
//             //   child: const Text('Cancel'),
//             //   onPressed: () {
//             //     Navigator.of(context).pop();
//             //     Navigator.of(context).pop();
//             //   },
//             // ),
//             TextButton(
//               child: const Text('Ok'),
//               onPressed: () {
//                 _dialogTimer?.cancel();
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 // Future.delayed(
//                 //   const Duration(seconds: 5),
//                 //   () {
//                 //     setState(
//                 //       () {
//                 //         isLoading = false; // End the loading animation
//                 //         _controller.stop();
//                 //         _controllerConfetti
//                 //             .stop(); // Stop the rotation of the animation
//                 //         _startProgressIndicator(); // Start progress indicator after loading
//                 //       },
//                 //     );
//                 //   },
//                 // );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
