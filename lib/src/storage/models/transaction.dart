import 'dart:developer';

import 'package:hive/hive.dart';

import '../../utils/constants/constants.dart';

part 'transaction.g.dart';

@HiveType(typeId: 5)
class TransactionHiveModel extends HiveObject {
  @HiveField(0)
  String vnPayCode;

  @HiveField(1)
  String? paymentId;

  @HiveField(2)
  String? compoundingCarCustomerId;

  TransactionHiveModel({
    required this.vnPayCode,
    this.paymentId,
    this.compoundingCarCustomerId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionHiveModel &&
          runtimeType == other.runtimeType &&
          vnPayCode == other.vnPayCode;

  @override
  int get hashCode => vnPayCode.hashCode;
}

class TransactionHiveBox {
  static TransactionHiveBox instance = TransactionHiveBox();
  static const String boxName = HiveBoxName.transactionBox;

  late Future<Box<TransactionHiveModel>> _box;

  TransactionHiveBox() {
    _box = Hive.openBox(boxName);
  }

  Future<void> saveTransaction(TransactionHiveModel transaction) async {
    var box = await _box;
    try {
      await box.put(DateTime.now().toIso8601String(), transaction);
    } finally {}
    log('Current data in box ${box.length}');
  }

  Future<List<TransactionHiveModel>> readTransaction() async {
    var box = await _box;
    return box.values.toList();
  }

  Future<void> deleteTransaction(String? vnPayCode) async {
    if (vnPayCode == null) {
      return;
    }
    var box = await _box;
    var map = box.toMap();
    var key = map.keys
        .firstWhere((k) => map[k]?.vnPayCode == vnPayCode, orElse: () => null);
    log('deleted trans key $key');
    if (key != null) {
      await box.delete(key);
    }
    log('Current failed trans ${box.length}');
  }

  Future<void> clearAllTransaction() async {
    var box = await _box;
    await box.clear();
    log('Current failed trans ${box.length}');
  }
}
