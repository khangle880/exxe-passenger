part of 'verify_relationship_cubit.dart';

class VerifyRelationshipState extends Equatable {
  final String? fullName;
  final String? phone;
  final Relationship? relationship;
  final RelationshipInformationModel? relationshipModel;
  final CallDataApiType type;

  const VerifyRelationshipState({
    this.fullName,
    this.phone,
    this.relationship,
    this.relationshipModel,
    this.type = CallDataApiType.create,
  });

  VerifyRelationshipState copyWith({
    String? fullName,
    String? phone,
    Relationship? relationship,
    RelationshipInformationModel? relationshipModel,
    CallDataApiType? type,
  }) {
    return VerifyRelationshipState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      relationship: relationship ?? this.relationship,
      relationshipModel: relationshipModel ?? this.relationshipModel,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        relationship,
        relationshipModel,
        type,
      ];
}
