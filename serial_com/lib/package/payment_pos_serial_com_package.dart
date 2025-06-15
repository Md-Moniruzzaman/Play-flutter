import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:usb_serial/usb_serial.dart';

class PaymentPosWizarCardReaderSerialCommunitaion {
  UsbPort? _port;
  // StreamSubscription<Uint8List>? _subscription; // Declare the subscription variable

  // Get the device
  Future<UsbDevice?> getDevice(String pID, String vID) async {
    // UsbDevice? _usbDevice;
    List<UsbDevice> _devices = await UsbSerial.listDevices();
    for (var device in _devices) {
      if (device.pid.toString() == pID && device.vid.toString() == vID) {
        // _showMyDialog(context, ele);
        return device;
      }
    }
    return null;
  }

  static getDeviceList() {
    return UsbSerial.listDevices();
  }

  static getDeviceInfo() {}
  static getDeviceStatus() {}

  Future<UsbPort?> connectDevice(UsbDevice? device, int baudRate) async {
    if (device != null) {
      try {
        _port = await device.create();

        if (_port != null) {
          // Attempt to open the port
          bool isPortOpen = await _port!.open();
          if (isPortOpen) {
            await _port!.setDTR(true);
            await _port!.setRTS(true);

            // Set the port parameters (baud rate, data bits, stop bits, parity)
            // Note: You can adjust these parameters based on your requirements
            _port!.setPortParameters(baudRate, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

            // You can now use the port to send and receive data
            // For example, you can write data to the port like this:
            return _port;
          } else {
            // Handle the case where the port could not be opened
            // You may want to close the port if it was opened successfully before
            debugPrint('Failed to open port.');
          }
        } else {
          // Handle the case where the port could not be created
          debugPrint('Failed to create port.');
        }
      } catch (e) {
        // Handle any exceptions that may occur during the connection process
        debugPrint('Error: $e');
      }
    } else {
      // Handle the case where the device is null (not found)
      debugPrint('Device not found.');
    }
    return null; // Return null if the device is not found or connection fails
  }

  disconnectDevice() {
    // Close the port if it was opened successfully
    _port?.close();
    _port = null; // Set the port to null after closing it
  }

  Future<void> sendRequest(String sysTrace, String sysSN, String cusPhoneNo, double amount) async {
    final String orderAmountStr = amount.toStringAsFixed(2); // Make sure always have 2 decimal point in Order Amount

    final String removedDecPointFromOrderAmount =
        orderAmountStr.replaceAll('.', ''); // Remove decimal point from Amount for Card transaction

    // JSON data to be sent
    Map<String, String> requestData = {
      "SysTrace": sysTrace,
      "SysSN": sysSN,
      "TransType": "3",
      "TransAmount": removedDecPointFromOrderAmount,
      "PhoneNum": cusPhoneNo,
    };

    // paymentLog(theNewOrder);

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
    // final hexString =
    //     message.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    // print(hexString);
    // Convert to Uint8List for transmission
    final messageBytes = Uint8List.fromList(message);

    await _port!.write(messageBytes);
  }

  Future sendAck(int ackCode) async {
    // Send an acknowledgment byte (0x06) to the device
    // This is just an example; you can modify it based on your protocol
    await _port!.write(Uint8List.fromList([ackCode]));
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
      return {}; // Exit early as we only need to process the ACK
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
            print('Decoded JSON: $jsonMessage');

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
