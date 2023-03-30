import 'package:dartz/dartz.dart';

import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../../utils/export/main_app.dart';
import '../data.dart';

class NotificationRepo extends INotificationRepo {
  late final INetworkUtility _networkUtility;

  NotificationRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, NotificationDashboardModel>> getListNotification({
    int? offset,
    required List<NotificationType> notificationType,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility.request(
      Apis.getListNotification,
      Method.POST,
      data: {
        "params": {
          "token": token,
          "limit": 20,
          "offset": offset ?? 0,
          "notification_type":
              notificationType.map((e) => e.serverString).toList(),
        }
      },
    );
    return ParserHelper.singleParseDefault(
      request,
      (data) => NotificationDashboardModel.fromJson(data),
      rightPreCall: (data) {
        if (notificationType.isEmpty) {
          GetIt.I<AppState>().updateNotificationCount(
              data.unReadTransaction! + data.unReadPromotion!);
        }
      },
    );
  }

  @override
  Future<Either<Failure, dynamic>> readNotification(
      {List<int>? promotionId,
      List<int>? transactionId,
      List<int>? compoundingId}) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.readNotification, Method.POST, data: {
      "params": {
        "token": token,
        "transaction_notification": transactionId,
        "promotion_notification": promotionId,
        "compounding_notification": compoundingId,
      }.getCleanNull
    });

    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }

  @override
  Future<Either<Failure, dynamic>> deleteNotification(
      {List<int>? promotionId,
      List<int>? transactionId,
      List<int>? compoundingId}) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.deleteNotification, Method.POST, data: {
      "params": {
        "token": token,
        "transaction_notification": transactionId,
        "promotion_notification": promotionId,
        "compounding_notification": compoundingId,
      }.getCleanNull
    });

    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }

  @override
  Future<Either<Failure, dynamic>> readAllNotification() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.readAllNotification, Method.POST, data: {
      "params": {
        "token": token,
      }
    });
    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }

  @override
  Future<Either<Failure, dynamic>> deleteAllNotification() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.deleteAllNotification, Method.POST, data: {
      "params": {
        "token": token,
      }
    });

    return ParserHelper.listParseDefault(
      request,
      (value) => null,
    );
  }

  @override
  Future<Either<Failure, dynamic>> call(String phone) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility.request(
      Apis.call,
      Method.POST,
      data: {
        "params": {"token": token, "phone": phone}
      },
    );

    return ChatParserHelper.singleParseDefault(request, (value) => null);
  }

  @override
  Future<Either<Failure, dynamic>> missedCall(
      String phone, String compoundingCarCustomerCode) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility.request(
      Apis.missedCall,
      Method.POST,
      data: {
        "params": {
          "token": token,
          "phone": phone,
          "compounding_car_customer_code": compoundingCarCustomerCode,
        }
      },
    );

    return ChatParserHelper.singleParseDefault(request, (value) => null);
  }
}
