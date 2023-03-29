import 'package:dartz/dartz.dart';
import 'package:exxe/src/core/core.dart';

import '../../../utils/export/logic_export.dart';

abstract class INotificationRepo {
  Future<Either<Failure, NotificationDashboardModel>> getListNotification({
    int? offset,
    required List<NotificationType> notificationType,
  });

  Future<Either<Failure, dynamic>> readNotification(
      {List<int>? promotionId,
      List<int>? transactionId,
      List<int>? compoundingId});

  Future<Either<Failure, dynamic>> deleteNotification(
      {List<int>? promotionId,
      List<int>? transactionId,
      List<int>? compoundingId});

  Future<Either<Failure, dynamic>> readAllNotification();

  Future<Either<Failure, dynamic>> deleteAllNotification();

  Future<Either<Failure, dynamic>> call(String phone);

  Future<Either<Failure, dynamic>> missedCall(String phone);
}
