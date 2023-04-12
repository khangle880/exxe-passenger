import 'goong_sub_model.dart';

class GoongPlaceModel {
  GoongPlaceModel({
    this.placeId,
    this.formattedAddress,
    this.geometry,
    this.plusCode,
    this.compound,
    this.name,
    this.url,
    this.types,
  });

  GoongPlaceModel.fromJson(dynamic json) {
    placeId = json['place_id'];
    formattedAddress = json['formatted_address'];
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    plusCode =
        json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    compound =
        json['compound'] != null ? Compound.fromJson(json['compound']) : null;
    name = json['name'];
    url = json['url'];
    types = json['types'] != null ? json['types'].cast<String>() : [];
  }

  String? placeId;
  String? formattedAddress;
  Geometry? geometry;
  PlusCode? plusCode;
  Compound? compound;
  String? name;
  String? url;
  List<String>? types;

  GoongPlaceModel copyWith({
    String? placeId,
    String? formattedAddress,
    Geometry? geometry,
    PlusCode? plusCode,
    Compound? compound,
    String? name,
    String? url,
    List<String>? types,
  }) =>
      GoongPlaceModel(
        placeId: placeId ?? this.placeId,
        formattedAddress: formattedAddress ?? this.formattedAddress,
        geometry: geometry ?? this.geometry,
        plusCode: plusCode ?? this.plusCode,
        compound: compound ?? this.compound,
        name: name ?? this.name,
        url: url ?? this.url,
        types: types ?? this.types,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['place_id'] = placeId;
    map['formatted_address'] = formattedAddress;
    if (geometry != null) {
      map['geometry'] = geometry?.toJson();
    }
    if (plusCode != null) {
      map['plus_code'] = plusCode?.toJson();
    }
    if (compound != null) {
      map['compound'] = compound?.toJson();
    }
    map['name'] = name;
    map['url'] = url;
    map['types'] = types;
    return map;
  }
}
