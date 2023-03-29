// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exxe/src/data/models/models.dart';

class LocationModel {
  final CoordinateModel? coordinate;
  final String? address;
  int? provinceId;
  final List<StationModel>? stations;
  int? stationId;
  final StationModel? station;
  final ProvinceModel? province;
  final DistrictModel? district;
  final WardModel? ward;

  LocationModel({
    this.coordinate,
    this.district,
    this.ward,
    this.address,
    this.provinceId,
    this.stations,
    this.stationId,
    this.province,
    this.station,
  }) {
    provinceId = provinceId ?? province?.provinceId?.ceil();
    stationId = stationId ?? station?.stationId?.ceil();
  }

  LocationModel copyWith({
    CoordinateModel? coordinate,
    Nullable<String>? address,
    int? provinceId,
    List<StationModel>? stations,
    int? stationId,
    ProvinceModel? province,
    StationModel? station,
  }) {
    return LocationModel(
      coordinate: coordinate ?? this.coordinate,
      address: address == null ? this.address : address.value,
      provinceId: provinceId ?? this.provinceId,
      stations: stations ?? this.stations,
      stationId: stationId ?? this.stationId,
      province: province ?? this.province,
      station: station ?? this.station,
    );
  }

  String? get addressShow =>
      address ?? station?.stationName ?? province?.provinceName;

  String? get fullAddress {
    return "$address, ${ward?.wardName}, ${district?.districtName}, ${province?.provinceName}";
  }
}
