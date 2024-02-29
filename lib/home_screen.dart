// ignore_for_file: unused_field

import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'notification/push_notification.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FirebaseMessaging _messaging;
  int totalNotification = 0;
  late PushNotification _notificationinfo;

  // For user permission, depend on user they will allow notification or not
  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
        alert: true, badge: true, provisional: false, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log("Message title: ${message.notification?.title}");
        PushNotification notification = PushNotification(
          title: message.notification!.title ?? "",
          body: message.notification!.body ?? "",
          dataTitle: message.data["title"] ?? "",
          dataBody: message.data["body"] ?? "",
        );
        log(notification.title);
        setState(() {
          _notificationinfo = notification;
          totalNotification++;
        });

        // Display notification here after it's received
        showSimpleNotification(
          Text(
            notification.title,
            style: const TextStyle(color: Colors.white),
          ),
          background: Colors.purple,
          duration: const Duration(seconds: 2),
          subtitle: Text(notification.body),
        );
      });
    } else {
      log("User declined or has not accepted permission");
    }
  }

  // For handling notifications in terminated state
  void checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title ?? "",
        body: initialMessage.notification!.body ?? "",
        dataTitle: initialMessage.data["title"] ?? "",
        dataBody: initialMessage.data["body"] ?? "",
      );
      log(notification.title);
      setState(() {
        _notificationinfo = notification;
        totalNotification++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    totalNotification = 0;

    registerNotification();
    checkForInitialMessage();

    // For handling notification when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification!.title ?? "",
        body: message.notification!.body ?? "",
        dataTitle: message.data["title"] ?? "",
        dataBody: message.data["body"] ?? "",
      );
      log(notification.title);
      setState(() {
        _notificationinfo = notification;
        totalNotification++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Push Notifications"),
            Text("Total Notifications: $totalNotification"),
          ],
        ),
      ),
    );
  }
}
