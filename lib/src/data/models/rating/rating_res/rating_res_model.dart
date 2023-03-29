import 'package:exxe/src/data/data.dart';

import 'duration.dart';
import 'partner_id.dart';

class RatingResModel {
  RatingResModel({
    this.compoundingCarId,
    this.compoundingCarCustomerId,
    this.compoundingCarCustomerCode,
    this.compoundingCarCustomerName,
    this.partnerId,
    this.duration,
    this.ratingId,
    this.ratingTagIds,
    this.ratingNumber,
    this.ratingContent,
  });

  RatingResModel.fromJson(dynamic json) {
    compoundingCarId = json['compounding_car_id'];
    compoundingCarCustomerId = json['compounding_car_customer_id'];
    compoundingCarCustomerCode = json['compounding_car_customer_code'];
    compoundingCarCustomerName = json['compounding_car_customer_name'];
    partnerId = json['partner_id'] != null
        ? PartnerId.fromJson(json['partner_id'])
        : null;
    duration =
        json['duration'] != null ? Duration.fromJson(json['duration']) : null;
    ratingId = json['rating_id'];
    if (json['rating_tag_ids'] != null) {
      ratingTagIds = [];
      json['rating_tag_ids'].forEach((v) {
        ratingTagIds?.add(RatingHashtagModel.fromJson(v));
      });
    }
    ratingNumber = json['rating_number'];
    ratingContent = json['rating_content'];
  }

  num? compoundingCarId;
  num? compoundingCarCustomerId;
  String? compoundingCarCustomerCode;
  String? compoundingCarCustomerName;
  PartnerId? partnerId;
  Duration? duration;
  num? ratingId;
  List<RatingHashtagModel>? ratingTagIds;
  num? ratingNumber;
  String? ratingContent;

  RatingResModel copyWith({
    num? compoundingCarId,
    num? compoundingCarCustomerId,
    String? compoundingCarCustomerCode,
    String? compoundingCarCustomerName,
    PartnerId? partnerId,
    Duration? duration,
    num? ratingId,
    List<RatingHashtagModel>? ratingTagIds,
    num? ratingNumber,
    String? ratingContent,
  }) =>
      RatingResModel(
        compoundingCarId: compoundingCarId ?? this.compoundingCarId,
        compoundingCarCustomerId:
            compoundingCarCustomerId ?? this.compoundingCarCustomerId,
        compoundingCarCustomerCode:
            compoundingCarCustomerCode ?? this.compoundingCarCustomerCode,
        compoundingCarCustomerName:
            compoundingCarCustomerName ?? this.compoundingCarCustomerName,
        partnerId: partnerId ?? this.partnerId,
        duration: duration ?? this.duration,
        ratingId: ratingId ?? this.ratingId,
        ratingTagIds: ratingTagIds ?? this.ratingTagIds,
        ratingNumber: ratingNumber ?? this.ratingNumber,
        ratingContent: ratingContent ?? this.ratingContent,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['compounding_car_id'] = compoundingCarId;
    map['compounding_car_customer_id'] = compoundingCarCustomerId;
    map['compounding_car_customer_code'] = compoundingCarCustomerCode;
    map['compounding_car_customer_name'] = compoundingCarCustomerName;
    if (partnerId != null) {
      map['partner_id'] = partnerId?.toJson();
    }
    if (duration != null) {
      map['duration'] = duration?.toJson();
    }
    map['rating_id'] = ratingId;
    if (ratingTagIds != null) {
      map['rating_tag_ids'] = ratingTagIds?.map((v) => v.toJson()).toList();
    }
    map['rating_number'] = ratingNumber;
    map['rating_content'] = ratingContent;
    return map;
  }
}
