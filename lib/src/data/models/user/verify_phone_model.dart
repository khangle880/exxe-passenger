import '../asset/image_model.dart';

class VerifyPhoneModel {
  VerifyPhoneModel({
    this.verifiedNumberPhoneId,
    this.phone,
    this.verifiedNumberPhoneImage,
    this.state,
  });

  VerifyPhoneModel.fromJson(dynamic json) {
    verifiedNumberPhoneId = json['verified_number_phone_id'];
    phone = json['phone'];
    verifiedNumberPhoneImage = json['verified_number_phone_image'] != null
        ? ImageModel.fromJson(json['verified_number_phone_image'])
        : null;
    state = json['state'];
  }

  num? verifiedNumberPhoneId;
  String? phone;
  ImageModel? verifiedNumberPhoneImage;
  String? state;

  VerifyPhoneModel copyWith({
    num? verifiedNumberPhoneId,
    String? phone,
    ImageModel? verifiedNumberPhoneImage,
    String? state,
  }) =>
      VerifyPhoneModel(
        verifiedNumberPhoneId:
            verifiedNumberPhoneId ?? this.verifiedNumberPhoneId,
        phone: phone ?? this.phone,
        verifiedNumberPhoneImage:
            verifiedNumberPhoneImage ?? this.verifiedNumberPhoneImage,
        state: state ?? this.state,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['verified_number_phone_id'] = verifiedNumberPhoneId;
    map['phone'] = phone;
    if (verifiedNumberPhoneImage != null) {
      map['verified_number_phone_image'] = verifiedNumberPhoneImage?.toJson();
    }
    map['state'] = state;
    return map;
  }
}
