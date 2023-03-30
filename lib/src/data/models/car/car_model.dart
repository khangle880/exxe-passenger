import '../../../utils/utils.dart';
import '../models.dart';

/// car_id : 2
/// name : "XE 5 CHỖ"
/// number_seat : 4
/// icon : {"icon_id":false,"icon_url":false}

class CarModel {
  CarModel({
    num? carId,
    String? name,
    num? numberSeat,
    IconModel? icon,
  }) {
    _carId = carId;
    _name = name;
    _numberSeat = numberSeat;
    _icon = icon;
  }

  CarModel.fromJson(dynamic json) {
    _carId = safeParse(json['car_id']);
    _name = safeParse(json['name']);
    _numberSeat = safeParse(json['number_seat']);
    _icon = json['icon'] != null ? IconModel.fromJson(json['icon']) : null;
  }

  num? _carId;
  String? _name;
  num? _numberSeat;
  IconModel? _icon;

  CarModel copyWith({
    num? carId,
    String? name,
    num? numberSeat,
    IconModel? icon,
  }) =>
      CarModel(
        carId: carId ?? _carId,
        name: name ?? _name,
        numberSeat: numberSeat ?? _numberSeat,
        icon: icon ?? _icon,
      );

  num? get carId => _carId;

  String? get name => _name;

  num? get numberSeat => _numberSeat;

  IconModel? get icon => _icon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['car_id'] = _carId;
    map['name'] = _name;
    map['number_seat'] = _numberSeat;
    if (_icon != null) {
      map['icon'] = _icon?.toJson();
    }
    return map;
  }
}
