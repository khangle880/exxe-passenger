import 'package:exxe/src/utils/export/ui_export.dart';

class AvailableMoneyModel {
  AvailableMoneyModel({
    this.moneyInCashWallet,
  });

  AvailableMoneyModel.fromJson(dynamic json) {
    moneyInCashWallet = safeParse(json['money_in_cash_wallet']);
  }

  num? moneyInCashWallet;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['money_in_cash_wallet'] = moneyInCashWallet;
    return map;
  }
}
