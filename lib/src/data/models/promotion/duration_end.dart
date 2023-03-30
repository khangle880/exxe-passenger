import '../../../utils/export/ui_export.dart';

class DurationEnd {
  DurationEnd({
    this.timeValue,
    this.timeType,
  });

  DurationEnd.fromJson(dynamic json) {
    timeValue = safeParse(json['time_value']);
    timeType = safeParse(json['time_type']);
  }

  int? timeValue;
  String? timeType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time_value'] = timeValue;
    map['time_type'] = timeType;
    return map;
  }
}
