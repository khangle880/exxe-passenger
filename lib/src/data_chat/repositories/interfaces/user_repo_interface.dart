import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../../utils/constants/constants.dart';
import '../../models/models.dart';

abstract class IChatUserRepo {
  Future<Either<Failure, ChatUserModel>> register({
    required String userName,
    required String avatar,
    required num userId,
    required String phone,
  });

  Future<Either<Failure, ChatUserModel>> deleteAccount();

  Future<Either<Failure, ChatUserModel>> login(String phone, String password);

  Future<Either<Failure, dynamic>> logout();

  Future<Either<Failure, ChatTokenModel>> generateToken(
     String userId, String phone);

  Future<Either<Failure, bool>> checkPassword();

  Future<Either<Failure, dynamic>> createPassword(
      String newPass, String rePass);

  Future<Either<Failure, dynamic>> updatePassword({
    required String oldPass,
    required String newPass,
    required String rePass,
  });

  Future<Either<Failure, ChatUserModel>> getProfile(String? userId);

  Future<Either<Failure, ChatUserModel>> updateProfile({
    String? userName,
    String? avatar,
    String? bio,
    DateTime? dateOfBirth,
    Gender? gender,
  });

  Future<Either<Failure, num>> getMessageUnreadCount(String userId);
}
