import '../../../utils/utils.dart';
import '../models.dart';

/// car_id : {"car_id":2,"name":"XE 5 CHỖ","icon":{"icon_id":false,"icon_url":false}}
/// price_unit : 5000000

class CarPriceModel {
  CarPriceModel({
    CarModel? carId,
    num? priceUnit,
  }) {
    _carId = carId;
    _priceUnit = priceUnit;
  }

  CarPriceModel.fromJson(dynamic json) {
    _carId = json['car_id'] != null ? CarModel.fromJson(json['car_id']) : null;
    _priceUnit = safeParse(json['price_unit']);
  }

  CarModel? _carId;
  num? _priceUnit;

  CarPriceModel copyWith({
    num? priceDistanceUnitId,
    String? name,
    CarModel? carId,
    num? priceUnitPerKm,
    num? priceUnit,
  }) =>
      CarPriceModel(
        carId: carId ?? _carId,
        priceUnit: priceUnit ?? _priceUnit,
      );

  CarModel? get carId => _carId;

  num? get priceUnit => _priceUnit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_carId != null) {
      map['car_id'] = _carId?.toJson();
    }
    map['price_unit'] = _priceUnit;
    return map;
  }
}
