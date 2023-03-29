import 'package:dartz/dartz.dart';
import 'package:exxe/src/core/core.dart';

import '../../../utils/export/logic_export.dart';

abstract class IPromotionRepo {
  Future<Either<Failure, List<PromotionModel>>> getSpecialPromotions();

  Future<Either<Failure, List<PromotionModel>>> getListPromotions(
      int carCustomerId);

  Future<Either<Failure, List<PromotionModel>>> getListPromotionCanApply({
    int? carCustomerId,
  });

  Future<Either<Failure, CompoundingCarCustomerModel>>
      applyPromotionForCustomer(num carCustomerId, num promotionId);

  Future<Either<Failure, CompoundingCarCustomerModel>> cancelApplyPromotion(
      num compoundingCarCustomerId);

  Future<Either<Failure, PromotionModel>> getPromotionDetail(int promotionId);
}
