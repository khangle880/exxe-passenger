import '../../../utils/constants/enum/enum.dart';

abstract class NotificationModel {
  NotificationType? type;
  bool? read;
  DateTime? createdDate;
  num? id;

  bool get shouldShow => true;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          read == other.read &&
          createdDate == other.createdDate &&
          id == other.id;

  @override
  int get hashCode =>
      type.hashCode ^ read.hashCode ^ createdDate.hashCode ^ id.hashCode;
}
