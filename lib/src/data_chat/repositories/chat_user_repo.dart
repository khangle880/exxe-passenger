import 'package:dartz/dartz.dart';
import 'package:exxe/src/utils/export/logic_export.dart';

import '../../core/core.dart';
import '../../storage/models/user_chat.dart';
import '../data_chat.dart';

class ChatUserRepo extends IChatUserRepo {
  late final INetworkUtility _networkUtility;

  ChatUserRepo()
      : _networkUtility = GetIt.I
            .get<INetworkUtility>(instanceName: NetworkConstant.chatDomain);

  @override
  Future<Either<Failure, ChatUserModel>> register({
    required String userName,
    required String avatar,
    required num userId,
    required String phone,
  }) {
    final request =
        _networkUtility.request(ChatApis.register, Method.POST, data: {
      "user_id": userId,
      "phone": phone,
      "avatar": avatar,
      "user_name": userName,
      "role": "customer"
    });

    return ChatParserHelper.singleParseDefault(request, ChatUserModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatUserModel>> deleteAccount() {
    final request = _networkUtility
        .request(ChatApis.deleteAccount, Method.DELETE, data: {});

    return ChatParserHelper.singleParseDefault(request, ChatUserModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatUserModel>> login(String phone, String password) {
    final request = _networkUtility.request(ChatApis.login, Method.POST, data: {
      "phone": phone,
      "password": password,
    });

    return ChatParserHelper.singleParseDefault(request, ChatUserModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatTokenModel>> generateToken(
      String userId, String phone) async {
    final deviceId = await OneSignalNotificationHelper.I.id;
    // final fcmToken = await FireBaseNotificationHelper.I.token;
    final request = _networkUtility.request(ChatApis.generateToken, Method.POST,
        data: {
          "user_id": userId,
          "phone": phone,
          "device_id": deviceId,
          // "fcm_token": fcmToken,
        }.getCleanNull);

    return ChatParserHelper.singleParseDefault(
      request,
      ChatTokenModel.fromJson,
      rightPreCall: (value) {
        BoxesChatUser.instance.setUser(
          ChatUserHive(
            token: value.accessToken!,
            refreshToken: value.refreshToken!,
          ),
        );
      },
    );
  }

  @override
  Future<Either<Failure, dynamic>> logout() {
    final request = _networkUtility.request(ChatApis.logout, Method.POST);

    return ChatParserHelper.singleParseDefault(request, (value) => null);
  }

  @override
  Future<Either<Failure, bool>> checkPassword() {
    final request = _networkUtility.request(ChatApis.checkPassword, Method.GET);

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['has_password']);
  }

  @override
  Future<Either<Failure, dynamic>> createPassword(
      String newPass, String rePass) {
    final request =
        _networkUtility.request(ChatApis.createPassword, Method.POST, data: {
      "new_password": newPass,
      "confirm_new_password": rePass,
    });

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['has_password']);
  }

  @override
  Future<Either<Failure, dynamic>> updatePassword(
      {required String oldPass,
      required String newPass,
      required String rePass}) {
    final request =
        _networkUtility.request(ChatApis.updatePassword, Method.PATCH, data: {
      "current_password": oldPass,
      "new_password": newPass,
      "confirm_new_password": rePass,
    });

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['has_password']);
  }

  @override
  Future<Either<Failure, ChatUserModel>> updateProfile(
      {String? userName,
      String? avatar,
      String? bio,
      DateTime? dateOfBirth,
      Gender? gender}) {
    final body = {
      "user_name": userName,
      "avatar": avatar,
      "bio": bio,
      "date_of_birth": dateOfBirth?.toFormat("yyyy-MM-dd"),
      "gender": gender?.serverString
    }.getCleanNull;
    final request = _networkUtility
        .request(ChatApis.updateProfile, Method.PATCH, data: body);

    return ChatParserHelper.singleParseDefault(request, ChatUserModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatUserModel>> getProfile(String? userId) {
    final request = _networkUtility.request(ChatApis.getProfile, Method.GET,
        queryParameters: {"user_id": userId}.getCleanNull);

    return ChatParserHelper.singleParseDefault(request, ChatUserModel.fromJson);
  }

  @override
  Future<Either<Failure, num>> getMessageUnreadCount(String userId) {
    final request = _networkUtility.request(
        ChatApis.getMessageUnreadCount, Method.GET,
        queryParameters: {"user_id": userId});

    return ChatParserHelper.singleParseDefault(
      request,
      (value) => value['message_unread_count'],
      rightPreCall: (value) {
        GetIt.I<AppState>().updateMessageCount(value.ceil());
      },
    );
  }
}
