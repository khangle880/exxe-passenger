import 'package:awesome_notifications/awesome_notifications.dart';

class AwesomeNotificationHelper {
  static init() async {
    await AwesomeNotifications().initialize(
        'resource://drawable/logo',
        [
          NotificationChannel(
            channelGroupKey: 'chat_group',
            channelKey: 'Chat',
            channelName: 'Chat notifications',
            channelDescription: 'Notification channel for server chat',
            channelShowBadge: true,
            importance: NotificationImportance.High,
            enableVibration: true,
          ),
          NotificationChannel(
              channelGroupKey: 'CallInvitation',
              channelKey: 'CallInvitation',
              channelName: 'CallInvitation',
              channelDescription: 'Notification channel for server call',
              channelShowBadge: true,
              importance: NotificationImportance.High,
              enableVibration: true,
              soundSource: 'resource://raw/zego_incoming'),
        ],
        debug: true);
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static showChatNoti({
    required int id,
    String? title,
    String? body,
    String? largeIconUrl,
    Map<String, String>? payload,
  }) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'chat',
        title: title,
        body: body,
        payload: payload,
        largeIcon: largeIconUrl,
      ),
    );
  }
}
