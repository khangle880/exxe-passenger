import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:exxe/src/core/error/error.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../core/base_bloc.dart';
import '../../../../data/data.dart';

part 'promotion_state.dart';

class PromotionCubit extends BaseCubit<PromotionState> {
  final IPromotionRepo _promotionRepo = GetIt.I<IPromotionRepo>();

  PromotionCubit() : super(const PromotionState());

  void getListPromotionCanApply({
    int? carCustomerId,
  }) async {
    final result = await _promotionRepo.getListPromotionCanApply(
        carCustomerId: carCustomerId);
    result.fold(
      (failure) => log('ko lay dc promotion $failure'),
      (data) => emit(
        state.copyWith(promotions: data),
      ),
    );
  }

  void applyPromotion(
      {required num carCustomerId,
      required num promotionId,
      num? currentPromoId}) async {
    emitWaiting(true);
    Either<Failure, CompoundingCarCustomerModel> result;
    if (currentPromoId == promotionId) {
      result = await _promotionRepo.cancelApplyPromotion(carCustomerId);
    } else {
      result = await _promotionRepo.applyPromotionForCustomer(
          carCustomerId, promotionId);
    }
    emitWaiting(false);
    result.fold(
      (failure) {
        emitError(failure);
      },
      (data) => emit(
        state.copyWith(carCustomer: data),
      ),
    );
  }
}
