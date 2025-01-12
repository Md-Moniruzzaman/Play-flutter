// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:usb_serial/transaction.dart';
// import 'package:usb_serial/usb_serial.dart';

// class UsbBidirectionalApp extends StatefulWidget {
//   const UsbBidirectionalApp({super.key});
//   @override
//   State<UsbBidirectionalApp> createState() => _UsbBidirectionalAppState();
// }

// class _UsbBidirectionalAppState extends State<UsbBidirectionalApp> {
//   UsbPort? _port;
//   String _status = "Idle";
//   final List<Widget> _messages = [];
//   StreamSubscription<String>? _subscription;
//   Transaction<String>? _transaction;
//   UsbDevice? _device;
//   final TextEditingController _textController = TextEditingController();

//   Future<void> _initializeConnection() async {
//     List<UsbDevice> devices = await UsbSerial.listDevices();
//     print('hello payment gateway');
//     if (devices.isNotEmpty) {
//       // Attempt connection with the first available device
//       for (var device in devices) {
//         print(device);
//       }
//       await _connectTo(devices.first);
//     }
//   }

//   Future<bool> _connectTo(UsbDevice device) async {
//     // Clean up any previous connections
//     _subscription?.cancel();
//     _transaction?.dispose();
//     _port?.close();

//     _port = await device.create();
//     if (await _port!.open() != true) {
//       setState(() => _status = "Failed to open port");
//       return false;
//     }

//     await _port!.setDTR(true);
//     await _port!.setRTS(true);
//     await _port!.setPortParameters(
//         115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

//     // Initialize a transaction to handle incoming data
//     _transaction = Transaction.stringTerminated(
//       _port!.inputStream as Stream<Uint8List>,
//       Uint8List.fromList([13, 10]), // Using \r\n as the end-of-line sequence
//     );

//     // Listen for incoming messages
//     _subscription = _transaction!.stream.listen((data) {
//       setState(() {
//         _messages.add(Text("Received: $data"));
//         if (_messages.length > 50) {
//           _messages.removeAt(0); // Keep latest 50 messages
//         }
//       });
//     });

//     setState(() => _status = "Connected to ${device.productName}");
//     return true;
//   }

//   void _sendData(String message) async {
//     if (_port != null) {
//       await _port!.write(Uint8List.fromList("$message\r\n".codeUnits));
//       setState(() {
//         _messages
//             .add(Text("Sent: $message", style: const TextStyle(color: Colors.blue)));
//       });
//     } else {
//       setState(() => _status = "Not connected to any device");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeConnection();
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     _transaction?.dispose();
//     _port?.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Bidirectional USB Communication')),
//         body: Column(
//           children: [
//             TextField(
//               controller: _textController,
//               decoration: const InputDecoration(
//                 labelText: 'Message to Send',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _sendData(_textController.text);
//                 _textController.clear();
//               },
//               child: const Text("Send"),
//             ),
//             Text('Status: $_status'),
//             Expanded(
//               child: ListView(children: _messages),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
