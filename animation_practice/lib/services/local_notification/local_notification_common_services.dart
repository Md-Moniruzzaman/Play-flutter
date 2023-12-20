import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image/image.dart' as image;

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

class LocalNotificationCommonServices {
  int id = 0;
  Future<LinuxServerCapabilities> getLinuxCapabilities() =>
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              LinuxFlutterLocalNotificationsPlugin>()!
          .getCapabilities();

  Future<void> showLinuxNotificationWithBodyMarkup() async {
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification with body markup',
      '<b>bold text</b>\n'
          '<i>italic text</i>\n'
          '<u>underline text</u>\n'
          'https://example.com\n'
          '<a href="https://example.com">example.com</a>',
      null,
    );
  }

  Future<void> showLinuxNotificationWithCategory() async {
    const LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      category: LinuxNotificationCategory.emailArrived,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification with category',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationWithByteDataIcon() async {
    final ByteData assetIcon = await rootBundle.load(
      'icons/app_icon_density.png',
    );
    final image.Image? iconData = image.decodePng(
      assetIcon.buffer.asUint8List(),
    );
    final Uint8List iconBytes = iconData!.getBytes();
    final LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      icon: ByteDataLinuxIcon(
        LinuxRawIconData(
          data: iconBytes,
          width: iconData.width,
          height: iconData.height,
          channels: 4, // The icon has an alpha channel
          hasAlpha: true,
        ),
      ),
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification with byte data icon',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationWithPathIcon(String path) async {
    final LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(icon: FilePathLinuxIcon(path));
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'notification with file path icon',
      null,
      platformChannelSpecifics,
    );
  }

  Future<void> showLinuxNotificationWithThemeIcon() async {
    final LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      icon: ThemeLinuxIcon('media-eject'),
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification with theme icon',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationWithThemeSound() async {
    final LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      sound: ThemeLinuxSound('message-new-email'),
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification with theme sound',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationWithCriticalUrgency() async {
    const LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      urgency: LinuxNotificationUrgency.critical,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification with critical urgency',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationWithTimeout() async {
    final LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      timeout: LinuxNotificationTimeout.fromDuration(
        const Duration(seconds: 1),
      ),
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification with timeout',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationSuppressSound() async {
    const LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      suppressSound: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'suppress notification sound',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationTransient() async {
    const LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      transient: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'transient notification',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationResident() async {
    const LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(
      resident: true,
    );
    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'resident notification',
      null,
      notificationDetails,
    );
  }

  Future<void> showLinuxNotificationDifferentLocation() async {
    const LinuxNotificationDetails linuxPlatformChannelSpecifics =
        LinuxNotificationDetails(location: LinuxNotificationLocation(10, 10));
    const NotificationDetails notificationDetails = NotificationDetails(
      linux: linuxPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      id++,
      'notification on different screen location',
      null,
      notificationDetails,
    );
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
