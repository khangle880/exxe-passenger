import 'package:exxe/src/utils/export/logic_export.dart';

import '../../../utils/parser_utils.dart';

class NotificationDashboardModel {
  int? unReadPromotion;
  int? unReadTransaction;
  List<NotificationModel>? notifications;

  NotificationDashboardModel({
    this.unReadPromotion,
    this.unReadTransaction,
    this.notifications,
  });

  NotificationDashboardModel.fromJson(dynamic json) {
    unReadPromotion = safeParse(json['no_unread_promotion_notification']);
    unReadTransaction = safeParse(json['no_unread_transaction_notification']);
    notifications = List.from(
      (json['notifications'] ?? []).map((e) {
        final type = e['notification_type'];
        if (type == NotificationType.promotionNotification.serverString) {
          return NotificationPromotionModel.fromJson(e);
        } else if (type ==
            NotificationType.transactionNotification.serverString) {
          return NotificationTransModel.fromJson(e);
        } else {
          return NotificationCompoundingModel.fromJson(e);
        }
      }),
    );
  }

  NotificationDashboardModel copyWith({
    int? unReadPromotion,
    int? unReadTransaction,
    List<NotificationModel>? notifications,
  }) {
    return NotificationDashboardModel(
      unReadPromotion: unReadPromotion ?? this.unReadPromotion,
      unReadTransaction: unReadTransaction ?? this.unReadTransaction,
      notifications: notifications ?? this.notifications,
    );
  }
}
