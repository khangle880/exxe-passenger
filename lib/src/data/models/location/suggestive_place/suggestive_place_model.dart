import 'structured_formatting.dart';

//search text dong xoai
// "description": "Đồng Xoài, Bình Phước, Việt Nam",
//  "place_id": "ChIJicD_BSWgdDERLaHPkrME4e0",
//  "structured_formatting": {"main_text":"Đồng Xoài","main_text_matched_substrings":[{"length":4,"offset":0}],"secondary_text":"Bình Phước, Việt Nam"}

class SuggestivePlaceModel {
  SuggestivePlaceModel({
      this.description, 
      this.placeId, 
      this.structuredFormatting,});

  SuggestivePlaceModel.fromJson(dynamic json) {
    description = json['description'];
    placeId = json['place_id'];
    structuredFormatting = json['structured_formatting'] != null ? StructuredFormatting.fromJson(json['structured_formatting']) : null;
  }
  String? description;
  String? placeId;
  StructuredFormatting? structuredFormatting;

SuggestivePlaceModel copyWith({  String? description,
  String? placeId,
  StructuredFormatting? structuredFormatting,
}) => SuggestivePlaceModel(  description: description ?? this.description,
  placeId: placeId ?? this.placeId,
  structuredFormatting: structuredFormatting ?? this.structuredFormatting,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = description;
    map['place_id'] = placeId;
    if (structuredFormatting != null) {
      map['structured_formatting'] = structuredFormatting?.toJson();
    }
    return map;
  }

}