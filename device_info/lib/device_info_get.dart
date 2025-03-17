import 'package:flutter/services.dart';

class SunmiDeviceInfo {
  static const MethodChannel _channel = MethodChannel('sunmi/device_info');

  static Future<String?> getSerialNumber() async {
    try {
      final String? serial = await _channel.invokeMethod('getSerialNumber');
      return serial;
    } on PlatformException catch (e) {
      print("Failed to get serial number: '${e.message}'.");
      return null;
    }
  }
}
