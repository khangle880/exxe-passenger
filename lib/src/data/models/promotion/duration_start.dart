import '../../../utils/export/ui_export.dart';

class DurationStart {
  DurationStart({
      this.timeValue, 
      this.timeType,});

  DurationStart.fromJson(dynamic json) {
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