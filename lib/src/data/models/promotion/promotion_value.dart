
import '../../../utils/export/ui_export.dart';

class PromotionValue {
  double? value;
  String? unit;

  PromotionValue({
    this.value,
    this.unit,
  });

  PromotionValue.fromJson(dynamic json) {
    value = safeParse(json['value']);
    unit = safeParse(json['unit']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = value;
    map['unit'] = unit;
    return map;
  }
}
