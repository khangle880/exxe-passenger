import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../../utils/constants/enum/enum.dart';
import '../../models/models.dart';

abstract class ICompoundingCarCtrlRepo {
  Future<Either<Failure, List<CompoundingCarModel>>>
      getCompoundingCarAvailable({
    num? fromProvinceId,
    num? toProvinceId,

    /// only compounding and Convenient
    required CompoundingType? type,
    num? carId,
    num? numberSeat,
    DateTime? expectedGoingOnDate,
    DateTime? fromExpectedGoingOnDate,
    DateTime? toExpectedGoingOnDate,
    bool? isPriceDesc,
    bool? isPriceAsc,
    bool? isSortByDistance,
    CoordinateModel? currentCoordinate,
    num? offset,
  });

  Future<Either<Failure, List<CompoundingCarCustomerModel>>>
      getHistoryCompoundingCarCustomer({
    required List<CompoundingCarCustomerState> states,
    num? offset,
    num? limit,
    bool? reverse,
  });

  Future<Either<Failure, CompoundingCarCustomerModel>> createCompoundingCar({
    required CompoundingType type,
    required LocationModel from,
    required LocationModel to,
    required DateTime expectedGoingOnDate,
    required num carId,
    required num distance,
    required num duration,
    num? numberSeat,
    bool? isPickingUpFromStart,
    bool? isADayTour,
    DateTime? expectedPickingUpDate,
    num? star,
    String? note,
    num? waitingChargeId,
  });

  Future<Either<Failure, CompoundingCarCustomerModel>> updateCompoundingCar(
    num customerId, {
    CompoundingType? type,
    LocationModel? from,
    LocationModel? to,
    num? numberSeat,
    DateTime? expectedGoingOnDate,
    num? carId,
    num? distance,
    num? duration,
    bool? isPickingUpFromStart,
    bool? isADayTour,
    num? hourOfWaitTime,
    DateTime? expectedPickingUpDate,
    num? star,
    String? note,
    num? waitingChargeId,
    num? depositPercentage,
    num? promotionId,
  });

  Future<Either<Failure, dynamic>> deleteCompoundingCar(num customerId);

  Future<Either<Failure, CompoundingCarCustomerModel>> confirmCompoundingCar({
    required num customerId,
    required bool isExportElectricInvoice,
    String? companyName,
    String? companyAddress,
    String? companyTaxCode,
    String? companyEmail,
    String? companyPhone,
  });

  Future<Either<Failure, ElectricInvoiceModel>> getTaxCodeInformation();

  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentInAppMethods();

  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentFinalMethods();

  Future<Either<Failure, CompoundingPaymentRequest>> createVNPayPayment({
    required num methodId,
    required num customerId,
    required String returnUrl,
  });

  Future<Either<Failure, PaymentModel>> confirmCompoundingPayment(
    num customerId,
  );

  Future<Either<Failure, VnpayResponseModel>> getTransactionState(
    num compoundingCarCustomerId,
    String vnpCode,
  );

  Future<Either<Failure, List<CancelReasonModel>>>
      getCancelReasonCompoundingCar(CompoundingCarCustomerState state);

  Future<Either<Failure, CancelReturnedDepositModel>> getReturnedDepositState(
      num customerId);

  Future<Either<Failure, CompoundingCarCustomerModel>> cancelCompoundingCar(
    CompoundingCarCustomerModel customer, {
    num? reasonId,
    String? reasonOther,
  });

  Future<Either<Failure, CompoundingCarModel>> getDetailCompoundingCar(
    num compoundingCarId,
  );

  Future<Either<Failure, CompoundingCarCustomerModel>>
      getDetailCompoundingCarCustomer(
    num compoundingCarCustomerId,
  );

  Future<Either<Failure, CompoundingCarCustomerModel>>
      createCompoundingCarCustomer({
    required num compoundingCarId,
    required CompoundingType type,
    required LocationModel from,
    required LocationModel to,
    required num distance,
    required num? numberSeat,
    required DateTime? expectedGoingOnDate,
    num? carId,
    bool? isPickingUpFromStart,
    num? hourOfWaitTime,
    num? duration,
    String? note,
  });

  Future<Either<Failure, List<WaitingChargeBlockModel>>> getWaitingChargeBlock(
      num distance);

  Future<Either<Failure, CompoundingCarCustomerModel>>
      confirmCompoundingCarCustomer(num customerId);

  Future<Either<Failure, CompoundingCarCustomerModel>>
      paymentRemainingOfCustomer(
    num customerId,
    String method,
    num tip,
  );

  Future<Either<Failure, CompoundingCarCustomerModel>> createVNPayRemain({
    required num acquirerId,
    required num customerId,
    required String returnedUrl,
  });

  Future<Either<Failure, CompoundingCarCustomerModel>>
      confirmRemainingVnpayPayment(
    num customerId,
  );

  Future<Either<Failure, dynamic>> depositTimeOutCarCustomer(
      {required num compoundingCarCustomerId});
}
