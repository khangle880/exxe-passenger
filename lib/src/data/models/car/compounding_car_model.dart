import '../../../utils/utils.dart';
import '../models.dart';

/// compounding_car_id : 525
/// compounding_car_code : "C3PGE - HIGDX - T413C - KBBS2"
/// compounding_car_name : "Compounding: From An Giang to TP Hồ Chí Minh"
/// car_driver_id : {"partner_id":false,"partner_name":false,"phone":false,"avatar_url":{"image_id":false,"image_url":false},"car_information":[],"rating_number":0.0}
/// compounding_type : "compounding"
/// from_province : {"province_id":1044,"province_name":"An Giang","province_short_name":"A.Giang","province_brief_name":"An Giang","province_vietnamese_name":"angiang","image_url":{"id":5,"url":"/management_ghn_integration/static/src/img/odoosmes-com-angiang-1657707544.png"},"latitude":"10.3747638","longitude":"105.4171817"}
/// to_province : {"province_id":1066,"province_name":"TP Hồ Chí Minh","province_short_name":"TP.HCM","province_brief_name":"TP.HCM","province_vietnamese_name":"hochiminh","image_url":{"id":150,"url":"/management_ghn_integration/static/src/img/odoosmes-com-hochiminh-1657707551.png"},"latitude":"10.7718733","longitude":"106.6952249"}
/// expected_going_on_date : "2022-08-25 18:00:00"
/// expected_picking_up_date : false
/// car : {"car_id":2,"name":"XE 5 CHỖ","number_seat":4,"icon":{"icon_id":false,"icon_url":false}}
/// number_seat_in_car : 4
/// is_a_day_tour : false
/// hour_of_wait_time : false
/// distance : 135.0
/// duration : 2
/// state : "waiting"
/// car_driver_deposit_percentage : "20.0"
/// quality_car : "4_star"
/// number_available_seat : 2
/// price_unit : {"price_distance_unit_id":5,"name":"Price By Distance From 120.0 Kms To 160.0 Kms - XE 5 CHỖ","car_id":{"car_id":2,"name":"XE 5 CHỖ","icon":{"icon_id":false,"icon_url":false}},"price_unit_per_km":12500.0,"price_unit":675000}
/// note : ""
/// deposit_date : false
/// second_remains : 0
/// from_pick_up_station : {"station_name":false,"station_id":false,"station_image":{"id":false,"url":false},"latitude":false,"longitude":false}
/// from_address : false
/// from_longitude : false
/// from_latitude : false
/// to_pick_up_station : {"station_name":false,"station_id":false,"station_image":{"id":false,"url":false},"latitude":false,"longitude":false}
/// to_address : false
/// to_longitude : false
/// to_latitude : false

/// compounding_car_id : false
/// compounding_car_name : false

class CompoundingCarModel {
  CompoundingCarModel({
    this.compoundingCarId,
    this.compoundingCarCode,
    this.compoundingCarName,
    this.carDriverId,
    this.compoundingType,
    this.fromProvince,
    this.toProvince,
    this.expectedGoingOnDate,
    this.expectedPickingUpDate,
    this.car,
    this.numberSeatInCar,
    this.isADayTour,
    this.hourOfWaitTime,
    this.distance,
    this.duration,
    this.state,
    this.carDriverDepositPercentage,
    this.qualityCar,
    this.numberAvailableSeat,
    this.priceUnit,
    this.note,
    this.depositDate,
    this.secondRemains,
    this.fromPickUpStation,
    this.fromAddress,
    this.fromLongitude,
    this.fromLatitude,
    this.toPickUpStation,
    this.toAddress,
    this.toLongitude,
    this.toLatitude,
    this.carPriceModels,
  });

  CompoundingCarModel.fromJson(dynamic json) {
    compoundingCarId = safeParse(json['compounding_car_id']);
    compoundingCarCode = safeParse(json['compounding_car_code']);
    compoundingCarName = safeParse(json['compounding_car_name']);
    carDriverId = json['car_driver_id'] != null
        ? CarDriverModel.fromJson(json['car_driver_id'])
        : null;
    compoundingType =
        safeParse(json['compounding_type'], payload: CompoundingType.values);
    fromProvince = json['from_province'] != null
        ? ProvinceModel.fromJson(json['from_province'])
        : null;
    toProvince = json['to_province'] != null
        ? ProvinceModel.fromJson(json['to_province'])
        : null;
    expectedGoingOnDate = safeParse(json['expected_going_on_date']);
    expectedPickingUpDate = safeParse(json['expected_picking_up_date']);
    car = json['car'] != null ? CarModel.fromJson(json['car']) : null;
    numberSeatInCar = safeParse(json['number_seat_in_car']);
    isADayTour = safeParse(json['is_a_day_tour']);
    hourOfWaitTime = safeParse(json['hour_of_wait_time']);
    distance = safeParse(json['distance']);
    duration = safeParse(json['duration']);
    state = safeParse(json['state'], payload: CompoundingCarState.values);
    carDriverDepositPercentage =
        safeParse(json['car_driver_deposit_percentage']);
    qualityCar = safeParse(json['quality_car']);
    numberAvailableSeat = safeParse(json['number_available_seat']);
    priceUnit = json['price_unit'] != null
        ? CarPriceModel.fromJson(json['price_unit'])
        : null;
    note = safeParse(json['note']);
    depositDate = safeParse(json['deposit_date']);
    secondRemains = safeParse(json['second_remains']);
    fromPickUpStation = json['from_pick_up_station'] != null
        ? StationModel.fromJson(json['from_pick_up_station'])
        : null;
    fromAddress = safeParse(json['from_address']);
    fromLongitude = safeParse(json['from_longitude']);
    fromLatitude = safeParse(json['from_latitude']);
    toPickUpStation = json['to_pick_up_station'] != null
        ? StationModel.fromJson(json['to_pick_up_station'])
        : null;
    toAddress = safeParse(json['to_address']);
    toLongitude = safeParse(json['to_longitude']);
    toLatitude = safeParse(json['to_latitude']);
  }

