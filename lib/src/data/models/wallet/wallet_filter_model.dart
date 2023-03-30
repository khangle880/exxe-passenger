import '../models.dart';

class FilteredTransactionsModel {
  FilteredTransactionsModel({
      this.transaction
  });

  FilteredTransactionsModel.fromJson(dynamic json) {
    if (json['transaction'] != null) {
      transaction = [];
      json['transaction'].forEach((v) {
        transaction!.add(PaymentModel.fromJson(v));
      });
    }
  }
  List<PaymentModel>? transaction;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (transaction != null) {
      map['transaction'] = transaction!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}