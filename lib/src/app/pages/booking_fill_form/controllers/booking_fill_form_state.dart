part of 'booking_fill_form_cubit.dart';

class BookingFillFormState extends Equatable {
  final LocationModel? pickupPoint;
  final LocationModel? destinationPoint;
  final num? distance;
  final num? duration;
  final DateTime? expectedGoingOnDate;
  final DateTime? expectedPickingUpDate;
  final List<CarPriceModel>? carPriceModels;
  final CarPriceModel? selectedCarPriceModel;
  final CompoundingType? carType;
  final int? numberSeat;
  final int? numberAvailableSeat;
  final String? note;
  final bool? isInDay;
  final bool? isPickingUpFromStart;
  final num? carCustomerModelId;
  final num? compoundingCarId;
  final List<WaitingChargeBlockModel>? waitingCharges;
  final WaitingChargeBlockModel? currentWaitingBlock;
  final CompoundingCarCustomerModel? carCustomerModel;

  const BookingFillFormState({
    this.pickupPoint,
    this.destinationPoint,
    this.distance,
    this.duration,
    this.expectedGoingOnDate,
    this.expectedPickingUpDate,
    this.carPriceModels,
    this.selectedCarPriceModel,
    this.carType,
    this.numberSeat,
    this.numberAvailableSeat,
    this.note,
    this.isInDay,
    this.isPickingUpFromStart,
    this.carCustomerModelId,
    this.compoundingCarId,
    this.waitingCharges,
    this.currentWaitingBlock,
    this.carCustomerModel,
  });

  BookingFillFormState copyWith({
    LocationModel? pickupPoint,
    LocationModel? destinationPoint,
    num? distance,
    num? duration,
    DateTime? expectedGoingOnDate,
    Nullable<DateTime>? expectedPickingUpDate,
    List<CarPriceModel>? carPriceModels,
    CarPriceModel? selectedCarPriceModel,
    CompoundingType? carType,
    Nullable<int>? numberSeat,
    int? numberAvailableSeat,
    String? note,
    bool? isInDay,
    bool? isPickingUpFromStart,
    num? carCustomerModelId,
    num? compoundingCarId,
    List<WaitingChargeBlockModel>? waitingCharges,
    Nullable<WaitingChargeBlockModel>? currentWaitingBlock,
    CompoundingCarCustomerModel? carCustomerModel,
  }) {
    return BookingFillFormState(
      pickupPoint: pickupPoint ?? this.pickupPoint,
      destinationPoint: destinationPoint ?? this.destinationPoint,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      expectedGoingOnDate: expectedGoingOnDate ?? this.expectedGoingOnDate,
      expectedPickingUpDate: expectedPickingUpDate == null
          ? this.expectedPickingUpDate
          : expectedPickingUpDate.value,
      carPriceModels: carPriceModels ?? this.carPriceModels,
      selectedCarPriceModel:
          selectedCarPriceModel ?? this.selectedCarPriceModel,
      carType: carType ?? this.carType,
      numberSeat: numberSeat == null ? this.numberSeat : numberSeat.value,
      numberAvailableSeat: numberAvailableSeat ?? this.numberAvailableSeat,
      note: note ?? this.note,
      isInDay: isInDay ?? this.isInDay,
      isPickingUpFromStart: isPickingUpFromStart ?? this.isPickingUpFromStart,
      carCustomerModelId: carCustomerModelId ?? this.carCustomerModelId,
      compoundingCarId: compoundingCarId ?? this.compoundingCarId,
      waitingCharges: waitingCharges ?? this.waitingCharges,
      currentWaitingBlock: currentWaitingBlock == null
          ? this.currentWaitingBlock
          : currentWaitingBlock.value,
      carCustomerModel: carCustomerModel ?? this.carCustomerModel,
    );
  }

  @override
  List<Object?> get props => [
        pickupPoint,
        destinationPoint,
        distance,
        duration,
        expectedGoingOnDate,
        expectedPickingUpDate,
        carPriceModels,
        selectedCarPriceModel,
        carType,
        numberSeat,
        numberAvailableSeat,
        note,
        isInDay,
        isPickingUpFromStart,
        carCustomerModelId,
        compoundingCarId,
        waitingCharges,
        currentWaitingBlock,
        carCustomerModel,
      ];
}
