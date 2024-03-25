// // ignore_for_file: unused_field, avoid_print
// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'notification_services.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   NotificationServices notificationsServices = NotificationServices();
//   Map<String, bool> subscribedTopics = {};
//   final List<String> topics = ['sports', 'technology', 'entertainment'];

//   @override
//   void initState() {
//     super.initState();
//     notificationsServices.requestNotificationPermission();
//     notificationsServices.firebaseInit(context);
//     notificationsServices.isTokenRefresh();
//     notificationsServices.forgroundMessage();
//     notificationsServices.setupInteractMessage(context);
//     notificationsServices
//         .getDeviceToken()
//         .then((value) => print("Device token $value"));

//     for (var topic in topics) {
//       subscribedTopics[topic] = false;
//     }
//   }

//   void toggleSubscription(String topic) async {
//     if (subscribedTopics[topic]!) {
//       await notificationsServices.unsubscribeFromTopic(topic);
//     } else {
//       await notificationsServices.subscribeToTopic(topic);
//     }
//     setState(() {
//       subscribedTopics[topic] = !subscribedTopics[topic]!;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     NotificationServices notificationServices = NotificationServices();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Notifications"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text("Push Notifications"),
//             const SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 400,
//               child: ListView.builder(
//                 itemCount: topics.length,
//                 itemBuilder: (context, index) {
//                   String topic = topics[index];
//                   return SwitchListTile(
//                     title: Text(topic),
//                     value: subscribedTopics[topic] ?? false,
//                     onChanged: (bool value) {
//                       toggleSubscription(topic);
//                     },
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             ElevatedButton(
//                 onPressed: () {
//                   notificationServices.getDeviceToken().then((value) async {
//                     var data = {
//                       'to': value.toString(),
//                       'notification': {
//                         'title': "Tapday App",
//                         'body': 'Tapday Notifications',
//                         'image':
//                             'https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg',
//                       },
//                       'data': {'type': 'msj', 'id': '123456'}
//                     };

//                     await http.post(
//                         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//                         body: jsonEncode(data),
//                         headers: {
//                           'Content-Type': 'application/json; charset=UTF-8',
//                           'Authorization':
//                               'key=AAAApnupxoI:APA91bEcH15pXHaqKSqGgBSaw_BQwr6TTmI9QewucEVJbFGV0ElvMxbzJL2PL5MTWPjRXSu_v3nF4hajo5_Z2odIZPHkF_ZdffI5wrImxSH7M0C8b5sgDoOif-Nu1fXOUjxfZN47hW9F',
//                           'image':
//                               'https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg',
//                         }).then((value) {
//                       log(value.body.toString());
//                     }).onError((error, stackTrace) {
//                       if (kDebugMode) {
//                         print(error);
//                       }
//                     });
//                   });
//                 },
//                 child: const Text("Send Notification"))
//           ],
//         ),
//       ),
//     );
//   }
// }
