import 'package:exxe/src/utils/export/ui_export.dart';

import '../models.dart';

class PaymentModel {
  PaymentModel({
    this.paymentId,
    this.date,
    this.amount,
    this.ref,
    this.state,
    this.partnerId,
    this.journalId,
    this.paymentPurpose,
    this.paymentCode,
    this.isMakeWithdrawingRequest,
    this.paymentType,
    this.partnerType,
    this.compoundingCar,
  });

  PaymentModel.fromJson(dynamic json) {
    paymentId = safeParse(json['payment_id']);
    date = safeParse(json['date']);
    amount = safeParse(json['amount']);
    ref = safeParse(json['ref']);
    state = safeParse(json['state']);
    partnerId = json['partner_id'] != null
        ? PartnerModel.fromJson(json['partner_id'])
        : null;
    journalId = json['journal_id'] != null
        ? JournalModel.fromJson(json['journal_id'])
        : null;
    paymentPurpose =
        safeParse(json['payment_purpose'], payload: PaymentPurpose.values);
    paymentCode = safeParse(json['payment_code']);
    isMakeWithdrawingRequest = safeParse(json['is_make_withdrawing_request']);
    paymentType = safeParse(json['payment_type'], payload: PaymentType.values);
    partnerType = safeParse(json['partner_type'], payload: PartnerType.values);
    compoundingCar = json['compounding_car'] != null
        ? CompoundingCarModel.fromJson(json['compounding_car'])
        : null;
  }

  int? paymentId;
  DateTime? date;
  double? amount;
  String? ref;
  String? state;
  PartnerModel? partnerId;
  JournalModel? journalId;
  PaymentPurpose? paymentPurpose;
  String? paymentCode;
  bool? isMakeWithdrawingRequest;
  PaymentType? paymentType;
  PartnerType? partnerType;
  CompoundingCarModel? compoundingCar;

  bool get shouldShow => paymentPurpose != null;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['payment_id'] = paymentId;
    map['date'] = date;
    map['amount'] = amount;
    map['ref'] = ref;
    map['state'] = state;
    if (partnerId != null) {
      map['partner_id'] = partnerId!.toJson();
    }
    if (journalId != null) {
      map['journal_id'] = journalId!.toJson();
    }
    map['payment_purpose'] = paymentPurpose;
    map['payment_code'] = paymentCode;
    map['is_make_withdrawing_request'] = isMakeWithdrawingRequest;
    map['payment_type'] = paymentType;
    map['partner_type'] = partnerType;
    if (compoundingCar != null) {
      map['compounding_car'] = compoundingCar!.toJson();
    }
    return map;
  }
}
