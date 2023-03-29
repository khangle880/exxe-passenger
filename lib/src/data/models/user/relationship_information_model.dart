import '../../../utils/constants/constants.dart';
import '../../../utils/parser_utils.dart';

class RelationshipInformationModel {
  RelationshipInformationModel({
    this.relationshipId,
    this.relationship,
    this.name,
    this.phone,
  });

  RelationshipInformationModel.fromJson(dynamic json) {
    relationshipId = safeParse(json['relationship_id']);
    relationship =
        safeParse(json['relationship'], payload: Relationship.values);
    name = safeParse(json['name']);
    phone = safeParse(json['phone']);
  }

  num? relationshipId;
  Relationship? relationship;
  String? name;
  String? phone;

  RelationshipInformationModel copyWith({
    num? relationshipId,
    Relationship? relationship,
    String? name,
    String? phone,
  }) =>
      RelationshipInformationModel(
        relationshipId: relationshipId ?? this.relationshipId,
        relationship: relationship ?? this.relationship,
        name: name ?? this.name,
        phone: phone ?? this.phone,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['relationship_id'] = relationshipId;
    map['relationship'] = relationship;
    map['name'] = name;
    map['phone'] = phone;
    return map;
  }
}
