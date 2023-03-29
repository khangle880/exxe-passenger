import '../../../utils/constants/enum/enum.dart';
import '../../../utils/parser_utils.dart';
import '../models.dart';

class IdentityCardModel {
  IdentityCardModel({
    this.identityCardId,
    this.partner,
    this.frontIdentityCardImageUrl,
    this.backIdentityCardImageUrl,
    this.identityNumber,
    this.dateOfIssue,
    this.dateOfExpiry,
    this.placeOfIssue,
    this.address,
    this.state,
  });

  IdentityCardModel.fromJson(dynamic json) {
    identityCardId = safeParse(json['identity_card_id']);
    partner =
    json['partner'] != null ? PartnerModel.fromJson(json['partner']) : null;
    frontIdentityCardImageUrl = json['front_identity_card_image_url'] != null
        ? ImageModel.fromJson(json['front_identity_card_image_url'])
        : null;
    backIdentityCardImageUrl = json['back_identity_card_image_url'] != null
        ? ImageModel.fromJson(json['back_identity_card_image_url'])
        : null;
    identityNumber = safeParse(json['identity_number']);
    dateOfIssue = safeParse(json['date_of_issue']);
    dateOfExpiry = safeParse(json['date_of_expiry']);
    placeOfIssue = safeParse(json['place_of_issue']);
    address = safeParse(json['address']);
    state = safeParse(json['state'], payload: VerifyState.values);
  }

  num? identityCardId;
  PartnerModel? partner;
  ImageModel? frontIdentityCardImageUrl;
  ImageModel? backIdentityCardImageUrl;
  String? identityNumber;
  DateTime? dateOfIssue;
  DateTime? dateOfExpiry;
  String? placeOfIssue;
  String? address;
  VerifyState? state;

  IdentityCardModel copyWith({
    num? identityCardId,
    PartnerModel? partner,
    ImageModel? frontIdentityCardImageUrl,
    ImageModel? backIdentityCardImageUrl,
    String? identityNumber,
    DateTime? dateOfIssue,
    DateTime? dateOfExpiry,
    String? placeOfIssue,
    String? address,
    VerifyState? state,
  }) =>
      IdentityCardModel(
        identityCardId: identityCardId ?? this.identityCardId,
        partner: partner ?? this.partner,
        frontIdentityCardImageUrl:
        frontIdentityCardImageUrl ?? this.frontIdentityCardImageUrl,
        backIdentityCardImageUrl:
        backIdentityCardImageUrl ?? this.backIdentityCardImageUrl,
        identityNumber: identityNumber ?? this.identityNumber,
        dateOfIssue: dateOfIssue ?? this.dateOfIssue,
        dateOfExpiry: dateOfExpiry ?? this.dateOfExpiry,
        placeOfIssue: placeOfIssue ?? this.placeOfIssue,
        address: address ?? this.address,
        state: state ?? this.state,
      );
}
