// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_libserialport/flutter_libserialport.dart';

// class InitUsb extends StatefulWidget {
//   const InitUsb({super.key});

//   @override
//   State<InitUsb> createState() => _InitUsbState();
// }

// class _InitUsbState extends State<InitUsb> {
//   final TextEditingController _sysTraceController = TextEditingController(text: 'hsldks3478257');
//   final TextEditingController _sysSNController = TextEditingController(text: 'hsl864s3478257');
//   final TextEditingController _transTypeController = TextEditingController(text: '3');
//   final TextEditingController _transAmountController = TextEditingController(text: '10000');
//   List availablePorts = [];
//   late SerialPort port;
//   String? selectedPort;
//   String logOutput = "";
//   String receivedData = "";

//   @override
//   void initState() {
//     super.initState();
//     initPorts();
//   }

//   void initPorts() {
//     setState(() => availablePorts = SerialPort.availablePorts);
//     logOutput += "Available ports: $availablePorts\n";
//     print(logOutput);
//     if (availablePorts.isNotEmpty) {
//       selectedPort = availablePorts[0];
//       print(selectedPort);
//     }
//   }

//   Future<void> _connectDevice() async {
//     if (selectedPort == null) {
//       logOutput += "No port selected.\n";
//       print(logOutput);
//       setState(() {});
//       return;
//     }

//     port = SerialPort(selectedPort!);
//     // print(port.isOpen);
//     // Configure the port
//     port.config = SerialPortConfig()
//       ..baudRate = 115200
//       ..bits = 8
//       ..stopBits = 1
//       ..parity = SerialPortParity.none
//       ..rts = SerialPortRts.on
//       ..dtr = SerialPortDtr.on;

//     if (!port.openReadWrite()) {
//       logOutput += "Failed to open port $selectedPort\n";
//       setState(() {});
//       return;
//     }

//     logOutput += "Opened port $selectedPort\n";
//     print(port.isOpen);
//     // SerialPortReader for incoming data
//     SerialPortReader reader = SerialPortReader(port, timeout: 1000000);
//     reader.stream.listen((data) {
//       print(data);
//       logOutput += "Received data: ${String.fromCharCodes(data)}\n";
//       receivedData = String.fromCharCodes(data);
//       print(receivedData);
//       setState(() {});
//     });
//     // baudRate = 115200
//   }

//   void sendData() {
//     // if (selectedPort == null) {
//     //   logOutput += "No port selected.\n";
//     //   setState(() {});
//     //   return;
//     // }

//     // port = SerialPort(selectedPort!);
//     // if (!port.openReadWrite()) {
//     //   logOutput += "Failed to open port $selectedPort\n";
//     //   setState(() {});
//     //   return;
//     // }

//     // logOutput += "Opened port $selectedPort\n";

//     // // SerialPortReader for incoming data
//     // SerialPortReader reader = SerialPortReader(port, timeout: 10000);
//     // reader.stream.listen((data) {
//     //   logOutput += "Received data: ${String.fromCharCodes(data)}\n";
//     //   setState(() {});
//     // });

//     // // Configure the port
//     // port.config = SerialPortConfig()
//     //   ..baudRate = 115200
//     //   ..bits = 8
//     //   ..stopBits = 1
//     //   ..parity = SerialPortParity.none
//     //   ..rts = SerialPortRts.on
//     //   ..dtr = SerialPortDtr.on;

//     // JSON data to be sent
//     final requestData = {
//       "SysTrace": _sysTraceController.text,
//       "SysSN": _sysSNController.text,
//       "TransType": "3",
//       "TransAmount": _transAmountController.text,
//     };

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

//     // Convert to Uint8List for transmission
//     final messageBytes = Uint8List.fromList(message);

//     // Write the message to the port
//     port.write(messageBytes, timeout: 300);

//     // logOutput +=
//     //     "Data sent: ${messageBytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}\n";

//     setState(() {});
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     port.close();
//     _sysSNController.dispose();
//     _sysTraceController.dispose();
//     _transTypeController.dispose();
//     _transAmountController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("USB Communication"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButton<String>(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               value: selectedPort,
//               hint: const Text("Select Port"),
//               items: availablePorts
//                   .map<DropdownMenuItem<String>>((port) => DropdownMenuItem<String>(
//                         value: port,
//                         child: Text(port),
//                       ))
//                   .toList(),
//               onChanged: (value) {
//                 setState(() {
//                   selectedPort = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     port.close();
//                   },
//                   child: const Text("Disconnect Device"),
//                 ),
//                 ElevatedButton(
//                   onPressed: _connectDevice,
//                   child: const Text("Connect to Device"),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _sysTraceController,
//               decoration: const InputDecoration(labelText: 'SysTrace'),
//             ),
//             TextField(
//               controller: _sysSNController,
//               decoration: const InputDecoration(labelText: 'SysSN'),
//             ),
//             TextField(
//               controller: _transTypeController,
//               decoration: const InputDecoration(labelText: 'TransType'),
//             ),
//             TextField(
//               controller: _transAmountController,
//               decoration: const InputDecoration(labelText: 'TransAmount'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: sendData,
//               child: const Text("Send Data"),
//             ),
//             const SizedBox(height: 16),
//             const Text("Received Response:"),
//             Text(
//               receivedData,
//               style: const TextStyle(fontFamily: "monospace"),
//             ),
//             const SizedBox(height: 16),
//             const Text("Log Output:"),
//             // Expanded(
//             //   child: SingleChildScrollView(
//             //     child: Text(
//             //       logOutput,
//             //       style: const TextStyle(fontFamily: "monospace"),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
