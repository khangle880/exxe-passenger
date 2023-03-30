import 'package:equatable/equatable.dart';
import 'package:exxe/src/core/base_bloc.dart';
import 'package:exxe/src/utils/constants/constants.dart';

import '../../../../data/data.dart';

part 'cancel_reason_state.dart';

class CancelReasonCubit extends BaseCubit<CancelReasonState> {
  final CompoundingCarControllerRepo repo;

  CancelReasonCubit(this.repo) : super(const CancelReasonState());

  getCancelReason(CompoundingCarCustomerState customerState) async {
    var result = await repo.getCancelReasonCompoundingCar(customerState);
    result.fold((failure) {
      emitError(failure);
    }, (data) {
      emit(state
          .copyWith(listReason: [...data, CancelReasonModel(reason: 'Khác')]));
    });
  }

  selectItem(bool? value, CancelReasonModel item) {
    if (value == null || !value) {
      if (state.selectedItem == item) {
        emit(state.copyWith(selectedItem: Nullable(null)));
      }
    } else {
      emit(state.copyWith(selectedItem: Nullable(item)));
    }
  }

  onOtherReasonChange(String otherReason) {
    emit(state.copyWith(otherReason: otherReason));
  }

  Future<CancelReturnedDepositModel?> getReturnedDepositState(
      num customerId) async {
    final result = await repo.getReturnedDepositState(customerId);
    return result.fold((l) {
      emitError(l);
      return null;
    }, (r) => r);
  }
}
