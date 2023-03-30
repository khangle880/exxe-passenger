import 'package:equatable/equatable.dart';
import '../../../../utils/export/logic_export.dart';

part 'confirm_booking_state.dart';

class ConfirmBookingCubit extends BaseCubit<ConfirmBookingState> {
  final ICompoundingCarCtrlRepo repo;

  ConfirmBookingCubit(this.repo, CompoundingCarCustomerModel carCustomer)
      : super(ConfirmBookingState(customerModel: carCustomer)) {
    repo.getTaxCodeInformation().then((either) {
      either.fold((l) => null, (r) {
        emit(state.copyWith(
          companyTaxCode: r.companyTaxCode,
          companyName: r.companyName,
          companyAddress: r.companyAddress,
          companyEmail: r.companyEmail,
          companyPhone: r.companyPhone,
        ));
      });
    });
  }

  updateField({
    bool? isExxeRuleChecked,
    bool? isExportInvoiceChecked,
    String? companyName,
    String? companyAddress,
    String? companyTaxCode,
    String? companyEmail,
    String? companyPhone,
    CompoundingCarCustomerModel? customerModel,
  }) {
    emit(state.copyWith(
      isExxeRuleChecked: isExxeRuleChecked,
      isExportInvoiceChecked: isExportInvoiceChecked,
      companyName: companyName,
      companyAddress: companyAddress,
      companyTaxCode: companyTaxCode,
      companyEmail: companyEmail,
      companyPhone: companyPhone,
      customerModel: customerModel,
    ));
  }

  Future<CompoundingCarCustomerModel> onConfirm() async {
    emitWaiting(true);
    final result = await CompoundingCarControllerRepo().confirmCompoundingCar(
      customerId: state.customerModel.compoundingCarCustomerId!,
      isExportElectricInvoice: state.isExportInvoiceChecked,
      companyAddress: state.companyAddress,
      companyEmail: state.companyEmail,
      companyName: state.companyName,
      companyPhone: state.companyPhone,
      companyTaxCode: state.companyTaxCode,
    );
    emitWaiting(false);
    return result.fold(
      (failure) {
        emitError(failure);
        return Future.error(failure);
      },
      (data) {
        emit(state.copyWith(customerModel: data));
        return data;
      },
    );
  }

  updateDepositPercent(double percent) async {
    emitWaiting(true);
    final result = await CompoundingCarControllerRepo().updateCompoundingCar(
      state.customerModel.compoundingCarCustomerId!,
      depositPercentage: percent,
      promotionId: state.customerModel.promotion?.promotionId,
    );
    emitWaiting(false);
    result.fold(
      (failure) => emitError(failure),
      (data) => emit(state.copyWith(customerModel: data)),
    );
  }
}
