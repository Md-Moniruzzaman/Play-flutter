import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';

class SerialComWizarCardReaderWithPackage extends StatefulWidget {
  const SerialComWizarCardReaderWithPackage({super.key});

  @override
  State<SerialComWizarCardReaderWithPackage> createState() => _SerialComWizarCardReaderWithPackageState();
}

class _SerialComWizarCardReaderWithPackageState extends State<SerialComWizarCardReaderWithPackage> {
  UsbPort? _port;
  StreamSubscription<Uint8List>? _subscription;
  List<UsbDevice> _devices = [];
  UsbDevice? _selectedDevice;
  final TextEditingController _sysTraceController = TextEditingController(text: 'hsldks3478257');
  final TextEditingController _sysSNController = TextEditingController(text: 'hsl864s3478257');
  final TextEditingController _transTypeController = TextEditingController(text: '3');
  final TextEditingController _transAmountController = TextEditingController(text: '10000');
  final TextEditingController _portController = TextEditingController();
  // final TextEditingController _portControllerP = TextEditingController();
  // final TextEditingController _portControllersetPort = TextEditingController();
  String _receivedData = "";
  // String _sendDataHex = "";
  // String _sendDataBytes = "";
  String _byteData = "";
  String resposneString = "";

  @override
  void initState() {
    super.initState();
    _getDevices();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _port?.close();
    _sysSNController.dispose();
    _sysTraceController.dispose();
    _transTypeController.dispose();
    _transAmountController.dispose();
    super.dispose();
  }

  Future<void> _getDevices() async {
    _devices = await UsbSerial.listDevices();
    print("Available devices: $_devices");
    setState(() {});
  }

