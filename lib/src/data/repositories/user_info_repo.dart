import 'package:dartz/dartz.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../app/pages/chat_fb/chat_fb_core/chat_fb_repo.dart';
import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../data.dart';

class UserInfoRepo extends IUserInfoRepo {
  late final INetworkUtility _networkUtility;

  UserInfoRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, PartnerModel>> getUserInfo() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getUserInfo, Method.POST, data: {
      "params": {
        "token": token,
      }
    });

    return ParserHelper.singleParseDefault(request, PartnerModel.fromJson);
  }

  @override
  Future<Either<Failure, GeneralUserInfoModel>> getGeneralUserInfo() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getGeneralUserInfo, Method.POST, data: {
      "params": {"token": token},
    });
    return ParserHelper.singleParseDefault(
        request, GeneralUserInfoModel.fromJson);
  }

  @override
  Future<Either<Failure, PartnerModel>> createUserInformation({
    required String name,
    required DateTime birthDate,
    required Gender gender,
    required String email,
    num? avatarAttachmentId,
    String? description,
    num? countryId,
    num? provinceId,
    num? districtId,
    num? wardId,
    String? street,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "car_account_type": CarAccountType.customer.serverString,
      "avatar_attachment_id": avatarAttachmentId,
      "name": name,
      "date_of_birth": birthDate.date.toFormat("yyyy-MM-dd"),
      "gender": gender.serverString,
      "email": email,
      "description": description,
      "country_id": countryId,
      "province_id": provinceId,
      "district_id": districtId,
      "ward_id": wardId,
      "street": street,
    }.getCleanNull;
    final request = _networkUtility.request(
        Apis.createUserInformation, Method.POST,
        data: {"params": params});
    return ParserHelper.singleParseDefault(
      request,
      PartnerModel.fromJson,
      rightPreCall: (value) async => GetIt.I<ChatFbRepo>().register(
        partnerId: value.partnerId!,
        phone: value.phone!,
        avatar: value.avatarUrl?.imageUrl == null
            ? ""
            : (Apis.baseUrl + value.avatarUrl!.imageUrl!),
        userName: value.partnerName ?? "",
      ),
    );
  }

  @override
  Future<Either<Failure, PartnerModel>> updateUserInformation({
    AttachmentModel? avatarAttachment,
    String? name,
    String? chatSecretKey,
    DateTime? birthDate,
    Gender? gender,
    String? email,
    String? description,
    num? countryId,
    num? provinceId,
    num? districtId,
    num? wardId,
    String? street,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "car_account_type": CarAccountType.customer.serverString,
      "avatar_attachment_id": avatarAttachment?.attachmentId,
      "chat_secret_key": chatSecretKey,
      "name": name,
      "email": email,
      "date_of_birth": birthDate?.date.toFormat("yyyy-MM-dd"),
      "gender": gender?.serverString,
      "description": description,
      "country_id": countryId,
      "province_id": provinceId,
      "district_id": districtId,
      "ward_id": wardId,
      "street": street,
    }.getCleanNull;
    final request = _networkUtility.request(
        Apis.updateUserInformation, Method.POST,
        data: {"params": params});
    return ParserHelper.singleParseDefault(
      request,
      PartnerModel.fromJson,
      rightPreCall: (value) async => GetIt.I<ChatFbRepo>().updateProfile(
        userName: name,
        avatar: avatarAttachment == null
            ? null
            : Apis.baseUrl + avatarAttachment.attachmentUrl.toString(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<AttachmentModel>>> createAvatarAttachment(
      List<AttachmentParam> attachments) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "attachments": attachments
          .map((e) => {"file": e.base64, "type": e.type.serverString})
          .toList()
    };
    final request = _networkUtility
        .request(Apis.createAvatarAttachment, Method.POST, data: {
      "params": params,
    });
    return ParserHelper.listParseDefault(request, AttachmentModel.fromJson);
  }

  @override
  Future<Either<Failure, List<AttachmentModel>>> createAttachmentData(
      List<AttachmentParam> attachments) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "attachments": attachments
          .map((e) => {"file": e.base64, "type": e.type.serverString})
          .toList()
    };
    final request =
        _networkUtility.request(Apis.createAttachmentData, Method.POST, data: {
      "params": params,
    });
    return ParserHelper.listParseDefault(request, AttachmentModel.fromJson);
  }

  @override
  Future<Either<Failure, VerifyPhoneModel>> createVerifiedNumberPhone(
      num imageId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "verified_number_phone_image_url": imageId,
    };
    final request = _networkUtility
        .request(Apis.createVerifiedNumberPhone, Method.POST, data: {
      "params": params,
    });
    return ParserHelper.singleParseDefault(request, VerifyPhoneModel.fromJson);
  }

  @override
  Future<Either<Failure, VerifyPhoneModel>> updateVerifiedNumberPhone(
      num phoneId, num imageId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "verified_number_phone_id": phoneId,
      "verified_number_phone_image_url": imageId,
    };
    final request = _networkUtility
        .request(Apis.updateVerifiedNumberPhone, Method.POST, data: {
      "params": params,
    });
    return ParserHelper.singleParseDefault(request, VerifyPhoneModel.fromJson);
  }

  @override
  Future<Either<Failure, VerifyPhoneModel>> getVerifiedNumberPhone() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getVerifiedNumberPhone, Method.POST, data: {
      "params": {"token": token},
    });
    return ParserHelper.singleParseDefault(request, VerifyPhoneModel.fromJson);
  }

  @override
  Future<Either<Failure, IdentityCardModel>> createIdentityCard({
    num? frontImageId,
    num? backImageId,
    required String name,
    required String identityNumber,
    required DateTime issuedDate,
    DateTime? expiredDate,
    required String placeOfIssue,
    required String address,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "front_identity_card_image_url": frontImageId,
      "back_identity_card_image_url": backImageId,
      "partner_name": name,
      "identity_number": identityNumber,
      "date_of_issue": issuedDate.serverFormatOnlyDate,
      "date_of_expiry": expiredDate?.serverFormatOnlyDate,
      "place_of_issue": placeOfIssue,
      "address": address,
    }.getCleanNull;
    final request =
        _networkUtility.request(Apis.createIdentityCard, Method.POST, data: {
      "params": params,
    });

    return ParserHelper.singleParseDefault(request, IdentityCardModel.fromJson);
  }

  @override
  Future<Either<Failure, IdentityCardModel>> updateIdentityCard(
      {required num id,
      String? name,
      num? frontImageId,
      num? backImageId,
      String? identityNumber,
      DateTime? issuedDate,
      DateTime? expiredDate,
      String? placeOfIssue,
      String? address}) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "identity_card_id": id,
      "front_identity_card_image_url": frontImageId,
      "back_identity_card_image_url": backImageId,
      "partner_name": name,
      "identity_number": identityNumber,
      "date_of_issue": issuedDate?.serverFormatOnlyDate,
      "date_of_expiry": expiredDate?.serverFormatOnlyDate,
      "place_of_issue": placeOfIssue,
      "address": address,
    }.getCleanNull;
    final request =
        _networkUtility.request(Apis.updateIdentityCard, Method.POST, data: {
      "params": params,
    });

    return ParserHelper.singleParseDefault(request, IdentityCardModel.fromJson);
  }

  @override
  Future<Either<Failure, IdentityCardModel>> getIdentityCard() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getIdentityCard, Method.POST, data: {
      "params": {"token": token},
    });
    return ParserHelper.singleParseDefault(request, IdentityCardModel.fromJson);
  }

  @override
  Future<Either<Failure, RelationshipInformationModel>>
      createRelationshipInformation({
    required Relationship relationship,
    required String name,
    required String phone,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.createRelationshipInformation, Method.POST, data: {
      "params": {
        "token": token,
        "relationship": relationship.serverString,
        "name": name,
        "phone": phone,
      },
    });

    return ParserHelper.singleParseDefault(
        request, RelationshipInformationModel.fromJson);
  }

  @override
  Future<Either<Failure, RelationshipInformationModel>>
      updateRelationshipInformation({
    required id,
    Relationship? relationship,
    String? name,
    String? phone,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.updateRelationshipInformation, Method.POST, data: {
      "params": {
        "token": token,
        "relationship_id": id,
        "relationship": relationship?.serverString,
        "name": name,
        "phone": phone,
      }.getCleanNull,
    });

    return ParserHelper.singleParseDefault(
        request, RelationshipInformationModel.fromJson);
  }

  @override
  Future<Either<Failure, List<RelationshipInformationModel>>>
      getListRelationshipInformation() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getListRelationshipInformation, Method.POST, data: {
      "params": {"token": token},
    });

    return ParserHelper.paginateParseDefault(
        request, RelationshipInformationModel.fromJson);
  }

  @override
  Future<Either<Failure, dynamic>> deleteRelationshipInformation(
      num relationshipId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.deleteRelationshipInformation, Method.POST, data: {
      "params": {"token": token, "relationship_id": relationshipId},
    });

    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }

  @override
  Future<Either<Failure, RelationshipInformationModel>>
      getRelationshipInformation(num relationshipId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getDetailRelationshipInformation, Method.POST, data: {
      "params": {"token": token, "relationship_id": relationshipId},
    });

    return ParserHelper.singleParseDefault(
        request, RelationshipInformationModel.fromJson);
  }
}
