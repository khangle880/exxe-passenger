import 'package:dartz/dartz.dart';

import '../../../core/core.dart';

abstract class IPushNotificationRepo {
  Future<Either<Failure, dynamic>> loginDeviceForPartner(String playerId);

  Future<Either<Failure, dynamic>> logoutDeviceForPartner(String playerId);

  Future<Either<Failure, dynamic>> actionSendMessage({
    required List<int> receiveIds,
    required String title,
    required String content,
    required String roomId,
  });
}
