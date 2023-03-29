enum NotificationType {
  allNotification,
  transactionNotification,
  promotionNotification,
  compoundingNotification,
}

extension NotificationTypeExt on NotificationType {
  Map<NotificationTypeGroup, List<NotificationType>> get mapTypes => {
        NotificationTypeGroup.all: [],
        NotificationTypeGroup.transaction: [
          NotificationType.transactionNotification
        ],
        NotificationTypeGroup.promotion: [
          NotificationType.promotionNotification
        ],
        NotificationTypeGroup.compounding: [
          NotificationType.compoundingNotification
        ],
      };

  String get name {
    switch (this) {
      case NotificationType.allNotification:
        return 'Tất cả';
      case NotificationType.promotionNotification:
        return 'Ưu đãi';
      case NotificationType.transactionNotification:
        return 'Giao dịch';
      case NotificationType.compoundingNotification:
        return 'Chuyến đi';
    }
  }
}

enum NotificationTypeGroup {
  all,
  transaction,
  promotion,
  compounding,
}

extension NotificationTypeGroupExt on NotificationTypeGroup {
  String get name {
    switch (this) {
      case NotificationTypeGroup.all:
        return 'Tất cả';
      case NotificationTypeGroup.promotion:
        return 'Ưu đãi';
      case NotificationTypeGroup.transaction:
        return 'Giao dịch';
      case NotificationTypeGroup.compounding:
        return 'Chuyến đi';
    }
  }
}
