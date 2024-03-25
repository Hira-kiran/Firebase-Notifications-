// ignore_for_file: library_private_types_in_public_api

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'awosome_notification.dart';
import 'firebase_options.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//   runApp(const MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Awesome Notifications
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'image',
        channelName: 'Image Channel',
        channelDescription: 'Channel for notifications with images',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.deepPurple,
        importance: NotificationImportance.High,
        defaultPrivacy: NotificationPrivacy.Private,
        playSound: true,
        vibrationPattern: highVibrationPattern,
      ),
    ],
    debug: true,
  );

  // Initialize Firebase Cloud Messaging
  await NotificationController.initializeFCM();
  await NotificationController.subscribeToTopic('KFC');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Notification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotificationScreen(),
    );
  }
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _showNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SwitchListTile(
              title: const Text("Notifications"),
              value: _showNotifications,
              onChanged: (bool value) {
                setState(() {
                  _showNotifications = value;
                  NotificationController.showNotifications = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                NotificationController.scheduleLocalNotification(
                  id: 1,
                  title: 'Scheduled Notification',
                  body: 'This is a scheduled notification!',
                  scheduledTime: DateTime.now().add(const Duration(minutes: 1)),
                );
              },
              child: const Text("Schedule Notification"),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (!NotificationController.isNotificationScheduled) {
                  NotificationController.scheduleRepeatingNotification(
                    id: 1,
                    title: 'Schedule Repeating Notification',
                    body: 'This is a scheduled notification!',
                  );
                }
              },
              child: const Text(
                "Schedule Repeating Notification",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
