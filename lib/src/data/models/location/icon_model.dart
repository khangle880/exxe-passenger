import 'package:exxe/src/utils/export/ui_export.dart';

/// icon_id : false
/// icon_url : false

class IconModel {
  IconModel({
    num? iconId,
    String? iconUrl,
  }) {
    _iconId = iconId;
    _iconUrl = iconUrl;
  }

  IconModel.fromJson(dynamic json) {
    _iconId = safeParse(json['icon_id']);
    _iconUrl = safeParse(json['icon_url']);
  }

  num? _iconId;
  String? _iconUrl;

  IconModel copyWith({
    num? iconId,
    String? iconUrl,
  }) =>
      IconModel(
        iconId: iconId ?? _iconId,
        iconUrl: iconUrl ?? _iconUrl,
      );

  num? get iconId => _iconId;

  String? get iconUrl => _iconUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['icon_id'] = _iconId;
    map['icon_url'] = _iconUrl;
    return map;
  }
}
