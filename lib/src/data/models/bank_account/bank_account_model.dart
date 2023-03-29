import 'package:exxe/src/utils/utils.dart';

import 'bank_model.dart';

class BankAccountModel {
  BankAccountModel({
    this.bankId,
    this.accountNumber,
    this.bankOwner,
    this.bankExpireDate,
  });

  BankAccountModel.fromJson(dynamic json) {
    bankId =
        json['bank_id'] != null ? BankModel.fromJson(json['bank_id']) : null;
    accountNumber = safeParse(json['account_number']);
    bankOwner = safeParse(json['bank_owner']);
    bankExpireDate = safeParse(json['bank_expire_date']);
  }

  BankModel? bankId;
  String? accountNumber;
  String? bankOwner;
  DateTime? bankExpireDate;

  BankAccountModel copyWith({
    BankModel? bankId,
    String? accountNumber,
    String? bankOwner,
    DateTime? bankExpireDate,
  }) =>
      BankAccountModel(
        bankId: bankId ?? this.bankId,
        accountNumber: accountNumber ?? this.accountNumber,
        bankOwner: bankOwner ?? this.bankOwner,
        bankExpireDate: bankExpireDate ?? this.bankExpireDate,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bankId != null) {
      map['bank_id'] = bankId?.toJson();
    }
    map['account_number'] = accountNumber;
    map['bank_owner'] = bankOwner;
    map['bank_expire_date'] = bankExpireDate;
    return map;
  }
}
