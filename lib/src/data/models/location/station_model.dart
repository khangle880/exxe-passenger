import '../../../utils/utils.dart';
import '../models.dart';

/// station_name : "Bến xe khách trung tâm TP Thái Nguyên "
/// station_id : 719
/// station_image : {"id":false,"url":false}
/// latitude : "21.5760836"
/// longitude : "105.8265629"
/// country_id : {"country_id":241,"country_name":"Vietnam","country_vietnamese_name":false}
/// province_id : {"province_id":1099,"province_name":"Thái Nguyên","province_short_name":"T.Nguyên","province_brief_name":"Thái Nguyên","province_vietnamese_name":"thainguyen","image_url":{"id":592,"url":"/management_ghn_integration/static/src/img/odoosmes-com-thainguyen-RiSJJEDhx3Uofhou32zOJF959JBf0WEU.png"},"latitude":"21.5708609","longitude":"105.8035911","ghn_province_id":244}
/// district_id : {"district_id":false,"district_name":false,"district_vietnamese_name":false,"district_vietnamese_code":false,"ghn_district_id":0}
/// ward_id : {"ward_id":false,"ward_name":false,"ward_vietnamese_name":false,"ward_vietnamese_code":false,"ghn_ward_id":false}
/// street : "Ngõ 398 đường Thống Nhất, Đồng Quang, TP. Thái Nguyên, Thái Nguyên, Vietnam"

class StationModel {
  StationModel({
    String? stationName,
    num? stationId,
    ImageModel? stationImage,
    String? latitude,
    String? longitude,
    CountryModel? countryId,
    ProvinceModel? provinceId,
    DistrictModel? districtId,
    WardModel? wardId,
    String? street,
  }) {
    _stationName = stationName;
    _stationId = stationId;
    _stationImage = stationImage;
    _latitude = latitude;
    _longitude = longitude;
    _countryId = countryId;
    _provinceId = provinceId;
    _districtId = districtId;
    _wardId = wardId;
    _street = street;
  }

  StationModel.fromJson(dynamic json) {
    _stationName = safeParse(json['station_name']);
    _stationId = safeParse(json['station_id']);
    _stationImage = json['station_image'] != null
        ? ImageModel.fromJson(json['station_image'])
        : null;
    _latitude = safeParse(json['latitude']);
    _longitude = safeParse(json['longitude']);
    _countryId = json['country_id'] != null
        ? CountryModel.fromJson(json['country_id'])
        : null;
    _provinceId = json['province_id'] != null
        ? ProvinceModel.fromJson(json['province_id'])
        : null;
    _districtId = json['district_id'] != null
        ? DistrictModel.fromJson(json['district_id'])
        : null;
    _wardId =
        json['ward_id'] != null ? WardModel.fromJson(json['ward_id']) : null;
    _street = safeParse(json['street']);
  }

  String? _stationName;
  num? _stationId;
  ImageModel? _stationImage;
  String? _latitude;
  String? _longitude;
  CountryModel? _countryId;
  ProvinceModel? _provinceId;
  DistrictModel? _districtId;
  WardModel? _wardId;
  String? _street;

  StationModel copyWith({
    String? stationName,
    num? stationId,
    ImageModel? stationImage,
    String? latitude,
    String? longitude,
    CountryModel? countryId,
    ProvinceModel? provinceId,
    DistrictModel? districtId,
    WardModel? wardId,
    String? street,
  }) =>
      StationModel(
        stationName: stationName ?? _stationName,
        stationId: stationId ?? _stationId,
        stationImage: stationImage ?? _stationImage,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        countryId: countryId ?? _countryId,
        provinceId: provinceId ?? _provinceId,
        districtId: districtId ?? _districtId,
        wardId: wardId ?? _wardId,
        street: street ?? _street,
      );

  String? get stationName => _stationName;

  num? get stationId => _stationId;

  ImageModel? get stationImage => _stationImage;

  String? get latitude => _latitude;

  String? get longitude => _longitude;

  CountryModel? get countryId => _countryId;

  ProvinceModel? get provinceId => _provinceId;

  DistrictModel? get districtId => _districtId;

  WardModel? get wardId => _wardId;

  String? get street => _street;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['station_name'] = _stationName;
    map['station_id'] = _stationId;
    if (_stationImage != null) {
      map['station_image'] = _stationImage?.toJson();
    }
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    if (_countryId != null) {
      map['country_id'] = _countryId?.toJson();
    }
    if (_provinceId != null) {
      map['province_id'] = _provinceId?.toJson();
    }
    if (_districtId != null) {
      map['district_id'] = _districtId?.toJson();
    }
    if (_wardId != null) {
      map['ward_id'] = _wardId?.toJson();
    }
    map['street'] = _street;
    return map;
  }
}
