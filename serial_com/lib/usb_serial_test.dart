// import 'dart:async';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:usb_serial/transaction.dart';
// import 'package:usb_serial/usb_serial.dart';

// class UsbSerialTest extends StatefulWidget {
//   const UsbSerialTest({super.key});

//   @override
//   State<UsbSerialTest> createState() => _UsbSerialTestState();
// }

// class _UsbSerialTestState extends State<UsbSerialTest> {
//   UsbPort? _port;
//   String _status = "Idle";
//   List<Widget> _ports = [];
//   final List<Widget> _serialData = [];
//   StreamSubscription<String>? _subscription;
//   Transaction<String>? _transaction;
//   UsbDevice? _device;
//   final TextEditingController _textController = TextEditingController();

//   Future<bool> _connectTo(UsbDevice? device) async {
//     _serialData.clear();

//     _subscription?.cancel();
//     _subscription = null;

//     _transaction?.dispose();
//     _transaction = null;

//     _port?.close();
//     _port = null;

//     if (device == null) {
//       _device = null;
//       setState(() => _status = "Disconnected");
//       return true;
//     }

//     _port = await device.create();
//     if (await _port!.open() != true) {
//       setState(() => _status = "Failed to open port");
//       return false;
//     }
//     _device = device;

//     await _port!.setDTR(true);
//     await _port!.setRTS(true);
//     await _port!.setPortParameters(
//         115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

//     _transaction = Transaction.stringTerminated(
//       _port!.inputStream as Stream<Uint8List>,
//       Uint8List.fromList([13, 10]),
//     );

//     _subscription = _transaction!.stream.listen((String line) {
//       setState(() {
//         _serialData.add(Text(line));
//         if (_serialData.length > 20) {
//           _serialData.removeAt(0);
//         }
//       });
//     });

//     setState(() => _status = "Connected");
//     return true;
//   }

//   void _getPorts() async {
//     _ports = [];
//     List<UsbDevice> devices = await UsbSerial.listDevices();
//     if (!devices.contains(_device)) {
//       _connectTo(null);
//     }
//     for (var device in devices) {
//       _ports.add(ListTile(
//         leading: const Icon(Icons.usb),
//         title: Text(device.productName!),
//         subtitle: Text(device.manufacturerName!),
//         trailing: ElevatedButton(
//           child: Text(_device == device ? "Disconnect" : "Connect"),
//           onPressed: () {
//             _connectTo(_device == device ? null : device)
//                 .then((_) => _getPorts());
//           },
//         ),
//       ));
//     }

//     setState(() {});
//   }

//   void _initializeUsbListener() {
//     UsbSerial.usbEventStream?.listen((_) => _getPorts());
//     _getPorts();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeUsbListener();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _connectTo(null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('USB Serial Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: <Widget>[
//               Text(
//                 _ports.isNotEmpty
//                     ? "Available Serial Ports"
//                     : "No serial devices available",
//                 style: Theme.of(context).textTheme.titleLarge,
//               ),
//               ..._ports,
//               Text('Status: $_status\n'),
//               Text('Info: ${_port.toString()}\n'),
//               ListTile(
//                 title: TextField(
//                   controller: _textController,
//                   decoration: const InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: 'Text To Send',
//                   ),
//                 ),
//                 trailing: ElevatedButton(
//                   onPressed: _port == null
//                       ? null
//                       : () async {
//                           String data = "${_textController.text}\r\n";
//                           await _port!
//                               .write(Uint8List.fromList(data.codeUnits));
//                           _textController.clear();
//                         },
//                   child: const Text("Send"),
//                 ),
//               ),
//               Text("Result Data",
//                   style: Theme.of(context).textTheme.titleLarge),
//               ..._serialData,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
