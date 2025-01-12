// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:usb_serial/usb_serial.dart';

// class USBCommunication extends StatefulWidget {
//   const USBCommunication({super.key});

//   @override
//   _USBCommunicationState createState() => _USBCommunicationState();
// }

// class _USBCommunicationState extends State<USBCommunication> {
//   List<UsbDevice> _devices = [];
//   UsbPort? _port;
//   UsbDevice? _selectedDevice;

//   @override
//   void initState() {
//     super.initState();
//     _initUSB();
//   }

//   // Initialize USB and list available devices
//   void _initUSB() async {
//     List<UsbDevice> devices = await UsbSerial.listDevices();
//     setState(() {
//       _devices = devices;
//     });
//   }

//   // Open the USB port of the selected device
//   Future<void> _openPort(UsbDevice device) async {
//     _selectedDevice = device;
//     _port = await device.create();
//     bool opened = await _port!.open();
//     if (opened) {
//       print("USB port opened successfully");
//       _sendData(); // Send data once the port is open
//     } else {
//       print("Failed to open USB port");
//     }
//   }

//   // Convert JSON string to hex string
//   String _jsonToHex(String jsonString) {
//     List<int> bytes = utf8.encode(jsonString);
//     return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join('');
//   }

//   // Send the JSON data as hex
//   void _sendData() async {
//     if (_port != null) {
//       // Example JSON data
//       var data = {
//         "SysTrace": "hsldks3478257",
//         "SysSN": "hsl864s3478257",
//         "TransType": "3",
//         "TransAmount": "1002"
//       };

//       // Convert JSON to string
//       String jsonData = json.encode(data);

//       // Convert to hexadecimal string (with padding 02 and 03)
//       String hexData = _jsonToHex(jsonData);
//       String dataToSend =
//           "02${hexData}03"; // Adding start (02) and end (03) padding

//       // Send the hex data as bytes over USB
//       List<int> bytes = _hexToBytes(dataToSend);
//       _port!.write(Uint8List.fromList(bytes));
//       print("Data sent (hex): $dataToSend");
//     }
//   }

//   // Convert hex string to bytes
//   List<int> _hexToBytes(String hex) {
//     List<int> bytes = [];
//     for (int i = 0; i < hex.length; i += 2) {
//       String hexPair = hex.substring(i, i + 2);
//       bytes.add(int.parse(hexPair, radix: 16));
//     }
//     return bytes;
//   }

//   // Close the port when done
//   void _closePort() {
//     if (_port != null) {
//       _port!.close();
//       print("USB port closed");
//     }
//   }

//   @override
//   void dispose() {
//     _closePort();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("USB Communication")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Display available devices
//             _devices.isEmpty
//                 ? const CircularProgressIndicator()
//                 : Expanded(
//                     child: ListView.builder(
//                       itemCount: _devices.length,
//                       itemBuilder: (context, index) {
//                         UsbDevice device = _devices[index];
//                         return ListTile(
//                           title: Text(
//                               'Device: ${device.deviceName} (VID: ${device.pid}, PID: ${device.deviceId})'),
//                           onTap: () {
//                             _openPort(device); // Connect to selected device
//                           },
//                         );
//                       },
//                     ),
//                   ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _devices.isEmpty
//                   ? null
//                   : _sendData, // Button disabled if no devices
//               child: const Text('Send Data over USB'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
