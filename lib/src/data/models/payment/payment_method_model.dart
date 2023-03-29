import '../../../utils/parser_utils.dart';
import '../models.dart';

/// acquirer_id : 16
/// name : "Ví EXXE"
/// brief : false
/// provider : "exxe_wallet"
/// state : "enabled"
/// image_url : {"id":false,"url":false}
/// money_in_bank_wallet : 11341954.0
/// money_in_cash_wallet : 12324000.0

class PaymentMethodModel {
  PaymentMethodModel({
    this.acquirerId,
    this.name,
    this.brief,
    this.provider,
    this.state,
    this.imageUrl,
    this.moneyInBankWallet,
    this.moneyInCashWallet,
  });

  PaymentMethodModel.fromJson(dynamic json) {
    acquirerId = safeParse(json['acquirer_id']);
    name = safeParse(json['name']);
    brief = safeParse(json['brief']);
    provider = safeParse(json['provider']);
    state = safeParse(json['state']);
    imageUrl = json['image_url'] != null
        ? ImageModel.fromJson(json['image_url'])
        : null;
    moneyInBankWallet = safeParse(json['money_in_bank_wallet']);
    moneyInCashWallet = safeParse(json['money_in_cash_wallet']);
  }

  num? acquirerId;
  String? name;
  String? brief;
  String? provider;
  String? state;
  ImageModel? imageUrl;
  num? moneyInBankWallet;
  num? moneyInCashWallet;

  PaymentMethodModel copyWith({
    num? acquirerId,
    String? name,
    String? brief,
    String? provider,
    String? state,
    ImageModel? imageUrl,
    num? moneyInBankWallet,
    num? moneyInCashWallet,
  }) =>
      PaymentMethodModel(
        acquirerId: acquirerId ?? this.acquirerId,
        name: name ?? this.name,
        brief: brief ?? this.brief,
        provider: provider ?? this.provider,
        state: state ?? this.state,
        imageUrl: imageUrl ?? this.imageUrl,
        moneyInBankWallet: moneyInBankWallet ?? this.moneyInBankWallet,
        moneyInCashWallet: moneyInCashWallet ?? this.moneyInCashWallet,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['acquirer_id'] = acquirerId;
    map['name'] = name;
    map['brief'] = brief;
    map['provider'] = provider;
    map['state'] = state;
    if (imageUrl != null) {
      map['image_url'] = imageUrl?.toJson();
    }
    map['money_in_bank_wallet'] = moneyInBankWallet;
    map['money_in_cash_wallet'] = moneyInCashWallet;
    return map;
  }
}
