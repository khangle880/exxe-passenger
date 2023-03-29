class Duration {
  Duration({
    this.timeValue,
    this.timeType,
  });

  Duration.fromJson(dynamic json) {
    timeValue = json['time_value'];
    timeType = json['time_type'];
  }

  num? timeValue;
  String? timeType;

  Duration copyWith({
    num? timeValue,
    String? timeType,
  }) =>
      Duration(
        timeValue: timeValue ?? this.timeValue,
        timeType: timeType ?? this.timeType,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['time_value'] = timeValue;
    map['time_type'] = timeType;
    return map;
  }
}
