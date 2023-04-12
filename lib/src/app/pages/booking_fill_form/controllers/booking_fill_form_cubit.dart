import 'dart:math' show max;

import 'package:equatable/equatable.dart';

import '../../../../core/base_bloc.dart';
import '../../../../core/core.dart';
import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

part 'booking_fill_form_state.dart';

class BookingFillFormCubit extends BaseCubit<BookingFillFormState> {
  BookingFillFormCubit(
    this.compoundingCarCtrlRepo,
    this.placesRepository,
    this.dataControllerRepo,
  ) : super(const BookingFillFormState());

  final ICompoundingCarCtrlRepo compoundingCarCtrlRepo;
  final IPlacesRepository placesRepository;
  final IDataControllerRepo dataControllerRepo;

  mapCompoundingCarToState(CompoundingCarCustomerModel carCustomerModel) async {
    ProvinceModel? pickUpProvince;
    ProvinceModel? destinationProvince;

    if (carCustomerModel.fromProvince != null) {
      pickUpProvince =
          _getProvince(carCustomerModel.fromProvince!.provinceId!.ceil());
    }

    if (carCustomerModel.toProvince != null) {
      destinationProvince =
          _getProvince(carCustomerModel.toProvince!.provinceId!.ceil());
    }
    emit(
      state.copyWith(
        pickupPoint: pickUpProvince == null
            ? LocationModel()
            : LocationModel(
                address: carCustomerModel.fromAddress,
                coordinate: CoordinateModel(
                  latitude:
                      double.tryParse(carCustomerModel.fromLatitude ?? ''),
                  longitude:
                      double.tryParse(carCustomerModel.fromLongitude ?? ''),
                ),
                province: pickUpProvince,
                station: pickUpProvince.pickingUpStations?.firstWhereOrNull(
                    (element) =>
                        element.stationId ==
                        carCustomerModel.fromPickUpStation?.stationId),
                stations: pickUpProvince.pickingUpStations,
              ),
        destinationPoint: destinationProvince == null
            ? LocationModel()
            : LocationModel(
                address: carCustomerModel.toAddress,
                coordinate: CoordinateModel(
                  latitude: double.tryParse(carCustomerModel.toLatitude ?? ''),
                  longitude:
                      double.tryParse(carCustomerModel.toLongitude ?? ''),
                ),
                province: destinationProvince,
                station: destinationProvince.pickingUpStations
                    ?.firstWhereOrNull((element) =>
                        element.stationId ==
                        carCustomerModel.toPickUpStation?.stationId),
                stations: destinationProvince.pickingUpStations,
              ),
        expectedGoingOnDate: carCustomerModel.expectedGoingOnDate,
        expectedPickingUpDate: Nullable(carCustomerModel.expectedPickingUpDate),
        note: carCustomerModel.note,
        selectedCarPriceModel: carCustomerModel.priceUnit,
        carPriceModels: carCustomerModel.carPriceModels,
        carType: carCustomerModel.compoundingType,
        numberSeat: Nullable(carCustomerModel.numberSeat?.ceil()),
        numberAvailableSeat: carCustomerModel.numberAvailableSeat?.ceil(),
        duration: carCustomerModel.duration,
        distance: carCustomerModel.distance,
        isInDay: carCustomerModel.isADayTour,
        isPickingUpFromStart: carCustomerModel.isPickingUpFromStart,
        carCustomerModelId: carCustomerModel.compoundingCarCustomerId,
        compoundingCarId: carCustomerModel.compoundingCarId,
      ),
    );

    if (carCustomerModel.distance != null &&
        carCustomerModel.compoundingType == CompoundingType.twoWay) {
      final waitingCharges =
          await _getWaitingChargeBlock(carCustomerModel.distance!);
      if (waitingCharges != null) {
        emit(state.copyWith(waitingCharges: waitingCharges));
        getIsInDay(carCustomerModel.isADayTour ?? false,
            waitingCharges: waitingCharges);
      }
    }

    if (carCustomerModel.compoundingType == CompoundingType.compounding &&
        carCustomerModel.fromPickUpStation != null &&
        carCustomerModel.toPickUpStation != null) {
      getDistanceAndCarFareTable();
    }
  }

  ProvinceModel _getProvince(int id) {
    return GetIt.I<LocationHelper>()
        .provinces
        .firstWhere((element) => element.provinceId == id);
  }

