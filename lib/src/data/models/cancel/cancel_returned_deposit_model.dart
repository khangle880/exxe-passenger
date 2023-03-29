import 'package:exxe/src/utils/export/ui_export.dart';

class CancelReturnedDepositModel {
  CancelReturnedDepositModel({
    this.remainsSecond,
    this.returnedDeposit,
  });

  CancelReturnedDepositModel.fromJson(dynamic json) {
    remainsSecond = safeParse(json['remains_second']);
    returnedDeposit = safeParse(json['returned_deposit']);
  }

  num? remainsSecond;
  bool? returnedDeposit;

  CancelReturnedDepositModel copyWith({
    num? remainsSecond,
    bool? returnedDeposit,
  }) =>
      CancelReturnedDepositModel(
        remainsSecond: remainsSecond ?? this.remainsSecond,
        returnedDeposit: returnedDeposit ?? this.returnedDeposit,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remains_second'] = remainsSecond;
    map['returned_deposit'] = returnedDeposit;
    return map;
  }
}
