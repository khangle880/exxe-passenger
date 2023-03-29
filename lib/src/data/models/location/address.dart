import '../../../utils/utils.dart';
import '../models.dart';

/// ward_id : false
/// ward_name : false
/// ward_vietnamese_name : false
/// ward_vietnamese_code : false
/// ghn_ward_id : false

class WardModel {
  WardModel({
    num? wardId,
    String? wardName,
    String? wardVietnameseName,
    String? wardVietnameseCode,
    num? ghnWardId,
  }) {
    _wardId = wardId;
    _wardName = wardName;
    _wardVietnameseName = wardVietnameseName;
    _wardVietnameseCode = wardVietnameseCode;
    _ghnWardId = ghnWardId;
  }

  WardModel.fromJson(dynamic json) {
    _wardId = safeParse(json['ward_id']);
    _wardName = safeParse(json['ward_name']);
    _wardVietnameseName = safeParse(json['ward_vietnamese_name']);
    _wardVietnameseCode = safeParse(json['ward_vietnamese_code']);
    _ghnWardId = safeParse(json['ghn_ward_id']);
  }

  num? _wardId;
  String? _wardName;
  String? _wardVietnameseName;
  String? _wardVietnameseCode;
  num? _ghnWardId;

  WardModel copyWith({
    num? wardId,
    String? wardName,
    String? wardVietnameseName,
    String? wardVietnameseCode,
    num? ghnWardId,
  }) =>
      WardModel(
        wardId: wardId ?? _wardId,
        wardName: wardName ?? _wardName,
        wardVietnameseName: wardVietnameseName ?? _wardVietnameseName,
        wardVietnameseCode: wardVietnameseCode ?? _wardVietnameseCode,
        ghnWardId: ghnWardId ?? _ghnWardId,
      );

  num? get wardId => _wardId;

  String? get wardName => _wardName;

  String? get wardVietnameseName => _wardVietnameseName;

  String? get wardVietnameseCode => _wardVietnameseCode;

  num? get ghnWardId => _ghnWardId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ward_id'] = _wardId;
    map['ward_name'] = _wardName;
    map['ward_vietnamese_name'] = _wardVietnameseName;
    map['ward_vietnamese_code'] = _wardVietnameseCode;
    map['ghn_ward_id'] = _ghnWardId;
    return map;
  }
}

/// district_id : false
/// district_name : false
/// district_vietnamese_name : false
/// district_vietnamese_code : false
/// ghn_district_id : 0

class DistrictModel {
  DistrictModel({
    num? districtId,
    String? districtName,
    String? districtVietnameseName,
    String? districtVietnameseCode,
    num? ghnDistrictId,
  }) {
    _districtId = districtId;
    _districtName = districtName;
    _districtVietnameseName = districtVietnameseName;
    _districtVietnameseCode = districtVietnameseCode;
    _ghnDistrictId = ghnDistrictId;
  }

  DistrictModel.fromJson(dynamic json) {
    _districtId = safeParse(json['district_id']);
    _districtName = safeParse(json['district_name']);
    _districtVietnameseName = safeParse(json['district_vietnamese_name']);
    _districtVietnameseCode = safeParse(json['district_vietnamese_code']);
    _ghnDistrictId = safeParse(json['ghn_district_id']);
  }

  num? _districtId;
  String? _districtName;
  String? _districtVietnameseName;
  String? _districtVietnameseCode;
  num? _ghnDistrictId;

  DistrictModel copyWith({
    num? districtId,
    String? districtName,
    String? districtVietnameseName,
    String? districtVietnameseCode,
    num? ghnDistrictId,
  }) =>
      DistrictModel(
        districtId: districtId ?? _districtId,
        districtName: districtName ?? _districtName,
        districtVietnameseName:
            districtVietnameseName ?? _districtVietnameseName,
        districtVietnameseCode:
            districtVietnameseCode ?? _districtVietnameseCode,
        ghnDistrictId: ghnDistrictId ?? _ghnDistrictId,
      );

  num? get districtId => _districtId;

  String? get districtName => _districtName;

  String? get districtVietnameseName => _districtVietnameseName;

  String? get districtVietnameseCode => _districtVietnameseCode;

  num? get ghnDistrictId => _ghnDistrictId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['district_id'] = _districtId;
    map['district_name'] = _districtName;
    map['district_vietnamese_name'] = _districtVietnameseName;
    map['district_vietnamese_code'] = _districtVietnameseCode;
    map['ghn_district_id'] = _ghnDistrictId;
    return map;
  }
}

