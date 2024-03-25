// ignore_for_file: avoid_print, unused_local_variable

import 'dart:developer';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationController {
  static bool showNotifications = false;
  static bool isNotificationScheduled =
      false; // Flag to track if notification is scheduled

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initializeFCM() async {
    // Request permission for receiving notifications (iOS only)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Get the FCM token
    String? token = await _firebaseMessaging.getToken();
    print('Device Token: $token');

    // Initialize Firebase Cloud Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Pass the received message to the Awesome Notifications package
      if (showNotifications) {
        _displayAwesomeNotification(message.notification!);
      } else {
        log("Notifications is disabled");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification taps when the app is in the background or terminated
      print("Opened app from notification: ${message.notification!.title}");
    });
  }

  static Future<void> _displayAwesomeNotification(
      RemoteNotification notification) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notification.hashCode,
        channelKey: 'image',
        title: notification.title!,
        body: notification.body!,
        bigPicture:
            'https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg',
        largeIcon:
            'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
        notificationLayout: NotificationLayout.BigPicture,
      ),
    );
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

// ********************* for schedule notification ********************
  static Future<void> scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'image',
          title: title,
          body: body,
        ),
        schedule: NotificationCalendar(
          weekday: scheduledTime.weekday,
          hour: scheduledTime.hour,
          minute: scheduledTime.minute,
          second: scheduledTime.second,
          timeZone: 'Asia/Karachi',
          repeats: false,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

// ********************* Method to schedule a repeating notification ********************

  static Future<void> scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'image',
          title: title,
          body: body,
        ),
        schedule: NotificationInterval(
          interval: 60,
          repeats: true,
        ),
      );
      isNotificationScheduled = true;
    } catch (e) {
      print(e);
    }
  }
}
