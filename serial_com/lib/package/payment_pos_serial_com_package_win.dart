import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class WinPaymentPosSerialCommunitaion {
  SerialPort? _port;
  StreamSubscription<Uint8List>? _subscription; // Declare the subscription variable
  SerialPortReader? _reader; // Use SerialPortReader for reading data
  // // Get the device
  // Future<UsbDevice?> getDevice(String pID, String vID) async {
  //   // UsbDevice? _usbDevice;
  //   List<UsbDevice> _devices = await UsbSerial.listDevices();
  //   for (var device in _devices) {
  //     if (device.pid.toString() == pID && device.vid.toString() == vID) {
  //       // _showMyDialog(context, ele);
  //       return device;
  //     }
  //   }
  //   return null;
  // }

  static getPorts() {
    return SerialPort.availablePorts;
  }

  static getDeviceInfo() {}
  static getDeviceStatus() {}

  // Function to connect to the device
  // This function takes the selected port and baud rate as parameters
  Future<SerialPort?> connectDevice(String? selectedPort, int baudRate) async {
    if (selectedPort != null) {
      try {
        _port = SerialPort(selectedPort);

        if (_port != null) {
          final config = _port!.config;
          config.baudRate = baudRate; // use passed baudRate
          config.bits = 8;
          config.stopBits = 1;
          config.parity = SerialPortParity.none;
          config.rts = SerialPortRts.on;
          config.dtr = SerialPortDtr.on;

          _port!.config = config;

          // 👇 Open the port for write or read/write
          if (_port!.openReadWrite()) {
            print("✅ Port opened: ${_port!.isOpen}");
            return _port;
          } else {
            print("❌ Failed to open port: ${SerialPort.lastError}");
          }
        } else {
          print('Failed to create port.');
        }
      } catch (e) {
        print('❌ Error connecting to device: $e');
      }
    } else {
      print('⚠️ Device not found.');
    }

    return null;
  }

  // Function to disconnect the device
  // This function closes the port and sets it to null
  disconnectDevice(SerialPort? port) async {
    print(port?.isOpen);
    // Close the port if it was opened successfully
    port?.close();
    port = null; // Set the port to null after closing it
  }

  // Function to send a request to the device
  // This function sends a request to the device using the provided parameters
  Future<void> sendRequest(SerialPort? port, String sysTrace, String sysSN, String cusPhoneNo, double amount) async {
    final String orderAmountStr = amount.toStringAsFixed(2); // Make sure always have 2 decimal point in Order Amount

    final String removedDecPointFromOrderAmount =
        orderAmountStr.replaceAll('.', ''); // Remove decimal point from Amount for Card transaction

    // JSON data to be sent
    Map<String, String> requestData = {
      "SysTrace": sysTrace,
      "SysSN": sysSN,
      "TransType": "3",
      "TransAmount": removedDecPointFromOrderAmount
    };

    // "PhoneNum": cusPhoneNo,
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
    final hexString = message.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    // print('Hex String: $hexString');
    // Convert to Uint8List for transmission
    final messageBytes = Uint8List.fromList(message);

    port!.write(messageBytes);
  }

  Future senAck(SerialPort? port) async {
    // Send an acknowledgment byte (0x06) to the device
    // This is just an example; you can modify it based on your protocol
    port!.write(Uint8List.fromList([0x06]));
  }

  Future<Map<dynamic, dynamic>> listenForData(SerialPort? port) async {
    List<int> buffer = [];
    Map<dynamic, dynamic> returnData = {};
    _reader = SerialPortReader(port!);
    _subscription = _reader!.stream.listen((Uint8List data) {
      buffer.addAll(data); // Add incoming data to the buffer

      // Check if the first byte received is ACK (0x06)
      // If so, remove it from the buffer and print a message
      // This is optional and depends on your protocol
      if (buffer.isNotEmpty && buffer.first == 0x06) {
        final hexString = buffer.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
        buffer.removeAt(0); // Remove the ACK from the buffer
        returnData = {"ack": hexString}; // Exit early as we only need to process the ACK
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

            // Decode the extracted data to UTF-8 (JSON string)
            String utf8String;
            try {
              utf8String = utf8.decode(completeMessage, allowMalformed: true);
            } catch (e) {
              utf8String = 'Error decoding data: $e';
            }

            // Print the hex and decoded UTF-8 message
            // print('Hex String: $hexString');
            // print('Decoded String: $utf8String');

            // Parse JSON message if valid
            try {
              final Map<String, dynamic> jsonMessage = json.decode(utf8String);
              // print('Decoded JSON: $jsonMessage');
              returnData = jsonMessage; // Store the parsed JSON message
              // Remove processed data from the buffer
              buffer.removeRange(0, startIdx + 3 + dataLength + 1);
              // Process the JSON message as needed
              // For example, you can store it in a variable or call a callback function
              // return jsonMessage;
            } catch (e) {
              // Remove processed data from the buffer
              buffer.removeRange(0, startIdx + 3 + dataLength + 1);
              returnData = {"Error parsing JSON": e.toString()};
              // Handle JSON parsing error
              // return 'Error parsing JSON: $e';
            }
          }
        } else {
          // If no complete message is found, break and wait for more data
          break;
        }
      }
      // return 'No complete message found.';
    }, onError: (error) {
      // Handle any errors that occur during data reception
      // print('Error receiving data: $error');
      returnData = {"Error receiving data": error.toString()};
      // Optionally, you can cancel the subscription here if needed
      return returnData;
    }, onDone: () {
      // Handle the stream being closed
      // print('Data stream closed.');
      // _subscription?.cancel(); // Cancel the subscription when done
      // return 'Data stream closed.';
    }, cancelOnError: true); // Cancel the subscription on error
    return returnData;
  }

  // Function to process the received JSON data
  // This function is a placeholder for processing the received JSON data
  Map<String, dynamic> getJsonData(List<int> byteBuffer) {
    // This function is a placeholder for processing the received JSON data
    // You can modify it based on your specific requirements
    // Check if the first byte received is ACK (0x06)
    // If so, remove it from the buffer and print a message
    // This is optional and depends on your protocol
    if (byteBuffer.isNotEmpty && byteBuffer.first == 0x06) {
      final hexString = byteBuffer.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
      byteBuffer.removeAt(0); // Remove the ACK from the buffer
      return {"ack": hexString}; // Exit early as we only need to process the ACK
    }

    // Check if we have enough data to process (STX + 2 bytes for length + data + ETX)
    while (byteBuffer.length >= 4) {
      // Find the start (STX) and end (ETX) markers
      int startIdx = byteBuffer.indexOf(0x02); // Find STX (0x02)
      int endIdx = byteBuffer.indexOf(0x03); // Find ETX (0x03)

      if (startIdx != -1 && endIdx != -1 && endIdx > startIdx) {
        // Extract the data length (2 bytes after STX)
        final lengthBytes = byteBuffer.sublist(startIdx + 1, startIdx + 3);
        final dataLength = (lengthBytes[0] << 8) | lengthBytes[1];

        // Ensure that the full data (length + ETX) is available
        if (byteBuffer.length >= startIdx + 3 + dataLength + 1) {
          final completeMessage = byteBuffer.sublist(startIdx + 3, startIdx + 3 + dataLength);

          // Convert the message to a hex string (for debugging)
          final hexString = completeMessage.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

          // Decode the extracted data to UTF-8 (JSON string)
          String utf8String;
          try {
            utf8String = utf8.decode(completeMessage, allowMalformed: true);
          } catch (e) {
            utf8String = 'Error decoding data: $e';
          }

          // Print the hex and decoded UTF-8 message
          // print('Hex String: $hexString');
          // print('Decoded String: $utf8String');

          // Parse JSON message if valid
          try {
            final Map<String, dynamic> jsonMessage = json.decode(utf8String);
            // print('Decoded JSON: $jsonMessage');

            // Remove processed data from the buffer
            byteBuffer.removeRange(0, startIdx + 3 + dataLength + 1);
            // Process the JSON message as needed
            // For example, you can store it in a variable or call a callback function
            return jsonMessage;
          } catch (e) {
            // Remove processed data from the buffer
            byteBuffer.removeRange(0, startIdx + 3 + dataLength + 1);
            // Handle JSON parsing error
            return {"Error parsing JSON": e.toString()};
          }
        }
      } else {
        // If no complete message is found, break and wait for more data
        break;
      }
    }
    return {}; // Return an empty map if no complete message is found
  }
}
