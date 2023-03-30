// import 'dart:developer';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// import 'awesome_notification_helper.dart';
//
// class FireBaseNotificationHelper {
//   init({required Function(Map<String, dynamic> data) onInitMessage,
//     required Function(Map<String, dynamic> data) onOpenedMessage,
//     required Function(String? payload) onLocalNotiMessage,
//     required Function(Map<String, dynamic> data) onForeGroundMessage}) async {
//     if (Platform.isIOS) {
//       await _setupIosNotification();
//     }
//
//     //when app killed
//     await FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) async {
//       if (message != null) {
//         onInitMessage(message.data);
//       }
//     });
//
//     //when app on background
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       onOpenedMessage(message.data);
//     });
//
//     //when app on foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       final notification = message.notification;
//       onForeGroundMessage(message.data);
//       if (notification != null) {
//         showLocalNotification(message);
//       }
//     });
//
//     log("fcm token ${await token}");
//   }
//
//   void showLocalNotification(RemoteMessage message) async {
//     AwesomeNotificationHelper.showChatNoti(
//       id: message.hashCode,
//       title: message.notification?.title,
//       body: message.notification?.body,
//       largeIconUrl: message.notification?.android?.imageUrl ??
//           message.notification?.apple?.imageUrl,
//     );
//   }
//
//   Future<void> unRegister() async {
//     return await FirebaseMessaging.instance.deleteToken();
//   }
//
//   Future<void> _setupIosNotification() async {
//     await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   Future<void> subscribeToTopic(String topic) async {
//     await FirebaseMessaging.instance.subscribeToTopic(topic);
//   }
//
//   Future<String?> get token async =>
//       await FirebaseMessaging.instance.getToken();
//
//   static FireBaseNotificationHelper instance = FireBaseNotificationHelper();
//
//   static FireBaseNotificationHelper get I => instance;
//
//   FireBaseNotificationHelper();
// }
