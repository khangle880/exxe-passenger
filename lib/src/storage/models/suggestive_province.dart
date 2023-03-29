import 'dart:developer';

import 'package:hive/hive.dart';

import '../../utils/constants/constants.dart';

part 'suggestive_province.g.dart';

@HiveType(typeId: 4)
class SuggestiveProvince extends HiveObject {
  @HiveField(0)
  int provinceId;
  @HiveField(1)
  String provinceName;
  @HiveField(2, defaultValue: 0)
  double? distance;

  SuggestiveProvince({
    required this.provinceId,
    required this.provinceName,
    this.distance,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestiveProvince &&
          runtimeType == other.runtimeType &&
          provinceId == other.provinceId &&
          provinceName == other.provinceName;

  @override
  int get hashCode =>
      provinceId.hashCode ^ provinceName.hashCode ^ distance.hashCode;
}

class SuggestiveProvinceHiveBox {
  static SuggestiveProvinceHiveBox instance = SuggestiveProvinceHiveBox();
  static const String boxName = HiveBoxName.provinceBox;

  late Future<Box<Map<String, dynamic>>> _box;

  SuggestiveProvinceHiveBox() {
    _box = Hive.openBox<Map<String, dynamic>>(boxName);
  }

  Future<void> saveSuggestProvince(
      SuggestiveProvince province, num key, SearchType type) async {
    try {
      var box = await _box;
      Map<String, dynamic>? suggestProvince =
          box.get(key.toString(), defaultValue: {});
      if (suggestProvince != null) {
        List<SuggestiveProvince> listData =
            suggestProvince[type.toString()] ?? [];
        if (listData.contains(province)) {
          log('da co tỉnh này');
          return;
        }
        listData.add(province);
        suggestProvince[type.toString()] = listData;
        box.put(key.toString(), suggestProvince);
      } else {
        log('provice lenght ${suggestProvince?.length}');
      }
    } catch (e) {
      log('save fail $e');
      rethrow;
    }
  }

  Future<List<SuggestiveProvince>> readSuggestProvince(
      num key, SearchType type) async {
    var box = await _box;
    Map<String, dynamic>? suggestProvince =
        box.get(key.toString(), defaultValue: {});
    log('data ${suggestProvince?.keys.length}');
    if (suggestProvince != null && suggestProvince.isNotEmpty) {
      List<SuggestiveProvince> listData =
          suggestProvince[type.toString()] ?? [];
      log('list goi y ${listData.length}');
      return listData;
    } else {
      return [];
    }
  }
}
