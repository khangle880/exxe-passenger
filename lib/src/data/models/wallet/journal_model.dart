import '../../../utils/utils.dart';

/// journal_id : 45
/// journal_name : "Passenger Bank Wallet: USER-0987147539"
/// journal_type : "bank"
/// journal_owner_id : {"partner_id":50,"partner_name":"USER-0987147539","phone":"0987147539","avatar_url":{"image_id":231,"image_url":"/manage_detail_data/static/src/img/stored-attachment-module-ceSiVSqnc1AnW1eqvzsSKtwoMK8gttH9-1660278564-ouFKmADFWhLUpS7z7QSWdRPXWRRClYIn-1660278564.png"}}
/// wallet_type : false
/// remains_amount : 26158320.0

class JournalModel {
  JournalModel({
    num? journalId,
    String? journalName,
    JournalType? journalType,
    JournalModel? journal,
    String? walletType,
    num? remainsAmount,
  }) {
    _journalId = journalId;
    _journalName = journalName;
    _journalType = journalType;
    _journalOwnerId = journal;
    _walletType = walletType;
    _remainsAmount = remainsAmount;
  }

  JournalModel.fromJson(dynamic json) {
    _journalId = safeParse(json['journal_id']);
    _journalName = safeParse(json['journal_name']);
    _journalType = safeParse(json['journal_type'], payload: JournalType.values);
    _journalOwnerId = json['journal_owner_id'] != null
        ? JournalModel.fromJson(json['journal_owner_id'])
        : null;
    _walletType = safeParse(json['wallet_type']);
    _remainsAmount = safeParse(json['remains_amount']);
  }

  num? _journalId;
  String? _journalName;
  JournalType? _journalType;
  JournalModel? _journalOwnerId;
  String? _walletType;
  num? _remainsAmount;

  JournalModel copyWith({
    num? journalId,
    String? journalName,
    JournalType? journalType,
    JournalModel? journalOwnerId,
    String? walletType,
    num? remainsAmount,
  }) =>
      JournalModel(
        journalId: journalId ?? _journalId,
        journalName: journalName ?? _journalName,
        journalType: journalType ?? _journalType,
        journal: journalOwnerId ?? _journalOwnerId,
        walletType: walletType ?? _walletType,
        remainsAmount: remainsAmount ?? _remainsAmount,
      );

  num? get journalId => _journalId;

  String? get journalName => _journalName;

  JournalType? get journalType => _journalType;

  JournalModel? get journalOwnerId => _journalOwnerId;

  String? get walletType => _walletType;

  num? get remainsAmount => _remainsAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['journal_id'] = _journalId;
    map['journal_name'] = _journalName;
    map['journal_type'] = _journalType;
    if (_journalOwnerId != null) {
      map['journal_owner_id'] = _journalOwnerId?.toJson();
    }
    map['wallet_type'] = _walletType;
    map['remains_amount'] = _remainsAmount;
    return map;
  }
}