  getDistanceAndCarFareTable() async {
    List<CarPriceModel>? listCardPrices;
    DirectionModel? directionsModel;
    emitWaiting(true);
    var directionsModelResult = await placesRepository.getDirection(
      fromLat: state.pickupPoint!.coordinate!.latitude!,
      fromLong: state.pickupPoint!.coordinate!.longitude!,
      toLat: state.destinationPoint!.coordinate!.latitude!,
      toLong: state.destinationPoint!.coordinate!.longitude!,
    );
    directionsModelResult.fold(
      (failure) {
        return;
      },
      (data) {
        directionsModel = data;
      },
    );
    if (directionsModel != null) {
      var cardPrincesResult = await dataControllerRepo.getCarFareTable(
        distance: directionsModel!.getDistanceKm,
        duration: directionsModel!.getDuration,
        type: state.carType!,
        expectedGoingOnDate: state.expectedGoingOnDate!,
        expectedPickingUpDate: state.expectedPickingUpDate,
      );
      cardPrincesResult.fold(
        (failure) {
          emitError(failure);
        },
        (data) {
          listCardPrices = data;
        },
      );
    } else {
      log('emit error state cho user quay lại màn hình cũ');
    }
    emitWaiting(false);
    if (directionsModel != null && listCardPrices != null) {
      final currentPriceSelected = state.selectedCarPriceModel;
      final selectedPriceModel = listCardPrices!.firstWhereOrNull((element) =>
          element.carId == currentPriceSelected?.carId &&
          element.priceUnit == currentPriceSelected?.priceUnit);
      emit(state.copyWith(
        distance: directionsModel!.getDistanceKm,
        duration: directionsModel!.getDuration,
        carPriceModels: listCardPrices,
        selectedCarPriceModel: selectedPriceModel ?? listCardPrices!.first,
      ));
    } else {
      emitError(UnknownFailure('Google không tìm được đường đi từ hai trạm'));
    }
  }

  getWaitingBlock(WaitingChargeBlockModel waitingBlock) {
    emit(state.copyWith(
      currentWaitingBlock: Nullable(waitingBlock),
    ));
  }

