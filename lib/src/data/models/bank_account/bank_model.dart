import 'package:exxe/src/utils/utils.dart';

import '../../../utils/export/logic_export.dart';

class BankModel {
  BankModel({
    this.bankId,
    this.bankName,
    this.bankBriefName,
    this.imageModel,
  });

  BankModel.fromJson(dynamic json) {
    bankId = safeParse(json['bank_id']);
    bankName = safeParse(json['bank_name']);
    bankBriefName = safeParse(json['bank_brief_name']);
    imageModel =
        json['icon_url'] != null ? ImageModel.fromJson(json['icon_url']) : null;
  }

  int? bankId;
  String? bankName;
  String? bankBriefName;
  ImageModel? imageModel;

  BankModel copyWith({
    int? bankId,
    String? bankName,
    String? bankBriefName,
  }) =>
      BankModel(
        bankId: bankId ?? this.bankId,
        bankName: bankName ?? this.bankName,
        bankBriefName: bankBriefName ?? this.bankBriefName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bank_id'] = bankId;
    map['bank_name'] = bankName;
    map['bank_brief_name'] = bankBriefName;
    return map;
  }
}
