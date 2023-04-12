import 'goong_sub_model.dart';

class SuggestivePlaceModel {
  SuggestivePlaceModel({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.hasChildren,
    this.plusCode,
    this.compound,
    this.terms,
    this.types,
    this.distanceMeters,
  });

  SuggestivePlaceModel.fromJson(dynamic json) {
    description = json['description'];
    if (json['matched_substrings'] != null) {
      matchedSubstrings = [];
      json['matched_substrings'].forEach((v) {
        matchedSubstrings?.add(MatchedSubstrings.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    structuredFormatting = json['structured_formatting'] != null
        ? StructuredFormatting.fromJson(json['structured_formatting'])
        : null;
    hasChildren = json['has_children'];
    plusCode =
        json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    compound =
        json['compound'] != null ? Compound.fromJson(json['compound']) : null;
    if (json['terms'] != null) {
      terms = [];
      json['terms'].forEach((v) {
        terms?.add(Terms.fromJson(v));
      });
    }
    types = json['types'] != null ? json['types'].cast<String>() : [];
    distanceMeters = json['distance_meters'];
  }

  String? description;
  List<MatchedSubstrings>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  bool? hasChildren;
  PlusCode? plusCode;
  Compound? compound;
  List<Terms>? terms;
  List<String>? types;
  dynamic distanceMeters;

  SuggestivePlaceModel copyWith({
    String? description,
    List<MatchedSubstrings>? matchedSubstrings,
    String? placeId,
    String? reference,
    StructuredFormatting? structuredFormatting,
    bool? hasChildren,
    PlusCode? plusCode,
    Compound? compound,
    List<Terms>? terms,
    List<String>? types,
    dynamic distanceMeters,
  }) =>
      SuggestivePlaceModel(
        description: description ?? this.description,
        matchedSubstrings: matchedSubstrings ?? this.matchedSubstrings,
        placeId: placeId ?? this.placeId,
        reference: reference ?? this.reference,
        structuredFormatting: structuredFormatting ?? this.structuredFormatting,
        hasChildren: hasChildren ?? this.hasChildren,
        plusCode: plusCode ?? this.plusCode,
        compound: compound ?? this.compound,
        terms: terms ?? this.terms,
        types: types ?? this.types,
        distanceMeters: distanceMeters ?? this.distanceMeters,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    if (matchedSubstrings != null) {
      map['matched_substrings'] =
          matchedSubstrings?.map((v) => v.toJson()).toList();
    }
    map['place_id'] = placeId;
    map['reference'] = reference;
    if (structuredFormatting != null) {
      map['structured_formatting'] = structuredFormatting?.toJson();
    }
    map['has_children'] = hasChildren;
    if (plusCode != null) {
      map['plus_code'] = plusCode?.toJson();
    }
    if (compound != null) {
      map['compound'] = compound?.toJson();
    }
    if (terms != null) {
      map['terms'] = terms?.map((v) => v.toJson()).toList();
    }
    map['types'] = types;
    map['distance_meters'] = distanceMeters;
    return map;
  }
}
