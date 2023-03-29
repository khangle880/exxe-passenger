import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../models/models.dart';

abstract class IUserRepo {
  Future<Either<Failure, void>> checkToken();

  Future<Either<Failure, GeneralUserInfoModel>> getGeneralUserInfo();

  Future<Either<Failure, TokenModel>> login(
      {required String phone, required String password});

  Future<Either<Failure, dynamic>> deleteAccount(String stringeeToken);

  Future<Either<Failure, dynamic>> sendOtp(String phone);

  Future<Either<Failure, String>> verifyOtp(String phone, String otpCode);

  Future<Either<Failure, PartnerModel>> checkPhoneRegistered(String phone);

  Future<Either<Failure, PartnerModel>> authWithPhoneOtp(
      {required String stringeeAccessToken, String? userName});

  Future<Either<Failure, bool>> checkHasPassword();

  Future<Either<Failure, dynamic>> createNewPassword(
      String password, String rePassword);

  Future<Either<Failure, dynamic>> changePassword({
    required String old,
    required String newPass,
    required String rePass,
  });

  Future<Either<Failure, TokenModel>> resetPassword({
    required String stringeeToken,
    required String newPass,
    required String rePass,
  });
}
