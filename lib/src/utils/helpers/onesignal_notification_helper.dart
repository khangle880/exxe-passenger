import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalNotificationHelper {
  OSNotification? notiSaved;
  Function(OSNotification noti)? openedHandler;
  Function(OSNotification noti)? onForeGroundMessage;

  init() async {
    // Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared
        .setAppId(dotenv.maybeGet('ONESIGNALAPPID', fallback: null) ?? "");

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      if (event.notification.title == "CUỘC GỌI MỚI") {
        event.complete(null);
      } else {
        event.complete(event.notification);
        onForeGroundMessage?.call(event.notification);
      }
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      openedHandler?.call(result.notification);
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
  }

  Future<String?> get id async =>
      (await OneSignal.shared.getDeviceState())?.userId;

  Future<String?> get token async =>
      (await OneSignal.shared.getDeviceState())?.pushToken;

  static OneSignalNotificationHelper instance = OneSignalNotificationHelper();

  static OneSignalNotificationHelper get I => instance;

  OneSignalNotificationHelper();
}
