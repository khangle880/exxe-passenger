class GeneralUserInfoModel {
  GeneralUserInfoModel({
    this.userInformation,
    this.verifiedNumberPhone,
    this.identityCard,
  });

  GeneralUserInfoModel.fromJson(dynamic json) {
    userInformation = json['user_information'];
    verifiedNumberPhone = json['verified_number_phone'];
    identityCard = json['identity_card'];
  }

  bool checkIfAnyIsFalse() {
    return [
      userInformation,
      verifiedNumberPhone,
      identityCard,
    ].contains(false);
  }

  bool? userInformation;
  bool? verifiedNumberPhone;
  bool? identityCard;

  GeneralUserInfoModel copyWith({
    bool? userInformation,
    bool? verifiedNumberPhone,
    bool? identityCard,
    bool? carDrivingLicense,
    bool? carRegistrationCertificate,
    bool? periodicalInspectionCertificate,
    bool? compulsoryCarInsurance,
    bool? carInformationId,
  }) =>
      GeneralUserInfoModel(
        userInformation: userInformation ?? this.userInformation,
        verifiedNumberPhone: verifiedNumberPhone ?? this.verifiedNumberPhone,
        identityCard: identityCard ?? this.identityCard,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_information'] = userInformation;
    map['verified_number_phone'] = verifiedNumberPhone;
    map['identity_card'] = identityCard;
    return map;
  }
}
