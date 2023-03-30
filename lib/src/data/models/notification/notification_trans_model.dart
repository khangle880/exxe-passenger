import '../../../utils/constants/enum/enum.dart';
import '../../../utils/parser_utils.dart';
import '../models.dart';

class NotificationTransModel extends NotificationModel {
  NotificationTransModel({
    this.paymentId,
    this.date,
    this.amount,
    this.ref,
    this.state,
  });

  NotificationTransModel.fromJson(dynamic json) {
    paymentId = safeParse(json['payment_id']);
    id = paymentId;
    date = safeParse(json['date']);
    amount = safeParse(json['amount']);
    ref = safeParse(json['ref']);
    state = safeParse(json['state']);
    type =
        safeParse(json['notification_type'], payload: NotificationType.values);
    createdDate = safeParse(json['create_date']);
    read = safeParse(json['read']);
  }

  int? paymentId;
  String? date;
  double? amount;
  String? ref;
  String? state;

  @override
  num? get id => paymentId;

  @override
  bool get shouldShow => ref != null;
}
