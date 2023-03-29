import '../../../utils/utils.dart';
import '../models.dart';

/// partner_id : 50
/// partner_name : "USER-0987147539"
/// avatar_url : {"image_id":231,"image_url":"/manage_detail_data/static/src/img/stored-attachment-module-ceSiVSqnc1AnW1eqvzsSKtwoMK8gttH9-1660278564-ouFKmADFWhLUpS7z7QSWdRPXWRRClYIn-1660278564.png"}
/// car_account_type : "customer"
/// gender : "male"
/// date_of_birth : "2000-08-11"
/// description : false
/// country_id : {"country_id":241,"country_name":"Vietnam"}
/// province_id : {"province_id":false,"province_name":false}
/// district_id : {"district_id":false,"district_name":false}
/// ward_id : {"ward_id":false,"ward_name":false}
/// street : false
/// phone : "0987147539"
/// email : "0987147539"
/// identity_card_id : {"identity_card_id":false,"front_identity_card_image_url":{"id":false,"url":false},"back_identity_card_image_url":{"id":false,"url":false},"identity_number":false,"date_of_issue":false,"date_of_expiry":false,"place_of_issue":false,"address":false,"state":false}
class PartnerModel {
  PartnerModel({
    this.partnerId,
    this.partnerName,
    this.chatSecretKey,
    this.avatarUrl,
    this.carAccountType,
    this.gender,
    this.dateOfBirth,
    this.description,
    this.countryId,
    this.provinceId,
    this.districtId,
    this.wardId,
    this.street,
    this.phone,
    this.email,
    this.identityCardId,
  });

  PartnerModel.fromJson(dynamic json) {
    partnerId = safeParse(json['partner_id']);
    partnerName = safeParse(json['partner_name']);
    chatSecretKey = safeParse(json['chat_secret_key']);
    avatarUrl = json['avatar_url'] != null
        ? AvatarUrlModel.fromJson(json['avatar_url'])
        : null;
    carAccountType =
        safeParse(json['car_account_type'], payload: CarAccountType.values);
    gender = safeParse(json['gender'], payload: Gender.values);
    dateOfBirth = safeParse(json['date_of_birth']);
    description = safeParse(json['description']);
    countryId = json['country_id'] != null
        ? CountryModel.fromJson(json['country_id'])
        : null;
    provinceId = json['province_id'] != null
        ? ProvinceModel.fromJson(json['province_id'])
        : null;
    districtId = json['district_id'] != null
        ? DistrictModel.fromJson(json['district_id'])
        : null;
    wardId =
        json['ward_id'] != null ? WardModel.fromJson(json['ward_id']) : null;
    street = safeParse(json['street']);
    phone = safeParse(json['phone']);
    email = safeParse(json['email']);
    identityCardId = json['identity_card_id'] != null
        ? IdentityCardModel.fromJson(json['identity_card_id'])
        : null;
    token = safeParse(json['token']);
    refreshToken = safeParse(json['refresh_token']);
  }

  num? partnerId;
  String? partnerName;
  String? chatSecretKey;
  AvatarUrlModel? avatarUrl;
  CarAccountType? carAccountType;
  Gender? gender;
  DateTime? dateOfBirth;
  String? description;
  CountryModel? countryId;
  ProvinceModel? provinceId;
  DistrictModel? districtId;
  WardModel? wardId;
  String? street;
  String? phone;
  String? email;
  IdentityCardModel? identityCardId;
  String? token;
  String? refreshToken;

  Map<String, dynamic> toJson() {
    return {
      'partnerId': partnerId,
      'partnerName': partnerName,
      'chat_secret_key': chatSecretKey,
      'avatarUrl': avatarUrl,
      'carAccountType': carAccountType,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'description': description,
      'countryId': countryId,
      'provinceId': provinceId,
      'districtId': districtId,
      'wardId': wardId,
      'street': street,
      'phone': phone,
      'email': email,
      'identityCardId': identityCardId,
    };
  }

  PartnerModel copyWith({
    num? partnerId,
    String? partnerName,
    String? chatSecretKey,
    AvatarUrlModel? avatarUrl,
    CarAccountType? carAccountType,
    Gender? gender,
    DateTime? dateOfBirth,
    String? description,
    CountryModel? countryId,
    ProvinceModel? provinceId,
    DistrictModel? districtId,
    WardModel? wardId,
    String? street,
    String? phone,
    String? email,
    IdentityCardModel? identityCardId,
    String? token,
    String? refreshToken,
  }) {
    return PartnerModel(
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      chatSecretKey: chatSecretKey ?? this.chatSecretKey,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      carAccountType: carAccountType ?? this.carAccountType,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      description: description ?? this.description,
      countryId: countryId ?? this.countryId,
      provinceId: provinceId ?? this.provinceId,
      districtId: districtId ?? this.districtId,
      wardId: wardId ?? this.wardId,
      street: street ?? this.street,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      identityCardId: identityCardId ?? this.identityCardId,
    );
  }
}
