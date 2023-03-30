import 'package:dartz/dartz.dart';

import '../../core/core.dart';
import '../../data_chat/data_chat.dart';
import '../../storage/models/user.dart';
import '../../storage/models/user_chat.dart';
import '../../utils/export/logic_export.dart';

class UserRepo extends IUserRepo {
  late final INetworkUtility _networkUtility;

  UserRepo() {
    _networkUtility = GetIt.I.get<INetworkUtility>();
  }

  @override
  Future<Either<Failure, void>> checkToken() async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response =
          await _networkUtility.request(Apis.getUserInfo, Method.POST, data: {
        "params": {
          "token": token,
        }
      });

      StatusResponse result = StatusResponse(response);

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
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
  Future<Either<Failure, TokenModel>> login(
      {required String phone, required String password}) async {
    final request = _networkUtility.request(Apis.login, Method.POST, data: {
      "params": {
        "phone": phone,
        "password": password,
      }
    });

    return ParserHelper.singleParseDefault(
        request, (json) => TokenModel.fromJson(json));
  }

  @override
  Future<Either<Failure, dynamic>> deleteAccount(String stringeeToken) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.deleteAccount, Method.POST, data: {
      "params": {
        "token": token,
        "stringee_access_token": stringeeToken,
      }
    });

    return ParserHelper.singleParseDefault(
      request,
      (data) => null,
      rightPreCall: (value) {
        ChatUserRepo().deleteAccount();
      },
    );
  }

  @override
  Future<Either<Failure, dynamic>> sendOtp(String phone) async {
    try {
      final response =
          await _networkUtility.request(Apis.sendOtp, Method.POST, data: {
        "params": {
          "phone": phone,
        }
      });

      StatusResponse result = StatusResponse(response);

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(
      String phone, String otpCode) async {
    final request = _networkUtility.request(Apis.verifyOtp, Method.POST, data: {
      "params": {
        "phone": phone,
        "otp_code": otpCode,
      }
    });

    return ParserHelper.singleParseDefault(
        request, (json) => json['stringee_access_token']);
  }

  @override
  Future<Either<Failure, PartnerModel>> checkPhoneRegistered(
      String phone) async {
    final request =
        _networkUtility.request(Apis.checkPhoneRegistered, Method.POST, data: {
      "params": {
        "phone": phone,
      }
    });
    return ParserHelper.singleParseDefault(request, PartnerModel.fromJson);
  }

  @override
  Future<Either<Failure, PartnerModel>> authWithPhoneOtp(
      {required String stringeeAccessToken, String? userName}) async {
    final params = {
      "type": "stringee",
      "stringee_access_token": stringeeAccessToken,
      "name_user": userName,
    }.getCleanNull;
    final request = _networkUtility
        .request(Apis.authWithPhoneOtp, Method.POST, data: {"params": params});
    return ParserHelper.singleParseDefault(request, PartnerModel.fromJson,
        rightPreCall: (value) async {
      if (value.chatSecretKey != null) {
        final result = await ChatUserRepo()
            .generateToken(value.chatSecretKey!, value.phone!);
        result.fold((l) => null, (data) {
          BoxesChatUser.instance.setUser(
            ChatUserHive(
              token: data.accessToken!,
              refreshToken: data.refreshToken!,
            ),
          );
        });
      }
    });
  }

  @override
  Future<Either<Failure, bool>> checkHasPassword() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.checkPasswordExist, Method.POST, data: {
      "params": {
        "token": token,
      }
    });
    return ParserHelper.singleParseDefault(
        request, (json) => json['has_password']);
  }

  @override
  Future<Either<Failure, dynamic>> createNewPassword(
    String password,
    String rePassword,
  ) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    try {
      final response = await _networkUtility
          .request(Apis.createNewPassword, Method.POST, data: {
        "params": {
          "token": token,
          "password": password,
          "re_password": rePassword,
        }
      });
      StatusResponse result = StatusResponse(response);

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }

      final chatUserRepo = ChatUserRepo();
      await chatUserRepo.checkPassword().then((checkPassEither) {
        checkPassEither.fold((l) => null, (data) {
          if (!data) {
            chatUserRepo.createPassword(password, rePassword);
          }
        });
      });
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, dynamic>> changePassword({
    required String old,
    required String newPass,
    required String rePass,
  }) async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility
          .request(Apis.changePassword, Method.POST, data: {
        "params": {
          "token": token,
          "old_password": old,
          "password": newPass,
          "re_password": rePass,
        }
      });

      StatusResponse result = StatusResponse(response);

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }

      final chatUserRepo = ChatUserRepo();
      await chatUserRepo.checkPassword().then((checkPassEither) {
        checkPassEither.fold((l) => null, (data) {
          if (data) {
            chatUserRepo.updatePassword(
                oldPass: old, newPass: newPass, rePass: rePass);
          } else {
            chatUserRepo.createPassword(newPass, rePass);
          }
        });
      });
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TokenModel>> resetPassword({
    required String stringeeToken,
    required String newPass,
    required String rePass,
  }) async {
    final request =
        _networkUtility.request(Apis.resetPassword, Method.POST, data: {
      "params": {
        "stringee_access_token": stringeeToken,
        "password": newPass,
        "re_password": rePass,
      }
    });
    return ParserHelper.singleParseDefault(request, TokenModel.fromJson);
  }
}
