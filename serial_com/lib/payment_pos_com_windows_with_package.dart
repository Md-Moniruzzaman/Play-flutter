import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:serial_com/package/payment_pos_serial_com_package_win.dart';

class PymentPostComWinWithPackage extends StatefulWidget {
  const PymentPostComWinWithPackage({super.key});

  @override
  State<PymentPostComWinWithPackage> createState() => _PymentPostComWinWithPackageState();
}

class _PymentPostComWinWithPackageState extends State<PymentPostComWinWithPackage> {
  final TextEditingController _sysTraceController = TextEditingController(text: 'hsldks3478257');
  final TextEditingController _sysSNController = TextEditingController(text: 'hsl864s3478257');
  final TextEditingController _transTypeController = TextEditingController(text: '3');
  final TextEditingController _transAmountController = TextEditingController(text: '10000');
  List availablePorts = [];
  StreamSubscription<Uint8List>? _subscription;
  SerialPortReader? _reader; // Use SerialPortReader for reading data
  SerialPort? port;
  String? selectedPort;
  String logOutput = "";
  String receivedData = "";

  @override
  void initState() {
    super.initState();
    initPorts();
  }

  void initPorts() {
    setState(() => availablePorts = WinPaymentPosSerialCommunitaion.getPorts());
    logOutput += "Available ports: $availablePorts\n";
    print(logOutput);
    if (availablePorts.isNotEmpty) {
      selectedPort = availablePorts[0];
      print(selectedPort);
    }
  }

  Future<void> _connectDevice() async {
    if (selectedPort == null) {
      logOutput += "No port selected.\n";
      setState(() {});
      return;
    }

    WinPaymentPosSerialCommunitaion().disconnectDevice(port);
    // Close previous connection if any
    // port?.close();
    logOutput += "Previous connection closed.\n";
    port = await WinPaymentPosSerialCommunitaion().connectDevice(selectedPort, 115200);
    setState(() {
      logOutput += "Connecting to $selectedPort... ${port!.isOpen}\n";
    });
    // port = SerialPort(selectedPort!);

    // port!.config = SerialPortConfig()
    //   ..baudRate = 115200
    //   ..bits = 8
    //   ..stopBits = 1
    //   ..parity = SerialPortParity.none
    //   ..rts = SerialPortRts.on
    //   ..dtr = SerialPortDtr.on;

    // if (!port!.openReadWrite()) {
    //   logOutput += "Failed to open port $selectedPort. Error: ${SerialPort.lastError}\n";
    //   setState(() {});
    //   return;
    // }

    // print(port!.isOpen);

    logOutput += "Opened port $selectedPort\n";

    WinPaymentPosSerialCommunitaion().listenForData(port).then((value) {
      logOutput += "Listening for data...\n";
      setState(() {});
    }).catchError((error) {
      logOutput += "Error: $error\n";
      setState(() {});
    });

    // _reader = SerialPortReader(port!);
    // _listenForData();
    // _reader!.stream.listen((data) {
    //   receivedData = String.fromCharCodes(data);
    //   logOutput += "Received: $receivedData\n";
    // });

    setState(() {});
  }

  // void _listenForData() {
  //   if (port == null || !port!.isOpen) {
  //     logOutput += "Error: Serial port is not open.\n";
  //     setState(() {});
  //     return;
  //   }

  //   List<int> buffer = [];
  //   String recHex = '';
  //   String jsonString = '';
  //   String byteData = '';
  //   Map<String, dynamic> cardRes = {};

  //   _subscription = _reader!.stream.listen((Uint8List data) {
  //     buffer.addAll(data); // Add incoming data to the buffer
  //     byteData = buffer.toString();
  //     receivedData = String.fromCharCodes(data);

  //     if (buffer.isNotEmpty && buffer.first == 0x06) {
  //       print("Received ACK (0x06) from device");
  //       recHex = buffer.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  //       buffer.removeAt(0); // Remove the ACK from the buffer
  //       return; // Exit early as we only need to process the ACK
  //     }

  //     while (buffer.length >= 4) {
  //       int startIdx = buffer.indexOf(0x02); // Find STX (0x02)
  //       int endIdx = buffer.indexOf(0x03); // Find ETX (0x03)

  //       if (startIdx != -1 && endIdx != -1 && endIdx > startIdx) {
  //         final lengthBytes = buffer.sublist(startIdx + 1, startIdx + 3);
  //         final dataLength = (lengthBytes[0] << 8) | lengthBytes[1];

  //         if (buffer.length >= startIdx + 3 + dataLength + 1) {
  //           final completeMessage = buffer.sublist(startIdx + 3, startIdx + 3 + dataLength);
  //           final hexString = completeMessage.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  //           recHex = hexString;

