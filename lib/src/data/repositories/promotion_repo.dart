import 'package:dartz/dartz.dart';

import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../../utils/export/main_app.dart';
import '../data.dart';

class PromotionRepo extends IPromotionRepo {
  late final INetworkUtility _networkUtility;

  PromotionRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, List<PromotionModel>>> getSpecialPromotions() async {
    try {
      final response = await _networkUtility.request(
        Apis.getSpecialPromotion,
        Method.POST,
        data: {
          "params": {"limit": 20, "offset": 1}
        },
      );
      ListResponse<PromotionModel> promotions =
          ListResponse(response, (data) => PromotionModel.fromJson(data));
      if (promotions.error != null) {
        return Left(ServerFailure(promotions.error!));
      }
      return Right(promotions.items!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PromotionModel>>> getListPromotions(
      int carCustomerId) async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility.request(
        Apis.getListPromotion,
        Method.POST,
        data: {
          "params": {
            "token": token,
            "compounding_car_customer_id": carCustomerId,
          }
        },
      );
      ListResponse<PromotionModel> promotions =
          ListResponse(response, (data) => PromotionModel.fromJson(data));
      if (promotions.error != null) {
        return Left(ServerFailure(promotions.error!));
      }
      return Right(promotions.items!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>>
      applyPromotionForCustomer(num carCustomerId, num promotionId) async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility.request(
        Apis.applyPromotionForCustomer,
        Method.POST,
        data: {
          "params": {
            "token": token,
            "compounding_car_customer_id": carCustomerId,
            "promotion_id": promotionId
          }
        },
      );
      SingleResponse<CompoundingCarCustomerModel> result =
          SingleResponse<CompoundingCarCustomerModel>(
              response, (data) => CompoundingCarCustomerModel.fromJson(data));

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      return Right(result.item!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>> cancelApplyPromotion(
      num compoundingCarCustomerId) async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility.request(
        Apis.cancelApplyPromotion,
        Method.POST,
        data: {
          "params": {
            "token": token,
            "compounding_car_customer_id": compoundingCarCustomerId,
          }
        },
      );
      SingleResponse<CompoundingCarCustomerModel> result =
          SingleResponse<CompoundingCarCustomerModel>(
              response, (data) => CompoundingCarCustomerModel.fromJson(data));

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      return Right(result.item!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PromotionModel>>> getListPromotionCanApply({
    int? carCustomerId,
  }) async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility.request(
        Apis.getListPromotionCanApply,
        Method.POST,
        data: {
          "params": {
            "token": token,
            "compounding_car_customer_id": carCustomerId,
          }
        },
      );
      ListResponse<PromotionModel> promotions =
          ListResponse(response, (data) => PromotionModel.fromJson(data));
      if (promotions.error != null) {
        return Left(ServerFailure(promotions.error!));
      }
      return Right(promotions.items!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PromotionModel>> getPromotionDetail(
      int promotionId) async {
    try {
      final response = await _networkUtility.request(
        Apis.getPromotionDetail,
        Method.POST,
        data: {
          "params": {"promotion_id": promotionId}
        },
      );
      SingleResponse<PromotionModel> result = SingleResponse<PromotionModel>(
          response, (data) => PromotionModel.fromJson(data));

      if (result.error != null) {
        return Left(ServerFailure(result.error!));
      }
      return Right(result.item!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