  getExpectedGoingOnDate(DateTime dateTime) {
    emit(
      state.copyWith(
          expectedGoingOnDate: dateTime,
          currentWaitingBlock: Nullable(null),
          isInDay: false,
          expectedPickingUpDate: Nullable(null)),
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      getDistanceAndCarFareTable();
    });
    calculateMaxMinOfBlock(state.waitingCharges ?? []);
  }

  getExpectedPickingUpDate(DateTime? dateTime, {bool? isInDay}) {
    emit(state.copyWith(
      expectedPickingUpDate: Nullable(dateTime),
    ));
    Future.delayed(const Duration(milliseconds: 100), () {
      getDistanceAndCarFareTable();
    });
    if (isInDay != null) {
      getIsInDay(isInDay);
    }
  }

  getSelectedCarPrice(CarPriceModel carType) {
    emit(state.copyWith(
        selectedCarPriceModel: carType, numberSeat: Nullable(null)));
  }

  getNumberSeat(int? value) {
    emit(state.copyWith(numberSeat: Nullable(value)));
  }

  getPickUpPoint(
    StationModel? stationModel,
    ProvinceModel? provinceModel, {
    String? address,
    bool? isPickingUpFromStart,
  }) {
    LocationModel pickupPoint = LocationModel(
      coordinate: CoordinateModel(
        latitude: double.parse(stationModel!.latitude!),
        longitude: double.parse(stationModel.longitude!),
      ),
      province: provinceModel,
      provinceId: provinceModel?.provinceId?.ceil(),
      station: stationModel,
      stationId: stationModel.stationId?.ceil(),
      address: address,
    );
    emit(state.copyWith(
      pickupPoint: pickupPoint,
      isPickingUpFromStart: isPickingUpFromStart ?? false,
    ));
    if (state.destinationPoint?.stationId != null) {
      getDistanceAndCarFareTable();
    }
  }

  getIsPickUpFromStart(bool value) {
    emit(state.copyWith(isPickingUpFromStart: value));
  }

  getPickUpAddress(String? address) {
    LocationModel model =
        state.pickupPoint!.copyWith(address: Nullable(address));
    emit(state.copyWith(pickupPoint: model));
  }

  getIsInDay(bool value, {List<WaitingChargeBlockModel>? waitingCharges}) {
    final currentWaitingBlock = (waitingCharges ?? state.waitingCharges)
        ?.where((element) => checkBlockValid(element))
        .firstOrNull;
    emit(state.copyWith(
      isInDay: value,
      currentWaitingBlock: Nullable(currentWaitingBlock),
    ));
  }

  getNotes(String? text) {
    emit(state.copyWith(note: text));
  }

  getDestinationPoint(
      StationModel? stationModel, ProvinceModel? provinceModel) {
    LocationModel destinationPoint = LocationModel(
      coordinate: CoordinateModel(
        latitude: double.parse(stationModel!.latitude!),
        longitude: double.parse(stationModel.longitude!),
      ),
      province: provinceModel,
      provinceId: provinceModel?.provinceId?.ceil(),
      station: stationModel,
      stationId: stationModel.stationId?.ceil(),
    );
    emit(state.copyWith(destinationPoint: destinationPoint));
    if (state.pickupPoint?.stationId != null) {
      getDistanceAndCarFareTable();
    }
  }

  createCompoundingCar() async {
    emitWaiting(true);
    var result = await compoundingCarCtrlRepo.createCompoundingCar(
      type: state.carType!,
      from: state.pickupPoint!,
      to: state.destinationPoint!,
      expectedGoingOnDate: state.expectedGoingOnDate!,
      isADayTour: state.isInDay,
      isPickingUpFromStart: state.isPickingUpFromStart,
      expectedPickingUpDate: state.expectedPickingUpDate,
      numberSeat: state.numberSeat,
      carId: state.selectedCarPriceModel!.carId!.carId!.ceil(),
      distance: state.distance!,
      duration: state.duration!,
      note: state.note,
      waitingChargeId: state.carType == CompoundingType.twoWay
          ? state.currentWaitingBlock?.blockId
          : null,
    );
    emitWaiting(false);
    return result.fold(
      (failure) {
        emitError(failure);
      },
      (data) {
        emit(state.copyWith(
          carCustomerModelId: data.compoundingCarCustomerId,
          compoundingCarId: data.compoundingCarId,
          carCustomerModel: data,
        ));
      },
    );
  }

  joinCompoundingCar() async {
    emitWaiting(true);
    var result = await compoundingCarCtrlRepo.createCompoundingCarCustomer(
      compoundingCarId: state.compoundingCarId!,
      type: state.carType!,
      from: state.pickupPoint!,
      to: state.destinationPoint!,
      distance: state.distance!,
      numberSeat: state.numberSeat,
      expectedGoingOnDate: state.expectedGoingOnDate!,
      carId: state.selectedCarPriceModel!.carId!.carId!.ceil(),
      isPickingUpFromStart: state.isPickingUpFromStart,
      duration: state.duration,
      note: state.note,
    );
    emitWaiting(false);
    return result.fold(
      (failure) {
        emitError(failure);
      },
      (data) {
        emit(state.copyWith(
          carCustomerModelId: data.compoundingCarCustomerId,
          compoundingCarId: data.compoundingCarId,
          carCustomerModel: data,
        ));
      },
    );
  }

  updateCompoundingCar() async {
    emitWaiting(true);
    var result = await compoundingCarCtrlRepo.updateCompoundingCar(
      state.carCustomerModelId!,
      type: state.carType!,
      from: state.pickupPoint!,
      to: state.destinationPoint!,
      expectedGoingOnDate: state.expectedGoingOnDate!,
      isADayTour: state.isInDay,
      isPickingUpFromStart: state.isPickingUpFromStart,
      expectedPickingUpDate: state.expectedPickingUpDate,
      numberSeat: state.numberSeat,
      carId: state.selectedCarPriceModel!.carId!.carId!.ceil(),
      distance: state.distance!,
      duration: state.duration!,
      note: state.note,
      waitingChargeId: state.carType == CompoundingType.twoWay
          ? state.currentWaitingBlock?.blockId
          : null,
    );
    emitWaiting(false);
    return result.fold(
      (failure) {
        emitError(failure);
      },
      (data) {
        emit(state.copyWith(
          carCustomerModelId: data.compoundingCarCustomerId,
          compoundingCarId: data.compoundingCarId,
          carCustomerModel: data,
        ));
      },
    );
  }

  Future<List<WaitingChargeBlockModel>?> _getWaitingChargeBlock(
      num distance) async {
    var result = await compoundingCarCtrlRepo.getWaitingChargeBlock(distance);
    return result.fold(
      (failure) {
        emitError(failure);
        return null;
      },
      (data) {
        final blocks = data
          ..sort((a, b) => a.maxDuration!.compareTo(b.maxDuration!));
        blocks.lastOrNull?.priority = true;
        calculateMaxMinOfBlock(blocks);
        return blocks;
      },
    );
  }

  calculateMaxMinOfBlock(List<WaitingChargeBlockModel> blocks) {
    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final maxMilliseconds =
          block.endBlockTime(state.expectedGoingOnDate!.time.inMilliseconds) -
              (state.duration ?? 0).hourToMilliseconds;

      block.maxDate = block.priority == true
          ? null
          : state.expectedGoingOnDate!.date
              .add(Duration(milliseconds: maxMilliseconds));

      if (i > 0) {
        final minMilliseconds =
            max(state.duration!, blocks[i - 1].numberHour! - state.duration!)
                .hourToMilliseconds;

        block.minDate = state.expectedGoingOnDate!
            .add(Duration(milliseconds: minMilliseconds));
      } else {
        block.minDate = state.expectedGoingOnDate!
            .add(Duration(milliseconds: state.duration!.hourToMilliseconds));
      }
    }
  }

  bool checkBlockValid(WaitingChargeBlockModel item) {
    final rideDuration = (state.duration ?? 0).hourToMilliseconds;
    final timeInDay = state.expectedGoingOnDate!
        .difference(DateUtils.dateOnly(state.expectedGoingOnDate!))
        .inMilliseconds;

    final isEnable =
        (item.endBlockTime(timeInDay) - 2 * rideDuration > timeInDay) &&
                (state.distance ?? 0) <= (item.maxDistance ?? 0) &&
                (state.duration ?? 0) <= (item.maxDuration ?? 0) ||
            item.priority == true;
    return isEnable;
  }
}
