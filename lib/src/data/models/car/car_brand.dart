import '../../../utils/utils.dart';
import '../models.dart';

/// brand_id : 12
/// brand_name : "AUDI"
/// brand_icon : {"icon_id":12,"icon_url":"/manage_compounding_car/static/src/img/stored-attachment-module-pdFbMi2NgGMGIPEJycA1HeVpaVCFVWGG-1655798110-QGZxC3ViphDdO0BJRsNZ4QygMwdrqqLi-1655798110.png"}

class CarBrandModel {
  CarBrandModel({
    num? brandId,
    String? brandName,
    IconModel? brandIcon,
  }) {
    _brandId = brandId;
    _brandName = brandName;
    _brandIcon = brandIcon;
  }

  CarBrandModel.fromJson(dynamic json) {
    _brandId = safeParse(json['brand_id']);
    _brandName = safeParse(json['brand_name']);
    _brandIcon = json['brand_icon'] != null
        ? IconModel.fromJson(json['brand_icon'])
        : null;
  }

  num? _brandId;
  String? _brandName;
  IconModel? _brandIcon;

  CarBrandModel copyWith({
    num? brandId,
    String? brandName,
    IconModel? brandIcon,
  }) =>
      CarBrandModel(
        brandId: brandId ?? _brandId,
        brandName: brandName ?? _brandName,
        brandIcon: brandIcon ?? _brandIcon,
      );

  num? get brandId => _brandId;

  String? get brandName => _brandName;

  IconModel? get brandIcon => _brandIcon;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['brand_id'] = _brandId;
    map['brand_name'] = _brandName;
    if (_brandIcon != null) {
      map['brand_icon'] = _brandIcon?.toJson();
    }
    return map;
  }
}

/// icon_id : 12
/// icon_url : "/manage_compounding_car/static/src/img/stored-attachment-module-pdFbMi2NgGMGIPEJycA1HeVpaVCFVWGG-1655798110-QGZxC3ViphDdO0BJRsNZ4QygMwdrqqLi-1655798110.png"


