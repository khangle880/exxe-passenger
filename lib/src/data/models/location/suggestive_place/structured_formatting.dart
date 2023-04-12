class StructuredFormatting {
  StructuredFormatting({
    this.mainText,
    this.secondaryText,
  });

  StructuredFormatting.fromJson(dynamic json) {
    mainText = json['main_text'];
    secondaryText = json['secondary_text'];
  }

  String? mainText;
  String? secondaryText;

  StructuredFormatting copyWith({
    String? mainText,
    String? secondaryText,
  }) =>
      StructuredFormatting(
        mainText: mainText ?? this.mainText,
        secondaryText: secondaryText ?? this.secondaryText,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['main_text'] = mainText;
    map['secondary_text'] = secondaryText;
    return map;
  }
}
