import 'package:exxe/src/utils/export/ui_export.dart';

import '../../data.dart';

class TransactionDetailModel {
  TransactionDetailModel({
    this.paymentPurpose,
    this.paymentId,
  });

  TransactionDetailModel.fromJson(dynamic json) {
    paymentPurpose =
        safeParse(json['payment_purpose'], payload: PaymentPurpose.values);

    paymentId = json['payment_id'] != null
        ? PaymentModel.fromJson(json['payment_id'])
        : null;

    compoundingCarCustomerId = json['compounding_car_customer_id'] != null
        ? CompoundingCarCustomerModel.fromJson(
            json['compounding_car_customer_id'])
        : null;
  }

  PaymentPurpose? paymentPurpose;
  PaymentModel? paymentId;
  CompoundingCarCustomerModel? compoundingCarCustomerId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_purpose'] = paymentPurpose;
    if (paymentId != null) {
      map['payment_id'] = paymentId!.toJson();
    }
    if (compoundingCarCustomerId != null) {
      map['compounding_car_customer_id'] = compoundingCarCustomerId!.toJson();
    }
    return map;
  }
}
