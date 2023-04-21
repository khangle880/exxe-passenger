import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../../utils/helpers/parser_helper.dart';
import '../apis.dart';
import 'interfaces/push_notification_interface.dart';

class PushNotificationRepo extends IPushNotificationRepo {
  late final INetworkUtility _networkUtility;

  PushNotificationRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, dynamic>> loginDeviceForPartner(
      String playerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.loginDeviceForPartner, Method.POST, data: {
      "params": {"token": token, "device_id": playerId}
    });

    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }

  @override
  Future<Either<Failure, dynamic>> logoutDeviceForPartner(
      String playerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.logoutDeviceForPartner, Method.POST, data: {
      "params": {"token": token, "device_id": playerId}
    });

    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }

  @override
  Future<Either<Failure, dynamic>> actionSendMessage({
    required List<int> receiveIds,
    required String title,
    required String content,
    required String roomId,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.sendNotiMessage, Method.POST, data: {
      "params": {
        "token": token,
        "receive_ids": receiveIds,
        "message_title": title,
        "message_content": content,
        "room_id": roomId,
      }
    });

    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }
}
