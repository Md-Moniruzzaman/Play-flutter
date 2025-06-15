import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:serial_com/package/payment_pos_serial_com_package.dart';
import 'package:usb_serial/usb_serial.dart';

class SerialComWizarCardReaderWithPackage extends StatefulWidget {
  const SerialComWizarCardReaderWithPackage({super.key});

  @override
  State<SerialComWizarCardReaderWithPackage> createState() => _SerialComWizarCardReaderWithPackageState();
}

class _SerialComWizarCardReaderWithPackageState extends State<SerialComWizarCardReaderWithPackage> {
  final TextEditingController _sysTraceController = TextEditingController(text: 'hsldks3478257');
  final TextEditingController _sysSNController = TextEditingController(text: 'hsl864s3478257');
  final TextEditingController _transTypeController = TextEditingController(text: '3');
  final TextEditingController _transAmountController = TextEditingController(text: '10000');
  final TextEditingController _portController = TextEditingController();
  // final TextEditingController _portControllerP = TextEditingController();
  // final TextEditingController _portControllersetPort = TextEditingController();

  UsbPort? _port;
  StreamSubscription<Uint8List>? _subscription;
  final PaymentPosWizarCardReaderSerialCommunitaion _paymentPos = PaymentPosWizarCardReaderSerialCommunitaion();

  String _receivedData = "";

  String resposneString = "";

  @override
  void initState() {
    super.initState();
    _deviceInitilize();
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

  Future<void> _deviceInitilize() async {
    try {
      // Initialize the USB serial communication
      String pID = '8963'; // Replace with your device's PID
      String vID = '1659'; // Replace with your device's VID
      _paymentPos.getDevice(pID, vID).then((UsbDevice? device) {
        if (device != null) {
          _portController.text = 'Device found: ${device.productName}';
          _paymentPos.connectDevice(device, 115200).then((UsbPort? port) {
            if (port != null) {
              _port = port;
              _portController.text = 'Port opened successfully: $port';
              setState(() {});
              // Start listening for data
              _listenForData(port);
            } else {
              _portController.text = 'Failed to open port.';
            }
          });
        } else {
          _portController.text = 'No device found with PID: $pID and VID: $vID';
        }
      });
    } catch (e) {
      print("Error initializing USB serial: $e");
    }
  }

  void _listenForData(UsbPort port) {
    List<int> buffer = [];

    port.inputStream!.listen((Uint8List data) {
      buffer.addAll(data); // Add incoming data to the buffer

      final retData = _paymentPos.getJsonData(buffer);
      if (retData != {} && retData.isNotEmpty) {
        _receivedData = retData.toString();
        setState(() {});
        _paymentPos.sendAck(0x06).then((value) {
          print("ACK sent");
        });
      } else {
        // If we don't have a complete JSON object, continue accumulating data
        _receivedData = "Waiting for complete data...";
        setState(() {});
        // recHex = buffer.map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ');
        // byteData = buffer.map((e) => e.toString()).join(' ');
      }
    });
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
              TextField(
                controller: _portController,
                decoration: const InputDecoration(labelText: "PortStatus"),
              ),
              const SizedBox(height: 20),
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
                onPressed: () {
                  _paymentPos.sendRequest(
                    _sysTraceController.text,
                    _sysSNController.text,
                    _transTypeController.text,
                    double.parse(_transAmountController.text),
                  );
                },
                child: const Text("Send Request"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Received Data:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_receivedData),
            ],
          ),
        ),
      ),
    );
  }
}
