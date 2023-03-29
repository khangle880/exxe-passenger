import '../../../utils/parser_utils.dart';

class ComputePriceModel {
  ComputePriceModel({
    this.maxDistanceTravelingInDay,
    this.numberKmPerDay,
    this.serviceFeePercent,
    this.personIncomeTax,
  });

  ComputePriceModel.fromJson(dynamic json) {
    maxDistanceTravelingInDay =
        safeParse(json['max_distance_traveling_in_day']);
    numberKmPerDay = safeParse(json['number_km_per_day']);
    serviceFeePercent = safeParse(json['service_fee_percent']);
    personIncomeTax = safeParse(json['person_income_tax']);
  }

  num? maxDistanceTravelingInDay;
  num? numberKmPerDay;
  num? serviceFeePercent;
  num? personIncomeTax;

  ComputePriceModel copyWith({
    num? maxDistanceTravelingInDay,
    num? numberKmPerDay,
    num? serviceFeePercent,
    num? personIncomeTax,
  }) =>
      ComputePriceModel(
        maxDistanceTravelingInDay:
            maxDistanceTravelingInDay ?? this.maxDistanceTravelingInDay,
        numberKmPerDay: numberKmPerDay ?? this.numberKmPerDay,
        serviceFeePercent: serviceFeePercent ?? this.serviceFeePercent,
        personIncomeTax: personIncomeTax ?? this.personIncomeTax,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['max_distance_traveling_in_day'] = maxDistanceTravelingInDay;
    map['number_km_per_day'] = numberKmPerDay;
    map['service_fee_percent'] = serviceFeePercent;
    map['person_income_tax'] = personIncomeTax;
    return map;
  }
}