/// province_id : 1099
/// province_name : "Thái Nguyên"
/// province_short_name : "T.Nguyên"
/// province_brief_name : "Thái Nguyên"
/// province_vietnamese_name : "thainguyen"
/// image_url : {"id":591,"url":"/management_ghn_integration/static/src/img/odoosmes-com-thainguyen-y3E5g8KUmPvYvLv9PEyG4mrQQbPA6bHE.png"}
/// latitude : "21.5708609"
/// longitude : "105.8035911"
/// ghn_province_id : 244
/// picking_up_stations : [{"station_name":"Bến xe khách trung tâm TP Thái Nguyên ","station_id":719,"station_image":{"id":false,"url":false},"latitude":"21.5760836","longitude":"105.8265629","country_id":{"country_id":241,"country_name":"Vietnam","country_vietnamese_name":false},"province_id":{"province_id":1099,"province_name":"Thái Nguyên","province_short_name":"T.Nguyên","province_brief_name":"Thái Nguyên","province_vietnamese_name":"thainguyen","image_url":{"id":592,"url":"/management_ghn_integration/static/src/img/odoosmes-com-thainguyen-RiSJJEDhx3Uofhou32zOJF959JBf0WEU.png"},"latitude":"21.5708609","longitude":"105.8035911","ghn_province_id":244},"district_id":{"district_id":false,"district_name":false,"district_vietnamese_name":false,"district_vietnamese_code":false,"ghn_district_id":0},"ward_id":{"ward_id":false,"ward_name":false,"ward_vietnamese_name":false,"ward_vietnamese_code":false,"ghn_ward_id":false},"street":"Ngõ 398 đường Thống Nhất, Đồng Quang, TP. Thái Nguyên, Thái Nguyên, Vietnam"},{"station_name":"Bến xe Phổ Yên","station_id":721,"station_image":{"id":false,"url":false},"latitude":"21.5657616","longitude":"105.6577772","country_id":{"country_id":241,"country_name":"Vietnam","country_vietnamese_name":false},"province_id":{"province_id":1099,"province_name":"Thái Nguyên","province_short_name":"T.Nguyên","province_brief_name":"Thái Nguyên","province_vietnamese_name":"thainguyen","image_url":{"id":593,"url":"/management_ghn_integration/static/src/img/odoosmes-com-thainguyen-miDFpMIHuF3DWRL0RiCWBEpFImgtOhfb.png"},"latitude":"21.5708609","longitude":"105.8035911","ghn_province_id":244},"district_id":{"district_id":false,"district_name":false,"district_vietnamese_name":false,"district_vietnamese_code":false,"ghn_district_id":0},"ward_id":{"ward_id":false,"ward_name":false,"ward_vietnamese_name":false,"ward_vietnamese_code":false,"ghn_ward_id":false},"street":"QL3, Ba Hàng, huyện Phổ Yên, Thái Nguyên, Thái Nguyên, Vietnam"},{"station_name":"Bến xe Đại Từ","station_id":722,"station_image":{"id":false,"url":false},"latitude":"21.6359679","longitude":"105.6458795","country_id":{"country_id":241,"country_name":"Vietnam","country_vietnamese_name":false},"province_id":{"province_id":1099,"province_name":"Thái Nguyên","province_short_name":"T.Nguyên","province_brief_name":"Thái Nguyên","province_vietnamese_name":"thainguyen","image_url":{"id":589,"url":"/management_ghn_integration/static/src/img/odoosmes-com-thainguyen-Nx94VbrKvApqGpPfdu4RpIIODJntBqNR.png"},"latitude":"21.5708609","longitude":"105.8035911","ghn_province_id":244},"district_id":{"district_id":false,"district_name":false,"district_vietnamese_name":false,"district_vietnamese_code":false,"ghn_district_id":0},"ward_id":{"ward_id":false,"ward_name":false,"ward_vietnamese_name":false,"ward_vietnamese_code":false,"ghn_ward_id":false},"street":"QL37, HuyỆN Đại Từ, Thái Nguyên, Thái Nguyên, Vietnam"},{"station_name":"Bến xe Đồng Quang","station_id":723,"station_image":{"id":false,"url":false},"latitude":"21.5833006","longitude":"105.8170762","country_id":{"country_id":241,"country_name":"Vietnam","country_vietnamese_name":false},"province_id":{"province_id":1099,"province_name":"Thái Nguyên","province_short_name":"T.Nguyên","province_brief_name":"Thái Nguyên","province_vietnamese_name":"thainguyen","image_url":{"id":590,"url":"/management_ghn_integration/static/src/img/odoosmes-com-thainguyen-2VJSxDJ63UqYZh8HVjhRfDdZ5m3TnYqR.png"},"latitude":"21.5708609","longitude":"105.8035911","ghn_province_id":244},"district_id":{"district_id":false,"district_name":false,"district_vietnamese_name":false,"district_vietnamese_code":false,"ghn_district_id":0},"ward_id":{"ward_id":false,"ward_name":false,"ward_vietnamese_name":false,"ward_vietnamese_code":false,"ghn_ward_id":false},"street":"Phường Quang Trung, Tp Thái Nguyên, Thái Nguyên, Vietnam"}]

