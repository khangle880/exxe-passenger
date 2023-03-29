import 'package:collection/collection.dart';

import '../../app/app_state.dart';
import '../../data_chat/data_chat.dart';
import '../../storage/models/user.dart';
import '../../utils/export/repo_export.dart';

class CompoundingCarControllerRepo extends ICompoundingCarCtrlRepo {
  late final INetworkUtility _networkUtility;

  CompoundingCarControllerRepo()
      : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
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
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "from_province_id": fromProvinceId,
      "to_province_id": toProvinceId,
      "car_id": carId,
      "number_seat": numberSeat,
      "compounding_type": type?.serverString,
      "expected_going_on_date": expectedGoingOnDate?.serverFormat,
      "from_expected_going_on_date":
          fromExpectedGoingOnDate?.serverFormatOnlyDate,
      "to_expected_going_on_date": toExpectedGoingOnDate?.serverFormatOnlyDate,
      "sort_by_lowest_price": isPriceAsc,
      "sort_by_highest_price": isPriceDesc,
      "sort_by_distance": isSortByDistance,
      "current_latitude": currentCoordinate?.latitude,
      "current_longitude": currentCoordinate?.longitude,
      "limit": 20,
      "offset": offset,
    }..removeWhere((key, value) => value == null);

    final request = _networkUtility.request(
        Apis.getCompoundingCarAvailable, Method.POST,
        data: {"params": params});

    return ParserHelper.listParseDefault(request, CompoundingCarModel.fromJson);
  }

  @override
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
    num? hourOfWaitTime,
    DateTime? expectedPickingUpDate,
    num? star,
    String? note,
    num? waitingChargeId,
  }) async {
    assert(from.provinceId != null && to.provinceId != null);
    assert(
        !((type == CompoundingType.compounding) &&
            (from.stationId == null ||
                to.stationId == null ||
                numberSeat == null)),
        "Must has station id when type is compounding");
    assert(
        !(type == CompoundingType.twoWay &&
            isADayTour != null &&
            isADayTour == false &&
            expectedPickingUpDate == null),
        "Must has expectedPickingUpDate when type is TwoWay and isADayTour is false");
    final fromAddress =
        ([CompoundingType.oneWay, CompoundingType.twoWay]).contains(type)
            ? from.address
            : (isPickingUpFromStart ?? false)
                ? from.address
                : from.station?.street;
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "compounding_type": type.serverString,
      "from_province_id": from.provinceId,
      // Trường này bắt buộc nếu compounding_type == 'compounding'
      "from_pick_up_station_id": from.stationId,
      "is_picking_up_from_start": isPickingUpFromStart,
      "from_address": fromAddress,
      "from_longitude": from.coordinate!.longitude,
      "from_latitude": from.coordinate!.latitude,
      "to_province_id": to.provinceId,
      // Trường này bắt buộc nếu compounding_type == 'compounding'
      "to_pick_up_station_id": to.stationId,
      "to_address": to.address,
      "to_longitude": to.coordinate!.longitude,
      "to_latitude": to.coordinate!.latitude,
      "expected_going_on_date": expectedGoingOnDate.serverFormat,
      "car_id": carId,
      "distance": distance,
      "duration": duration,
      // Chuyến đi trong ngày. Trường này bắt buộc nếu compounding_type == 'two_way'
      "is_a_day_tour": isADayTour ?? false,
      "hour_of_wait_time": hourOfWaitTime?.getWaitHour,
      "number_seat": numberSeat,
      // compounding_type == two_way,
      // is_a_day_tour == FALSE
      // thì trường này bắt buộc.
      "expected_picking_up_date": expectedPickingUpDate?.serverFormat,
      "quality_car": star == null ? null : "${star}_star",
      "note": note,
      "waiting_charge_block_id": waitingChargeId,
    }.getCleanNull;

    final request = _networkUtility.request(
        Apis.createCompoundingCar, Method.POST,
        data: {"params": params});

    return ParserHelper.singleParseDefault(
      request,
      CompoundingCarCustomerModel.fromJson,
      rightPreCall: (value) {
        GetIt.I<AppState>()
            .createAction(ActionStateEnum.createRide, object: value);
      },
    );
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>> updateCompoundingCar(
    num customerId, {
    CompoundingType? type,
    LocationModel? from,
    LocationModel? to,
    DateTime? expectedGoingOnDate,
    num? carId,
    num? numberSeat,
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
  }) async {
    final fromAddress =
        ([CompoundingType.oneWay, CompoundingType.twoWay]).contains(type)
            ? from?.address
            : (isPickingUpFromStart ?? false)
                ? from?.address
                : from?.station?.street;
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "compounding_car_customer_id": customerId,
      "compounding_type": type?.serverString,
      "from_province_id": from?.provinceId,
      "from_pick_up_station_id": from?.stationId,
      "is_picking_up_from_start": isPickingUpFromStart,
      "from_address": fromAddress,
      "from_longitude": from?.coordinate!.longitude,
      "from_latitude": from?.coordinate!.latitude,
      "to_province_id": to?.provinceId,
      "to_pick_up_station_id": to?.stationId,
      "to_address": to?.address,
      "to_longitude": to?.coordinate!.longitude,
      "to_latitude": to?.coordinate!.latitude,
      "expected_going_on_date": expectedGoingOnDate?.serverFormat,
      "is_a_day_tour": isADayTour,
      "car_id": carId,
      "number_seat": numberSeat,
      "hour_of_wait_time": hourOfWaitTime?.getWaitHour,
      "expected_picking_up_date": expectedPickingUpDate?.serverFormat,
      "distance": distance,
      "duration": duration,
      "quality_car": star == null ? null : "${star}_star",
      "note": note,
      "waiting_charge_block_id": waitingChargeId,
      "promotion_id": promotionId,
      "deposit_percentage":
          depositPercentage == null ? null : depositPercentage * 100,
    }..removeWhere((key, value) => value == null);

    final request = _networkUtility.request(
        Apis.updateCompoundingCar, Method.POST,
        data: {"params": params});

    return ParserHelper.singleParseDefault(
      request,
      CompoundingCarCustomerModel.fromJson,
      rightPreCall: (value) {
        GetIt.I<AppState>()
            .createAction(ActionStateEnum.updateRide, object: value);
      },
    );
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>> confirmCompoundingCar({
    required num customerId,
    required bool isExportElectricInvoice,
    String? companyName,
    String? companyAddress,
    String? companyTaxCode,
    String? companyEmail,
    String? companyPhone,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.confirmCompoundingCar, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": customerId,
        "is_export_electric_invoice": isExportElectricInvoice,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_tax_code": companyTaxCode,
        "company_email": companyEmail,
        "company_phone": companyPhone,
      }.getCleanNull
    });

    return ParserHelper.singleParseDefault(
      request,
      CompoundingCarCustomerModel.fromJson,
      rightPreCall: (value) {
        GetIt.I<AppState>()
            .createAction(ActionStateEnum.confirmRide, object: value);
      },
    );
  }

  @override
  Future<Either<Failure, ElectricInvoiceModel>> getTaxCodeInformation() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getTaxCodeInformation, Method.POST, data: {
      "params": {"token": token}
    });

    return ParserHelper.singleParseDefault(
        request, ElectricInvoiceModel.fromJson);
  }

  @override
  Future<Either<Failure, List<PaymentMethodModel>>>
      getPaymentInAppMethods() async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility
          .request(Apis.getPaymentInAppMethods, Method.POST, data: {
        "params": {"token": token}
      });

      ListResponse<PaymentMethodModel> methods =
          ListResponse<PaymentMethodModel>(
              response, (data) => PaymentMethodModel.fromJson(data));

      if (methods.error != null) {
        return Left(ServerFailure(methods.error!));
      }
      var list = methods.items!;
      final item = list.firstWhereOrNull((element) =>
          element.provider == RemainingPaymentMethod.exxeWallet.serverString);
      if (item != null) {
        list = {item, ...list}.toList();
      }

      return Right(list);
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodModel>>>
      getPaymentFinalMethods() async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility
          .request(Apis.getPaymentFinalMethods, Method.POST, data: {
        "params": {"token": token}
      });

      ListResponse<PaymentMethodModel> methods =
          ListResponse<PaymentMethodModel>(
              response, (data) => PaymentMethodModel.fromJson(data));

      if (methods.error != null) {
        return Left(ServerFailure(methods.error!));
      }
      return Right(methods.items!);
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CompoundingPaymentRequest>> createVNPayPayment({
    required num methodId,
    required num customerId,
    required String returnUrl,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.createVNPayDepositNew, Method.POST, data: {
      "params": {
        "token": token,
        "acquirer_id": methodId,
        "compounding_car_customer_id": customerId,
        "returned_url": returnUrl,
      }
    });
    return ParserHelper.singleParseDefault(
      request,
      CompoundingPaymentRequest.fromJson,
      rightPreCall: (value) {
        if (value.customer != null) {
          GetIt.I<AppState>()
              .createAction(ActionStateEnum.confirmDepositRide, object: value);
          GetIt.I<AppState>()
              .createAction(ActionStateEnum.confirmDepositRide, object: value);
        }
      },
    );
  }

  @override
  Future<Either<Failure, PaymentModel>> confirmCompoundingPayment(
      num customerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.confirmDepositPaymentNew, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": customerId,
      }
    });
    return ParserHelper.singleParseDefault(
      request,
      (value) => PaymentModel.fromJson(value['deposit_payment']),
      rightPreCall: (value) {
        GetIt.I<AppState>()
            .createAction(ActionStateEnum.confirmDepositRide, object: value);
      },
    );
  }

  @override
  Future<Either<Failure, VnpayResponseModel>> getTransactionState(
    num compoundingCarCustomerId,
    String vnpCode,
  ) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getTransactionState, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": compoundingCarCustomerId,
        "vnpay_code": vnpCode
      }
    });
    return ParserHelper.singleParseDefault(
        request, VnpayResponseModel.fromJson);
  }

  @override
  Future<Either<Failure, List<CancelReasonModel>>>
      getCancelReasonCompoundingCar(CompoundingCarCustomerState state) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getCancelReasonCompoundingCar, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_state": state.serverString
      }
    });

    return ParserHelper.listParseDefault(request, CancelReasonModel.fromJson);
  }

  @override
  Future<Either<Failure, CancelReturnedDepositModel>> getReturnedDepositState(
      num customerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getReturnedDepositState, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": customerId,
      }
    });

    return ParserHelper.singleParseDefault(
        request, CancelReturnedDepositModel.fromJson);
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>> cancelCompoundingCar(
    CompoundingCarCustomerModel customer, {
    num? reasonId,
    String? reasonOther,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "compounding_car_customer_id": customer.compoundingCarCustomerId!,
      "cancel_reason_id": reasonId,
      "cancel_reason_other": reasonOther,
    }..removeWhere((key, value) => value == null);

    final request = _networkUtility.request(
        Apis.cancelCompoundingCar, Method.POST,
        data: {"params": params});

    return ParserHelper.singleParseDefault(
      request,
      CompoundingCarCustomerModel.fromJson,
      rightPreCall: (value) {
        GetIt.I<AppState>()
            .createAction(ActionStateEnum.cancelRide, object: value);
        ChatRoomRepo()
            .deleteByDependId(customer.compoundingCarCustomerCode!)
            .then((either) {
          either.fold((l) => log(l.toString()), (data) {
            ChatSocketHelper()
                .controller
                .items
                .removeWhere((element) => element.dependId == data);
          });
        });
      },
    );
  }

  @override
  Future<Either<Failure, dynamic>> depositTimeOutCarCustomer(
      {required num compoundingCarCustomerId}) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.depositTimeOut, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": compoundingCarCustomerId,
      }
    });

    return ParserHelper.singleParseDefault(
      request,
      (value) => null,
      rightPreCall: (value) {
        GetIt.I<AppState>()
            .createAction(ActionStateEnum.cancelRide, object: value);
      },
    );
  }

  @override
  Future<Either<Failure, CompoundingCarModel>> getDetailCompoundingCar(
      num compoundingCarId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getDetailCompoundingCar, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_id": compoundingCarId,
      }
    });

    return ParserHelper.singleParseDefault(
        request, CompoundingCarModel.fromJson);
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>>
      getDetailCompoundingCarCustomer(num compoundingCarCustomerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getDetailCompoundingCarCustomer, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": compoundingCarCustomerId,
      }
    });
    return ParserHelper.singleParseDefault(
        request, CompoundingCarCustomerModel.fromJson);
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>>
      createCompoundingCarCustomer({
    required num compoundingCarId,
    required CompoundingType type,
    required LocationModel from,
    required LocationModel to,
    required num distance,
    required num? numberSeat,
    // in 2 hour -> compoundingCar.goingOnDate = 12h -> customer 10h-12h
    required DateTime? expectedGoingOnDate,
    num? carId,
    bool? isPickingUpFromStart,
    num? hourOfWaitTime,
    num? duration,
    String? note,
  }) async {
    assert(from.provinceId != null &&
        to.provinceId != null &&
        from.stationId != null &&
        to.stationId != null);
    final fromAddress =
        ([CompoundingType.oneWay, CompoundingType.twoWay]).contains(type)
            ? from.address
            : (isPickingUpFromStart ?? false)
                ? from.address
                : from.station?.street;
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "compounding_car_id": compoundingCarId,
      "compounding_type": type.serverString,
      "from_province_id": from.provinceId,
      // Trường này bắt buộc nếu compounding_type == 'compounding'
      "from_pick_up_station_id": from.stationId,
      "is_picking_up_from_start": isPickingUpFromStart,
      "from_address": fromAddress,
      "from_longitude": from.coordinate!.longitude,
      "from_latitude": from.coordinate!.latitude,
      "to_province_id": to.provinceId,
      // Trường này bắt buộc nếu compounding_type == 'compounding'
      "to_pick_up_station_id": to.stationId,
      "to_address": to.address,
      "to_longitude": to.coordinate!.longitude,
      "to_latitude": to.coordinate!.latitude,
      "expected_going_on_date": expectedGoingOnDate?.serverFormat,
      "car_id": carId,
      "number_seat": numberSeat,
      "distance": distance,
      "duration": duration,
      "note": note,
    }..removeWhere((key, value) => value == null);

    log(params.toString());

    final request = _networkUtility.request(
        Apis.createCompoundingCarCustomer, Method.POST,
        data: {"params": params});

    return ParserHelper.singleParseDefault(
        request, CompoundingCarCustomerModel.fromJson);
  }

  @override
  Future<Either<Failure, List<WaitingChargeBlockModel>>> getWaitingChargeBlock(
      num distance) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getWaitingChargeBlock, Method.POST, data: {
      "params": {
        "token": token,
        "distance": distance,
      }
    });

    return ParserHelper.paginateParseDefault(
        request, WaitingChargeBlockModel.fromJson);
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>>
      confirmCompoundingCarCustomer(num customerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.confirmCompoundingCarCustomer, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": customerId,
      }
    });

    return ParserHelper.singleParseDefault(
        request, CompoundingCarCustomerModel.fromJson);
  }

  @override
  Future<Either<Failure, CompoundingCarCustomerModel>>
      paymentRemainingOfCustomer(num customerId, String method, num tip) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.paymentRemainingOfCustomer, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": customerId,
        "payment_method": method,
        "tip": tip,
      }
    });

    return ParserHelper.singleParseDefault(
      request,
      CompoundingCarCustomerModel.fromJson,
      rightPreCall: (value) {
        if (method == RemainingPaymentMethod.exxeWallet.serverString) {
          GetIt.I<AppState>()
              .createAction(ActionStateEnum.recharge, object: value);
        }
      },
    );
  }

  /// not use
  @override
  Future<Either<Failure, CompoundingCarCustomerModel>> createVNPayRemain({
    required num acquirerId,
    required num customerId,
    required String returnedUrl,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.createVNPayRemain, Method.POST, data: {
      "params": {
        "token": token,
        "acquirer_id": acquirerId,
        "compounding_car_customer_id": customerId,
        "returned_url": returnedUrl,
      }
    });

    return ParserHelper.singleParseDefault(
        request, CompoundingCarCustomerModel.fromJson);
  }

  /// not use
  @override
  Future<Either<Failure, CompoundingCarCustomerModel>>
      confirmRemainingVnpayPayment(num customerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.confirmRemainingVnpayPayment, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": customerId,
      }
    });

    return ParserHelper.singleParseDefault(
        request, CompoundingCarCustomerModel.fromJson);
  }

  @override
  Future<Either<Failure, List<CompoundingCarCustomerModel>>>
      getHistoryCompoundingCarCustomer({
    required List<CompoundingCarCustomerState> states,
    num? offset,
    num? limit,
    bool? reverse,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getHistoryCompoundingCarCustomer, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_state": states.map((e) => e.serverString).toList(),
        "limit": limit ?? 20,
        "offset": offset ?? 0,
        "reverse": reverse,
        // "rating_state": ratingState.serverString,
      }.getCleanNull
    });

    return ParserHelper.listParseDefault(
        request, CompoundingCarCustomerModel.fromJson);
  }

  @override
  Future<Either<Failure, dynamic>> deleteCompoundingCar(num customerId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.deleteCompoundingCarCustomer, Method.POST, data: {
      "params": {
        "token": token,
        "compounding_car_customer_id": customerId,
      }
    });

    return ParserHelper.listParseDefault(request, (value) => null,
        rightPreCall: (value) {
      GetIt.I<AppState>().createAction(
        ActionStateEnum.deleteDraft,
        object:
            CompoundingCarCustomerModel(compoundingCarCustomerId: customerId),
      );
    });
  }
}
