import '../../../utils/constants/enum/enum.dart';
import '../../../utils/parser_utils.dart';
import '../models.dart';

class NotificationCompoundingModel extends NotificationModel {
  NotificationCompoundingModel({
    this.messageId,
    this.carDriverId,
    this.compoundingCarId,
    this.compoundingCarCode,
    this.passengerId,
    this.compoundingCarCustomerId,
    this.compoundingCarCustomerCode,
    this.messageTitle,
    this.messageContent,
  });

  NotificationCompoundingModel.fromJson(dynamic json) {
    messageId = safeParse(json['message_id']);
    id = messageId;
    carDriverId = safeParse(json['car_driver_id']);
    compoundingCarId = safeParse(json['compounding_car_id']);
    compoundingCarCode = safeParse(json['compounding_car_code']);
    passengerId = safeParse(json['passenger_id']);
    compoundingCarCustomerId = safeParse(json['compounding_car_customer_id']);
    compoundingCarCustomerCode =
        safeParse(json['compounding_car_customer_code']);
    messageTitle = safeParse(json['message_title']);
    messageContent = safeParse(json['message_content']);
    type =
        safeParse(json['notification_type'], payload: NotificationType.values);
    createdDate = safeParse(json['create_date']);
    read = safeParse(json['read']);
  }

  num? messageId;
  num? carDriverId;
  num? compoundingCarId;
  String? compoundingCarCode;
  num? passengerId;
  num? compoundingCarCustomerId;
  String? compoundingCarCustomerCode;
  String? messageTitle;
  String? messageContent;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message_id'] = messageId;
    map['car_driver_id'] = carDriverId;
    map['compounding_car_id'] = compoundingCarId;
    map['compounding_car_code'] = compoundingCarCode;
    map['passenger_id'] = passengerId;
    map['compounding_car_customer_id'] = compoundingCarCustomerId;
    map['compounding_car_customer_code'] = compoundingCarCustomerCode;
    map['message_title'] = messageTitle;
    map['message_content'] = messageContent;
    return map;
  }
}
