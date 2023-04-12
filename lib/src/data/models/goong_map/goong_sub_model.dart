class Compound {
  Compound({
    this.district,
    this.commune,
    this.province,
  });

  Compound.fromJson(dynamic json) {
    district = json['district'];
    commune = json['commune'];
    province = json['province'];
  }

  String? district;
  String? commune;
  String? province;

  Compound copyWith({
    String? district,
    String? commune,
    String? province,
  }) =>
      Compound(
        district: district ?? this.district,
        commune: commune ?? this.commune,
        province: province ?? this.province,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['district'] = district;
    map['commune'] = commune;
    map['province'] = province;
    return map;
  }
}

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  PlusCode.fromJson(dynamic json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  String? compoundCode;
  String? globalCode;

  PlusCode copyWith({
    String? compoundCode,
    String? globalCode,
  }) =>
      PlusCode(
        compoundCode: compoundCode ?? this.compoundCode,
        globalCode: globalCode ?? this.globalCode,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['compound_code'] = compoundCode;
    map['global_code'] = globalCode;
    return map;
  }
}

class Geometry {
  Geometry({
    this.location,
  });

  Geometry.fromJson(dynamic json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Location? location;

  Geometry copyWith({
    Location? location,
  }) =>
      Geometry(
        location: location ?? this.location,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (location != null) {
      map['location'] = location?.toJson();
    }
    return map;
  }
}

class Location {
  Location({
    this.lat,
    this.lng,
  });

  Location.fromJson(dynamic json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  num? lat;
  num? lng;

  Location copyWith({
    num? lat,
    num? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }
}

class Terms {
  Terms({
    this.offset,
    this.value,
  });

  Terms.fromJson(dynamic json) {
    offset = json['offset'];
    value = json['value'];
  }

  num? offset;
  String? value;

  Terms copyWith({
    num? offset,
    String? value,
  }) =>
      Terms(
        offset: offset ?? this.offset,
        value: value ?? this.value,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['offset'] = offset;
    map['value'] = value;
    return map;
  }
}

class StructuredFormatting {
  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
    this.secondaryTextMatchedSubstrings,
  });

  StructuredFormatting.fromJson(dynamic json) {
    mainText = json['main_text'];
    if (json['main_text_matched_substrings'] != null) {
      mainTextMatchedSubstrings = [];
      json['main_text_matched_substrings'].forEach((v) {
        mainTextMatchedSubstrings?.add(MainTextMatchedSubstrings.fromJson(v));
      });
    }
    secondaryText = json['secondary_text'];
    if (json['secondary_text_matched_substrings'] != null) {
      secondaryTextMatchedSubstrings = [];
      json['secondary_text_matched_substrings'].forEach((v) {
        secondaryTextMatchedSubstrings
            ?.add(SecondaryTextMatchedSubstrings.fromJson(v));
      });
    }
  }

  String? mainText;
  List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings;
  String? secondaryText;
  List<SecondaryTextMatchedSubstrings>? secondaryTextMatchedSubstrings;

  StructuredFormatting copyWith({
    String? mainText,
    List<MainTextMatchedSubstrings>? mainTextMatchedSubstrings,
    String? secondaryText,
    List<SecondaryTextMatchedSubstrings>? secondaryTextMatchedSubstrings,
  }) =>
      StructuredFormatting(
        mainText: mainText ?? this.mainText,
        mainTextMatchedSubstrings:
            mainTextMatchedSubstrings ?? this.mainTextMatchedSubstrings,
        secondaryText: secondaryText ?? this.secondaryText,
        secondaryTextMatchedSubstrings: secondaryTextMatchedSubstrings ??
            this.secondaryTextMatchedSubstrings,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['main_text'] = mainText;
    if (mainTextMatchedSubstrings != null) {
      map['main_text_matched_substrings'] =
          mainTextMatchedSubstrings?.map((v) => v.toJson()).toList();
    }
    map['secondary_text'] = secondaryText;
    if (secondaryTextMatchedSubstrings != null) {
      map['secondary_text_matched_substrings'] =
          secondaryTextMatchedSubstrings?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SecondaryTextMatchedSubstrings {
  SecondaryTextMatchedSubstrings({
    this.length,
    this.offset,
  });

  SecondaryTextMatchedSubstrings.fromJson(dynamic json) {
    length = json['length'];
    offset = json['offset'];
  }

  num? length;
  num? offset;

  SecondaryTextMatchedSubstrings copyWith({
    num? length,
    num? offset,
  }) =>
      SecondaryTextMatchedSubstrings(
        length: length ?? this.length,
        offset: offset ?? this.offset,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['length'] = length;
    map['offset'] = offset;
    return map;
  }
}

class MainTextMatchedSubstrings {
  MainTextMatchedSubstrings({
    this.length,
    this.offset,
  });

  MainTextMatchedSubstrings.fromJson(dynamic json) {
    length = json['length'];
    offset = json['offset'];
  }

  num? length;
  num? offset;

  MainTextMatchedSubstrings copyWith({
    num? length,
    num? offset,
  }) =>
      MainTextMatchedSubstrings(
        length: length ?? this.length,
        offset: offset ?? this.offset,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['length'] = length;
    map['offset'] = offset;
    return map;
  }
}

class MatchedSubstrings {
  MatchedSubstrings({
    this.length,
    this.offset,
  });

  MatchedSubstrings.fromJson(dynamic json) {
    length = json['length'];
    offset = json['offset'];
  }

  num? length;
  num? offset;

  MatchedSubstrings copyWith({
    num? length,
    num? offset,
  }) =>
      MatchedSubstrings(
        length: length ?? this.length,
        offset: offset ?? this.offset,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['length'] = length;
    map['offset'] = offset;
    return map;
  }
}
