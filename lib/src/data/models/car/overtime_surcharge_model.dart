import '../../../utils/parser_utils.dart';

class OvertimeSurchargeModel {
  OvertimeSurchargeModel({
    this.numberExtraWaitingHour,
    this.waitingChargePerHour,
    this.amount,
  });

  OvertimeSurchargeModel.fromJson(dynamic json) {
    numberExtraWaitingHour = safeParse(json['number_extra_waiting_hour']);
    waitingChargePerHour = safeParse(json['waiting_charge_per_hour']);
    amount = safeParse(json['amount']);
  }

  num? numberExtraWaitingHour;
  num? waitingChargePerHour;
  num? amount;

  OvertimeSurchargeModel copyWith({
    num? numberExtraWaitingHour,
    num? waitingChargePerHour,
    num? amount,
  }) =>
      OvertimeSurchargeModel(
        numberExtraWaitingHour:
            numberExtraWaitingHour ?? this.numberExtraWaitingHour,
        waitingChargePerHour: waitingChargePerHour ?? this.waitingChargePerHour,
        amount: amount ?? this.amount,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number_extra_waiting_hour'] = numberExtraWaitingHour;
    map['waiting_charge_per_hour'] = waitingChargePerHour;
    map['amount'] = amount;
    return map;
  }
}