class ProvinceModel {
  ProvinceModel({
    num? provinceId,
    String? provinceName,
    String? provinceShortName,
    String? provinceBriefName,
    String? provinceVietnameseName,
    ImageModel? imageUrl,
    String? latitude,
    String? longitude,
    num? ghnProvinceId,
    List<StationModel>? pickingUpStations,
  }) {
    _provinceId = provinceId;
    _provinceName = provinceName;
    _provinceShortName = provinceShortName;
    _provinceBriefName = provinceBriefName;
    _provinceVietnameseName = provinceVietnameseName;
    _imageUrl = imageUrl;
    _latitude = latitude;
    _longitude = longitude;
    _ghnProvinceId = ghnProvinceId;
    _pickingUpStations = pickingUpStations;
  }

  ProvinceModel.fromJson(dynamic json) {
    _provinceId = safeParse(json['province_id']);
    _provinceName = safeParse(json['province_name']);
    _provinceShortName = safeParse(json['province_short_name']);
    _provinceBriefName = safeParse(json['province_brief_name']);
    _provinceVietnameseName = safeParse(json['province_vietnamese_name']);
    _imageUrl = json['image_url'] != null
        ? ImageModel.fromJson(json['image_url'])
        : null;
    _latitude = safeParse(json['latitude']);
    _longitude = safeParse(json['longitude']);
    _ghnProvinceId = safeParse(json['ghn_province_id']);
    if (json['picking_up_stations'] != null) {
      _pickingUpStations = [];
      json['picking_up_stations'].forEach((v) {
        _pickingUpStations?.add(StationModel.fromJson(v));
      });
    }
  }

  num? _provinceId;
  String? _provinceName;
  String? _provinceShortName;
  String? _provinceBriefName;
  String? _provinceVietnameseName;
  ImageModel? _imageUrl;
  String? _latitude;
  String? _longitude;
  num? _ghnProvinceId;
  List<StationModel>? _pickingUpStations;

  ProvinceModel copyWith({
    num? provinceId,
    String? provinceName,
    String? provinceShortName,
    String? provinceBriefName,
    String? provinceVietnameseName,
    ImageModel? imageUrl,
    String? latitude,
    String? longitude,
    num? ghnProvinceId,
    List<StationModel>? pickingUpStations,
  }) =>
      ProvinceModel(
        provinceId: provinceId ?? _provinceId,
        provinceName: provinceName ?? _provinceName,
        provinceShortName: provinceShortName ?? _provinceShortName,
        provinceBriefName: provinceBriefName ?? _provinceBriefName,
        provinceVietnameseName:
            provinceVietnameseName ?? _provinceVietnameseName,
        imageUrl: imageUrl ?? _imageUrl,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        ghnProvinceId: ghnProvinceId ?? _ghnProvinceId,
        pickingUpStations: pickingUpStations ?? _pickingUpStations,
      );

  num? get provinceId => _provinceId;

  String? get provinceName => _provinceName;

  String? get provinceShortName => _provinceShortName;

  String? get provinceBriefName => _provinceBriefName;

  String? get provinceVietnameseName => _provinceVietnameseName;

  ImageModel? get imageUrl => _imageUrl;

  String? get latitude => _latitude;

  String? get longitude => _longitude;

  num? get ghnProvinceId => _ghnProvinceId;

  List<StationModel>? get pickingUpStations => _pickingUpStations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['province_id'] = _provinceId;
    map['province_name'] = _provinceName;
    map['province_short_name'] = _provinceShortName;
    map['province_brief_name'] = _provinceBriefName;
    map['province_vietnamese_name'] = _provinceVietnameseName;
    if (_imageUrl != null) {
      map['image_url'] = _imageUrl?.toJson();
    }
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['ghn_province_id'] = _ghnProvinceId;
    if (_pickingUpStations != null) {
      map['picking_up_stations'] =
          _pickingUpStations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// country_id : 241
/// country_name : "Vietnam"
/// country_vietnamese_name : false

class CountryModel {
  CountryModel({
    num? countryId,
    String? countryName,
    String? countryVietnameseName,
  }) {
    _countryId = countryId;
    _countryName = countryName;
    _countryVietnameseName = countryVietnameseName;
  }

  CountryModel.fromJson(dynamic json) {
    _countryId = safeParse(json['country_id']);
    _countryName = safeParse(json['country_name']);
    _countryVietnameseName = safeParse(json['country_vietnamese_name']);
  }

  num? _countryId;
  String? _countryName;
  String? _countryVietnameseName;

  CountryModel copyWith({
    num? countryId,
    String? countryName,
    String? countryVietnameseName,
  }) =>
      CountryModel(
        countryId: countryId ?? _countryId,
        countryName: countryName ?? _countryName,
        countryVietnameseName: countryVietnameseName ?? _countryVietnameseName,
      );

  num? get countryId => _countryId;

  String? get countryName => _countryName;

  String? get countryVietnameseName => _countryVietnameseName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country_id'] = _countryId;
    map['country_name'] = _countryName;
    map['country_vietnamese_name'] = _countryVietnameseName;
    return map;
  }
}