  Future<void> _connectDevice() async {
    setState(() {
      _portController.text = 'connectiondevice called.';
    });

    if (_selectedDevice != null) {
      setState(() {
        _portController.text = 'device selected.';
      });

      try {
        _port = await _selectedDevice!.create();

        if (_port != null) {
          // Attempt to open the port
          bool isPortOpen = await _port!.open();
          if (isPortOpen) {
            setState(() {
              _portController.text = 'Port opened successfully.';
            });
            await _port!.setDTR(true);
            await _port!.setRTS(true);
            // Set port parameters if opened successfully
            _port!.setPortParameters(115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

            // Start listening for data
            _listenForData();
          } else {
            setState(() {
              _portController.text = 'Failed to open port.';
            });
          }
        } else {
          setState(() {
            _portController.text = 'Port is null, device not connected properly.';
          });
        }
      } catch (e) {
        setState(() {
          _portController.text = 'Error: $e';
        });
      }
    } else {
      setState(() {
        _portController.text = 'No device selected.';
      });
    }
  }

  // void _listenForData() {
  //   _subscription = _port!.inputStream!.listen((Uint8List data) {
  //     final hexString =
  //         data.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  //     setState(() {
  //       _receivedData = hexString;
  //       _byteData = data.toString();

  //       // Convert the Uint8List to a string
  //       try {
  //         resposneString =
  //             utf8.decode(data); // Decode the byte data to a string
  //       } catch (e) {
  //         resposneString = 'Error decoding data: $e';
  //       }
  //     });
  //     _sendAck(); // Send ACK (0x06) after receiving data
  //   });
  // }

  void _listenForData() {
    List<int> buffer = [];
    var recHex = '';
    var jsnoString = '';
    var byteData = '';

    _subscription = _port!.inputStream!.listen((Uint8List data) {
      buffer.addAll(data); // Add incoming data to the buffer
      byteData = buffer.toString();

      // Check if the first byte received is ACK (0x06)
      if (buffer.isNotEmpty && buffer.first == 0x06) {
        print("Received ACK (0x06) from device");
        final hexString = buffer.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
        recHex = hexString;
        setState(() {
          _receivedData = recHex;
          _byteData = byteData;
          resposneString = jsnoString;
        });
        buffer.removeAt(0); // Remove the ACK from the buffer
        return; // Exit early as we only need to process the ACK
      }
      // Check if we have enough data to process (STX + 2 bytes for length + data + ETX)
      while (buffer.length >= 4) {
        // Find the start (STX) and end (ETX) markers
        int startIdx = buffer.indexOf(0x02); // Find STX (0x02)
        int endIdx = buffer.indexOf(0x03); // Find ETX (0x03)

        if (startIdx != -1 && endIdx != -1 && endIdx > startIdx) {
          // Extract the data length (2 bytes after STX)
          final lengthBytes = buffer.sublist(startIdx + 1, startIdx + 3);
          final dataLength = (lengthBytes[0] << 8) | lengthBytes[1];

          // Ensure that the full data (length + ETX) is available
          if (buffer.length >= startIdx + 3 + dataLength + 1) {
            final completeMessage = buffer.sublist(startIdx + 3, startIdx + 3 + dataLength);

            // Convert the message to a hex string (for debugging)
            final hexString = completeMessage.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
            recHex = hexString;
            // Decode the extracted data to UTF-8 (JSON string)
            String utf8String;
            try {
              utf8String = utf8.decode(completeMessage, allowMalformed: true);
            } catch (e) {
              utf8String = 'Error decoding data: $e';
            }

            // Print the hex and decoded UTF-8 message
            print('Hex String: $hexString');
            print('Decoded String: $utf8String');

            // Parse JSON message if valid
            try {
              final Map<String, dynamic> jsonMessage = json.decode(utf8String);
              print('Decoded JSON: $jsonMessage');
              jsnoString = jsonMessage.toString();
              // You can add further logic to handle the parsed JSON
            } catch (e) {
              print('Error parsing JSON: $e');
            }

            // Remove processed data from the buffer
            buffer.removeRange(0, startIdx + 3 + dataLength + 1);
          }
        } else {
          // If no complete message is found, break and wait for more data
          break;
        }
      }

      setState(() {
        _receivedData = recHex;
        _byteData = byteData;
        resposneString = jsnoString;
      });
    });
  }

  Future<void> _sendAck() async {
    await _port!.write(Uint8List.fromList([0x06])); // Send ACK
  }

  Future<void> _sendRequest() async {
    // JSON data to be sent
    final requestData = {
      "SysTrace": _sysTraceController.text,
      "SysSN": _sysSNController.text,
      "TransType": "3",
      "TransAmount": _transAmountController.text,
    };

    // Encode JSON data to bytes
    final dataBytes = utf8.encode(json.encode(requestData));
    final dataLength = dataBytes.length;

    // Calculate length in high and low bytes
    final lengthHigh = (dataLength >> 8) & 0xFF;
    final lengthLow = dataLength & 0xFF;

    // Construct the message
    final message = <int>[
      0x02, // STX
      lengthHigh,
      lengthLow,
      ...dataBytes,
      0x03, // ETX
    ];

    // Convert to Uint8List for transmission
    final messageBytes = Uint8List.fromList(message);

    await _port!.write(messageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serial Communication Demo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<UsbDevice>(
                hint: const Text("Select Device"),
                value: _selectedDevice,
                items: _devices.map((device) {
                  return DropdownMenuItem<UsbDevice>(
                    value: device,
                    child: Text(device.productName ?? "Unknown Device"),
                  );
                }).toList(),
                onChanged: (UsbDevice? device) {
                  setState(() {
                    _selectedDevice = device;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _connectDevice,
                child: const Text("Connect to Device"),
              ),
              TextField(
                controller: _portController,
                decoration: const InputDecoration(labelText: "PortStatus"),
              ),
              const SizedBox(height: 20),
              // TextField(
              //   controller: _portControllerP,
              //   decoration: const InputDecoration(labelText: "Port"),
              // ),
              // const SizedBox(height: 20),
              // TextField(
              //   controller: _portControllersetPort,
              //   decoration: const InputDecoration(labelText: "Port Set params"),
              // ),
              // const SizedBox(height: 20),
              TextField(
                controller: _sysTraceController,
                decoration: const InputDecoration(labelText: "SysTrace"),
              ),
              TextField(
                controller: _sysSNController,
                decoration: const InputDecoration(labelText: "SysSN"),
              ),
              TextField(
                controller: _transTypeController,
                decoration: const InputDecoration(labelText: "TransType"),
              ),
              TextField(
                controller: _transAmountController,
                decoration: const InputDecoration(labelText: "TransAmount"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendRequest,
                child: const Text("Send Request"),
              ),
              // const SizedBox(height: 10),
              // const Text(
              //   "Send Data (Hex):",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 10),
              // Text(_sendDataHex),
              // const SizedBox(height: 10),
              // const Text(
              //   "Send Data (bytes):",
              //   style: TextStyle(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 10),
              // Text(_sendDataBytes),
              const SizedBox(height: 20),
              const Text(
                "Received Data (Hex):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_receivedData),
              const SizedBox(height: 20),
              const Text(
                "Received Data (Bytes):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_byteData),
              const SizedBox(height: 20),
              const Text(
                "Resposne String:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(resposneString),
            ],
          ),
        ),
      ),
    );
  }
}
