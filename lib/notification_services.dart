// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationServices {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   //function to initialise flutter local notification plugin to show notifications for android when app is active

//   void initLocalNotifications(
//       BuildContext context, RemoteMessage message) async {
//     var androidInitializationSettings =
//         const AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iosInitializationSettings = const DarwinInitializationSettings();
//     var initializationSetting = InitializationSettings(
//         android: androidInitializationSettings, iOS: iosInitializationSettings);

//     await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
//         onDidReceiveNotificationResponse: (payload) {
//       // handle interaction when app is active for android
//       handleMessage(context, message);
//     });
//   }

//   void firebaseInit(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification!.android;

//       if (kDebugMode) {
//         print("notifications title:${notification!.title}");
//         print("notifications body:${notification.body}");
//         print('count:${android!.count}');
//         print('data:${message.data.toString()}');
//       }
//       String? action = message.data['action'];
//       String? topic = message.data['topic'];

//       // Check if the action and topic are present, then perform the action
//       if (action != null && topic != null) {
//         if (action == 'subscribe') {
//           subscribeToTopic(topic);
//         } else if (action == 'unsubscribe') {
//           unsubscribeFromTopic(topic);
//         }
//       }
//       if (Platform.isIOS) {
//         forgroundMessage();
//       }

//       if (Platform.isAndroid) {
//         initLocalNotifications(context, message);
//         showNotification(message);
//       }
//     });
//     setupInteractMessage(context);
//   }

//   void requestNotificationPermission() async {
//     NotificationSettings settings = await messaging.requestPermission(
//       // alert: true,
//       // announcement: true,
//       // badge: true,
//       // carPlay: true,
//       // criticalAlert: true,
//       // provisional: true,
//       // sound: true,

//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       if (kDebugMode) {
//         print('user granted permission');
//       }
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       if (kDebugMode) {
//         print('user granted provisional permission');
//       }
//     } else {
//       //appsetting.AppSettings.openNotificationSettings();
//       if (kDebugMode) {
//         print('user denied permission');
//       }
//     }
//   }

//   // function to show visible notification when app is active
//   Future<void> showNotification(RemoteMessage message) async {
//     AndroidNotificationChannel channel = AndroidNotificationChannel(
//       message.notification!.android!.channelId.toString(),
//       message.notification!.android!.channelId.toString(),
//       importance: Importance.max,
//       showBadge: true,
//       playSound: true,
//     );

//     AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       channel.id.toString(), channel.name.toString(),
//       channelDescription: 'description',
//       importance: Importance.high,
//       priority: Priority.high,
//       playSound: true,
//       ticker: 'ticker',
//       sound: channel.sound,
//       // icon: "@mipmap/ic_launcher"
//     );

//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//             presentAlert: true, presentBadge: true, presentSound: true);

//     NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails);

//     Future.delayed(Duration.zero, () {
//       _flutterLocalNotificationsPlugin.show(
//         0,
//         message.notification!.title.toString(),
//         message.notification!.body.toString(),
//         notificationDetails,
//       );
//     });
//   }

//   //function to get device token on which we will send the notifications
//   Future<String> getDeviceToken() async {
//     String? token = await messaging.getToken();
//     return token!;
//   }

//   void isTokenRefresh() async {
//     messaging.onTokenRefresh.listen((event) {
//       event.toString();
//       if (kDebugMode) {
//         print('refresh');
//       }
//     });
//   }

//   //handle tap on notification when app is in background or terminated
//   Future<void> setupInteractMessage(context) async {
//     // when app is terminated
//     RemoteMessage? initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

//     if (initialMessage != null) {
//       handleMessage(context, initialMessage);
//     }
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       // performActionBasedOnMessage(message);
//     });
//     //when app ins background
//     FirebaseMessaging.onMessageOpenedApp.listen((event) {
//       handleMessage(context, event);
//     });
//   }

//   void handleMessage(BuildContext context, RemoteMessage message) {
//     if (message.data['type'] == 'msj') {
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) => const HomeScreen(
//       //             /*    id: message.data['id'], */
//       //             )));
//     }
//   }

//   Future forgroundMessage() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }

//   Future<void> subscribeToTopic(String topic) async {
//     messaging.subscribeToTopic(topic).then((_) {
//       if (kDebugMode) {
//         print('Subscription to $topic successful');
//       }
//     }).catchError((error) {
//       if (kDebugMode) {
//         print('Subscription to $topic failed: $error');
//       }
//     });
//   }

//   Future<void> unsubscribeFromTopic(String topic) async {
//     await messaging.unsubscribeFromTopic(topic).then((_) {
//       if (kDebugMode) {
//         print('Unsubscribed from $topic successfully');
//       }
//     }).catchError((error) {
//       if (kDebugMode) {
//         print('Unsubscribe from $topic failed: $error');
//       }
//     });
//   }
// }




// //  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
// //       // performActionBasedOnMessage(message);
// //     });
//   // void performActionBasedOnMessage(RemoteMessage message) {
//   //   String? action = message.data['action'];
//   //   String? topic = message.data['topic'];
//   //   if (action != null && topic != null) {
//   //     if (action == 'subscribe') {
//   //       subscribeToTopic(topic);
//   //     } else if (action == 'unsubscribe') {
//   //       unsubscribeFromTopic(topic);
//   //     }
//   //   }
//   // }