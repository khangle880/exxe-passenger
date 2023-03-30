import 'dart:math';

import 'package:exxe/src/utils/extensions/extensions.dart';

import '../../../utils/parser_utils.dart';

class WaitingChargeBlockModel {
  WaitingChargeBlockModel({
    this.blockId,
    this.blockName,
    this.numberHour,
    this.maxDistance,
    this.maxDuration,
    this.minDate,
    this.maxDate,
    this.priceUnit,
    this.priority = false,
  });

  WaitingChargeBlockModel.fromJson(dynamic json) {
    blockId = safeParse(json['block_id']);
    blockName = safeParse(json['block_name']);
    numberHour = safeParse(json['number_hour']);
    maxDistance = safeParse(json['max_distance']);
    maxDuration = safeParse(json['max_duration']);
    priceUnit = safeParse(json['price_unit']);
  }

  num? blockId;
  String? blockName;
  num? numberHour;
  num? maxDistance;
  num? maxDuration;
  DateTime? minDate;
  DateTime? maxDate;
  num? priceUnit;
  bool? priority;

  WaitingChargeBlockModel copyWith({
    num? blockId,
    String? blockName,
    num? numberHour,
    num? maxDistance,
    num? maxDuration,
    DateTime? minDate,
    DateTime? maxDate,
    num? priceUnit,
  }) =>
      WaitingChargeBlockModel(
        blockId: blockId ?? this.blockId,
        blockName: blockName ?? this.blockName,
        numberHour: numberHour ?? this.numberHour,
        maxDistance: maxDistance ?? this.maxDistance,
        maxDuration: maxDuration ?? this.maxDuration,
        minDate: minDate ?? this.minDate,
        maxDate: maxDate ?? this.maxDate,
        priceUnit: priceUnit ?? this.priceUnit,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['block_id'] = blockId;
    map['block_name'] = blockName;
    map['number_hour'] = numberHour;
    map['max_distance'] = maxDistance;
    map['max_duration'] = maxDuration;
    map['price_unit'] = priceUnit;
    return map;
  }

  int endBlockTime(int timeInDay) {
    final endDay = const Duration(hours: 23, minutes: 45).inMilliseconds;
    final endBlockTime =
        min(timeInDay + (numberHour ?? 0).hourToMilliseconds, endDay);
    return endBlockTime;
  }
}