  //           try {
  //             jsonString = utf8.decode(completeMessage, allowMalformed: true);
  //             final Map<String, dynamic> jsonMessage = json.decode(jsonString);
  //             print('Decoded JSON: $jsonMessage');
  //             cardRes = jsonMessage;
  //             receivedData += jsonString;
  //             print(jsonString);
  //             setState(() {});

  //             /// Check Amount

  //             if (cardRes['RespCode'] == "00") {
  //               _sendAck();
  //               setState(() {});
  //             } else {
  //               _sendAck();

  //               setState(() {});
  //             }
  //             setState(() {});
  //           } catch (e) {
  //             print('Error parsing JSON: $e');
  //           }

  //           buffer.removeRange(0, startIdx + 3 + dataLength + 1);
  //         }
  //       } else {
  //         break; // Wait for more data
  //       }
  //     }
  //   }, onError: (error) {
  //     print("Error in serial port listener: $error");
  //   }, onDone: () {
  //     print("Serial port listener closed.");
  //   });
  // }

  Future<void> _sendAck() async {
    port!.write(Uint8List.fromList([0x06])); // Send ACK
  }

  void sendData() {
    if (port!.isOpen == false) {
      logOutput += "Port is not open. Cannot send data.\n";
      setState(() {});
      return;
    }

    try {
      // JSON data to be sent
      final Map<String, dynamic> requestData = {
        "SysTrace": _sysTraceController.text,
        "SysSN": _sysSNController.text,
        "TransType": _transTypeController.text,
        "TransAmount": _transAmountController.text
      };

      // final Map<String, dynamic> requestData = {
      //   "SysTrace": _sysTraceController.text,
      //   "SysSN": _sysSNController.text,
      //   "TransType": _transTypeController.text,
      //   "TransAmount": _transAmountController.text,
      //   "PhoneNum": "01645820113"
      // };

      // Encode JSON data to bytes
      final Uint8List dataBytes = utf8.encode(json.encode(requestData));
      final int dataLength = dataBytes.length;

      // Calculate length in high and low bytes
      final int lengthHigh = (dataLength >> 8) & 0xFF;
      final int lengthLow = dataLength & 0xFF;

      // Construct the message (STX, Length, Data, ETX)
      final message = <int>[
        0x02, // STX
        lengthHigh,
        lengthLow,
        ...dataBytes,
        0x03, // ETX
      ];

      final messageBytes = Uint8List.fromList(message);

      // Convert message to hex for logging/debugging
      final String hexString = messageBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
      logOutput += "Sending: $hexString\n";

      print(messageBytes);
      print(hexString);

      // Send data to the serial port
      port!.write(messageBytes);
      logOutput += "Data sent successfully.\n";
    } catch (e) {
      logOutput += "Error sending data: $e\n";
    }

    setState(() {});
  }

  @override
  void dispose() {
    if (port!.isOpen) {
      port!.close();
    }
    _sysTraceController.dispose();
    _sysSNController.dispose();
    _transTypeController.dispose();
    _transAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("USB Communication"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              value: selectedPort,
              hint: const Text("Select Port"),
              items: availablePorts
                  .map<DropdownMenuItem<String>>((port) => DropdownMenuItem<String>(
                        value: port,
                        child: Text(port),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPort = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    port!.close();
                  },
                  child: const Text("Disconnect Device"),
                ),
                ElevatedButton(
                  onPressed: _connectDevice,
                  child: const Text("Connect to Device"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _sysTraceController,
              decoration: const InputDecoration(labelText: 'SysTrace'),
            ),
            TextField(
              controller: _sysSNController,
              decoration: const InputDecoration(labelText: 'SysSN'),
            ),
            TextField(
              controller: _transTypeController,
              decoration: const InputDecoration(labelText: 'TransType'),
            ),
            TextField(
              controller: _transAmountController,
              decoration: const InputDecoration(labelText: 'TransAmount'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // onPressed: () {
              //   WinPaymentPosSerialCommunitaion()
              //       .sendRequest(port, "hsldks3478257", "hsl864s3478257", "01645820113", 100.00);
              // },

              onPressed: sendData,
              child: const Text("Send Data"),
            ),
            const SizedBox(height: 16),
            const Text("Received Response:"),
            Text(
              receivedData,
              style: const TextStyle(fontFamily: "monospace"),
            ),
            const SizedBox(height: 16),
            const Text("Log Output:"),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  logOutput,
                  style: const TextStyle(fontFamily: "monospace"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
