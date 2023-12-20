// import 'dart:io';

// import 'package:animation_practice/ui/animation_home.dart';
// import 'package:animation_practice/ui/list_view_animaiton.dart';
// import 'package:animation_practice/ui/socket.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:workmanager/workmanager.dart';

// Future<void> main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//     final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
//       ? null
//       : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
//   // String initialRoute = HomePage.routeName;
//   // if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
//   //   selectedNotificationPayload = notificationAppLaunchDetails!.notificationResponse?.payload;
//   //   initialRoute = SecondPage.routeName;
//   // }

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('app_icon');

//   final List<DarwinNotificationCategory> darwinNotificationCategories =
//       <DarwinNotificationCategory>[
//     DarwinNotificationCategory(
//       darwinNotificationCategoryText,
//       actions: <DarwinNotificationAction>[
//         DarwinNotificationAction.text(
//           'text_1',
//           'Action 1',
//           buttonTitle: 'Send',
//           placeholder: 'Placeholder',
//         ),
//       ],
//     ),
//     DarwinNotificationCategory(
//       darwinNotificationCategoryPlain,
//       actions: <DarwinNotificationAction>[
//         DarwinNotificationAction.plain('id_1', 'Action 1'),
//         DarwinNotificationAction.plain(
//           'id_2',
//           'Action 2 (destructive)',
//           options: <DarwinNotificationActionOption>{
//             DarwinNotificationActionOption.destructive,
//           },
//         ),
//         DarwinNotificationAction.plain(
//           navigationActionId,
//           'Action 3 (foreground)',
//           options: <DarwinNotificationActionOption>{
//             DarwinNotificationActionOption.foreground,
//           },
//         ),
//         DarwinNotificationAction.plain(
//           'id_4',
//           'Action 4 (auth required)',
//           options: <DarwinNotificationActionOption>{
//             DarwinNotificationActionOption.authenticationRequired,
//           },
//         ),
//       ],
//       options: <DarwinNotificationCategoryOption>{
//         DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//       },
//     )
//   ];

//   /// Note: permissions aren't requested here just to demonstrate that can be
//   /// done later
//   final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
//     requestAlertPermission: false,
//     requestBadgePermission: false,
//     requestSoundPermission: false,
//     onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {
//       didReceiveLocalNotificationStream.add(
//         ReceivedNotification(
//           id: id,
//           title: title,
//           body: body,
//           payload: payload,
//         ),
//       );
//     },
//     notificationCategories: darwinNotificationCategories,
//   );
//   final LinuxInitializationSettings initializationSettingsLinux = LinuxInitializationSettings(
//     defaultActionName: 'Open notification',
//     defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
//   );
//   final InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsDarwin,
//     macOS: initializationSettingsDarwin,
//     linux: initializationSettingsLinux,
//   );
//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
//       switch (notificationResponse.notificationResponseType) {
//         case NotificationResponseType.selectedNotification:
//           selectNotificationStream.add(notificationResponse.payload);
//           break;
//         case NotificationResponseType.selectedNotificationAction:
//           if (notificationResponse.actionId == navigationActionId) {
//             selectNotificationStream.add(notificationResponse.payload);
//           }
//           break;
//       }
//     },
//     onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//   );
//   runApp(const MyApp());
// }

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   Workmanager().initialize(
// //       // The top level function, aka callbackDispatcher
// //       callbackDispatcher,

// //       // If enabled it will post a notification whenever
// //       // the task is running. Handy for debugging tasks
// //       isInDebugMode: true);

// //   // Periodic task registration
// //   Workmanager().registerPeriodicTask(
// //     '2',
// //     // This is the value that will be
// //     // returned in the callbackDispatcher
// //     "simplePeriodicTask",

// //     // When no frequency is provided
// //     // the default 15 minutes is set.
// //     // Minimum frequency is 15 min.
// //     // Android will automatically change
// //     // your frequency to 15 min
// //     // if you have configured a lower frequency.
// //     frequency: const Duration(minutes: 15),
// //   );
// //   runApp(const MyApp());
// // }

// // void callbackDispatcher() {
// //   Workmanager().executeTask((taskName, inputData) {
// //     // initialise the plugin of flutterlocalnotification.
// //     FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
// //     flip
// //         .resolvePlatformSpecificImplementation<
// //             AndroidFlutterLocalNotificationsPlugin>()!
// //         .requestNotificationsPermission();

// //     // app_icon needs to be a added as a drawable
// //     // resource to the Android head project.
// //     var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
// //     // var IOS = IOSInitializationSettings();

// //     // Initialise settings for both Android and IOS
// //     var settings = InitializationSettings(android: android);
// //     flip.initialize(settings);
// //     _showNotificationWithDefaultSound(android);
// //     return Future.value(true);
// //   });
// // }

// // Future _showNotificationWithDefaultSound(flip) async {
// //   // Show a notification after every 15 minute with the first
// //   // appearance happening a minute after invoking the method
// //   var androidplatformChannelSpecifics = const AndroidNotificationDetails(
// //       ' Channel Id', ' Channel Name',
// //       channelDescription: 'Channel Description',
// //       importance: Importance.max,
// //       priority: Priority.high);

// //   // Initialise channel platform for Android device
// //   var platformChannelSpecifics =
// //       NotificationDetails(android: androidplatformChannelSpecifics);

// //   await flip.show(
// //       0,
// //       'Local Notification',
// //       'You are one step away to connect with yourself',
// //       platformChannelSpecifics,
// //       payload: 'Default_Sound');
// // }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Animation Practice',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       // home: const AnimationHome(),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const AnimationHome(),
//         '/animatedListView': (contex) => const ListViewAnimation(),
//         '/socket': (context) => const Socket()
//       },
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
// ignore: unnecessary_import

import 'package:animation_practice/services/local_notification/local_notification_common_services.dart';
import 'package:animation_practice/ui/flutter_notification/local_notification.dart';
import 'package:animation_practice/ui/flutter_notification/local_notification_info_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

/// IMPORTANT: running the following code on its own won't work as there is
/// setup required for each platform head project.
///
/// Please download the complete example app from the GitHub repository where
/// all the setup has been done
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = LocalNotification.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
    initialRoute = LocalNotification.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  runApp(
    MaterialApp(
      initialRoute: initialRoute,
      routes: <String, WidgetBuilder>{
        LocalNotification.routeName: (_) =>
            LocalNotification(notificationAppLaunchDetails),
        LocalNotificationInfoPage.routeName: (_) =>
            LocalNotificationInfoPage(selectedNotificationPayload)
      },
    ),
  );
}

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
