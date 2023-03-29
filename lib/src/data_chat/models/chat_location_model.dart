class ChatLocationModel {
  ChatLocationModel({
    this.lng,
    this.lat,
  });

  ChatLocationModel.fromJson(dynamic json) {
    lng = json['lng'];
    lat = json['lat'];
  }

  String? lng;
  String? lat;

  ChatLocationModel copyWith({
    String? lng,
    String? lat,
  }) =>
      ChatLocationModel(
        lng: lng ?? this.lng,
        lat: lat ?? this.lat,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lng'] = lng;
    map['lat'] = lat;
    return map;
  }
}
