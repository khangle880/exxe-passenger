import 'package:exxe/src/utils/utils.dart';

/// cancel_reason_id : 47
/// reason : "Tôi muốn thay đổi hình thức thanh toán"

class CancelReasonModel {
  CancelReasonModel({
    num? cancelReasonId,
    String? reason,
  }) {
    _cancelReasonId = cancelReasonId;
    _reason = reason;
  }

  CancelReasonModel.fromJson(dynamic json) {
    _cancelReasonId = safeParse(json['cancel_reason_id']);
    _reason = safeParse(json['reason']);
  }

  num? _cancelReasonId;
  String? _reason;

  CancelReasonModel copyWith({
    num? cancelReasonId,
    String? reason,
  }) =>
      CancelReasonModel(
        cancelReasonId: cancelReasonId ?? _cancelReasonId,
        reason: reason ?? _reason,
      );

  num? get cancelReasonId => _cancelReasonId;

  String? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cancel_reason_id'] = _cancelReasonId;
    map['reason'] = _reason;
    return map;
  }
}