  num? compoundingCarId;
  String? compoundingCarCode;
  String? compoundingCarName;
  CarDriverModel? carDriverId;
  CompoundingType? compoundingType;
  ProvinceModel? fromProvince;
  ProvinceModel? toProvince;
  DateTime? expectedGoingOnDate;
  DateTime? expectedPickingUpDate;
  CarModel? car;
  num? numberSeatInCar;
  bool? isADayTour;
  num? hourOfWaitTime;
  num? distance;
  num? duration;
  CompoundingCarState? state;
  String? carDriverDepositPercentage;
  String? qualityCar;
  num? numberAvailableSeat;
  CarPriceModel? priceUnit;
  String? note;
  DateTime? depositDate;
  num? secondRemains;
  StationModel? fromPickUpStation;
  String? fromAddress;
  double? fromLongitude;
  double? fromLatitude;
  StationModel? toPickUpStation;
  String? toAddress;
  double? toLongitude;
  double? toLatitude;
  List<CarPriceModel>? carPriceModels;

  num? get numberSeat =>
      (numberAvailableSeat != null && numberSeatInCar != null)
          ? numberSeatInCar! - numberAvailableSeat!
          : null;

  bool get shouldShow => state != null && compoundingType != null;

  LocationModel get fromLocation => LocationModel(
        coordinate: CoordinateModel(
          latitude: fromLatitude?.toDouble() ?? 0,
          longitude: fromLongitude?.toDouble() ?? 0,
        ),
        address: fromAddress,
        province: fromProvince,
        station: fromPickUpStation,
      );

  LocationModel get toLocation => LocationModel(
        coordinate: CoordinateModel(
          latitude: toLatitude?.toDouble() ?? 0,
          longitude: toLongitude?.toDouble() ?? 0,
        ),
        address: toAddress,
        province: toProvince,
        station: toPickUpStation,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['compounding_car_id'] = compoundingCarId;
    map['compounding_car_code'] = compoundingCarCode;
    map['compounding_car_name'] = compoundingCarName;
    if (carDriverId != null) {
      map['car_driver_id'] = carDriverId?.toJson();
    }
    map['compounding_type'] = compoundingType;
    if (fromProvince != null) {
      map['from_province'] = fromProvince?.toJson();
    }
    if (toProvince != null) {
      map['to_province'] = toProvince?.toJson();
    }
    map['expected_going_on_date'] = expectedGoingOnDate;
    map['expected_picking_up_date'] = expectedPickingUpDate;
    if (car != null) {
      map['car'] = car?.toJson();
    }
    map['number_seat_in_car'] = numberSeatInCar;
    map['is_a_day_tour'] = isADayTour;
    map['hour_of_wait_time'] = hourOfWaitTime;
    map['distance'] = distance;
    map['duration'] = duration;
    map['state'] = state;
    map['car_driver_deposit_percentage'] = carDriverDepositPercentage;
    map['quality_car'] = qualityCar;
    map['number_available_seat'] = numberAvailableSeat;
    if (priceUnit != null) {
      map['price_unit'] = priceUnit?.toJson();
    }
    map['note'] = note;
    map['deposit_date'] = depositDate;
    map['second_remains'] = secondRemains;
    if (fromPickUpStation != null) {
      map['from_pick_up_station'] = fromPickUpStation?.toJson();
    }
    map['from_address'] = fromAddress;
    map['from_longitude'] = fromLongitude;
    map['from_latitude'] = fromLatitude;
    if (toPickUpStation != null) {
      map['to_pick_up_station'] = toPickUpStation?.toJson();
    }
    map['to_address'] = toAddress;
    map['to_longitude'] = toLongitude;
    map['to_latitude'] = toLatitude;
    return map;
  }
}
