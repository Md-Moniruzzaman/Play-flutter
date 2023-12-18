import 'package:animation_practice/ui/animation_home.dart';
import 'package:animation_practice/ui/list_view_animaiton.dart';
import 'package:animation_practice/ui/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
      // The top level function, aka callbackDispatcher
      callbackDispatcher,

      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: true);

  // Periodic task registration
  Workmanager().registerPeriodicTask(
    '2',
    // This is the value that will be
    // returned in the callbackDispatcher
    "simplePeriodicTask",

    // When no frequency is provided
    // the default 15 minutes is set.
    // Minimum frequency is 15 min.
    // Android will automatically change
    // your frequency to 15 min
    // if you have configured a lower frequency.
    frequency: const Duration(minutes: 15),
  );
  runApp(const MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    // initialise the plugin of flutterlocalnotification.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var IOS = IOSInitializationSettings();

    // Initialise settings for both Android and IOS
    var settings = InitializationSettings(android: android);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(android);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(flip) async {
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidplatformChannelSpecifics = const AndroidNotificationDetails(
      ' Channel Id', ' Channel Name',
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.high);

  // Initialise channel platform for Android device
  var platformChannelSpecifics =
      NotificationDetails(android: androidplatformChannelSpecifics);
  await flip.show(
      0,
      'Local Notification',
      'You are one step away to connect with yourself',
      platformChannelSpecifics,
      payload: 'Default_Sound');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animation Practice',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      // home: const AnimationHome(),
      initialRoute: '/',
      routes: {
        '/': (context) => const AnimationHome(),
        '/animatedListView': (contex) => const ListViewAnimation(),
        '/socket': (context) => const Socket()
      },
    );
  }
}
