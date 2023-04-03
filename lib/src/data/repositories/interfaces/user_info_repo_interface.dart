import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../../utils/constants/enum/enum.dart';
import '../../models/models.dart';

abstract class IUserInfoRepo {
  Future<Either<Failure, PartnerModel>> getUserInfo();

  Future<Either<Failure, GeneralUserInfoModel>> getGeneralUserInfo();

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
  });

  Future<Either<Failure, PartnerModel>> updateUserInformation({
    AttachmentModel? avatarAttachment,
    String? name,
    String? chatSecretKey,
    DateTime? birthDate,
    String? email,
    Gender? gender,
    String? description,
    num? countryId,
    num? provinceId,
    num? districtId,
    num? wardId,
    String? street,
  });

  Future<Either<Failure, List<AttachmentModel>>> createAvatarAttachment(
      List<AttachmentParam> attachments);

  Future<Either<Failure, List<AttachmentModel>>> createAttachmentData(
      List<AttachmentParam> attachments);

  Future<Either<Failure, VerifyPhoneModel>> createVerifiedNumberPhone(
      num imageId);

  Future<Either<Failure, VerifyPhoneModel>> updateVerifiedNumberPhone(
      num phoneId, num imageId);

  Future<Either<Failure, VerifyPhoneModel>> getVerifiedNumberPhone();

  Future<Either<Failure, IdentityCardModel>> createIdentityCard({
    num? frontImageId,
    num? backImageId,
    required String name,
    required String identityNumber,
    required DateTime issuedDate,
    DateTime? expiredDate,
    required String placeOfIssue,
    required String address,
  });

  Future<Either<Failure, IdentityCardModel>> updateIdentityCard({
    required num id,
    num? frontImageId,
    String? name,
    num? backImageId,
    String? identityNumber,
    DateTime? issuedDate,
    DateTime? expiredDate,
    String? placeOfIssue,
    String? address,
  });

  Future<Either<Failure, IdentityCardModel>> getIdentityCard();

  Future<Either<Failure, RelationshipInformationModel>>
      createRelationshipInformation({
    required Relationship relationship,
    required String name,
    required String phone,
  });

  Future<Either<Failure, RelationshipInformationModel>>
      updateRelationshipInformation({
    required id,
    Relationship? relationship,
    String? name,
    String? phone,
  });

  Future<Either<Failure, List<RelationshipInformationModel>>>
      getListRelationshipInformation();

  Future<Either<Failure, dynamic>> deleteRelationshipInformation(
      num relationshipId);

  Future<Either<Failure, RelationshipInformationModel>>
      getRelationshipInformation(num relationshipId);
}
