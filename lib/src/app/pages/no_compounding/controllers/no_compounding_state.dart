// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'no_compounding_bloc.dart';

class NoCompoundingState extends Equatable {
  final CarPriceModel? currentCarPrice;
  final List<CarPriceModel>? carPriceModels;
  final LocationModel? pickupPoint;
  final LocationModel? destinationPoint;
  final DateTime expectedGoingOnDate;
  final DirectionModel? directionsModel;
  final List<CompoundingCarModel>? carModels;

  @override
  List<Object?> get props => [
        currentCarPrice,
        carPriceModels,
        pickupPoint,
        destinationPoint,
        expectedGoingOnDate,
        directionsModel,
        carModels,
      ];

  const NoCompoundingState({
    this.currentCarPrice,
    this.carPriceModels,
    this.pickupPoint,
    this.destinationPoint,
    required this.expectedGoingOnDate,
    this.directionsModel,
    this.carModels,
  });

  NoCompoundingState copyWith({
    Nullable<CarPriceModel>? currentCarPrice,
    List<CarPriceModel>? carPriceModels,
    LocationModel? pickupPoint,
    LocationModel? destinationPoint,
    DateTime? expectedGoingOnDate,
    DirectionModel? directionsModel,
    List<CompoundingCarModel>? carModels,
  }) {
    return NoCompoundingState(
      currentCarPrice: currentCarPrice != null
          ? currentCarPrice.value
          : this.currentCarPrice,
      carPriceModels: carPriceModels ?? this.carPriceModels,
      pickupPoint: pickupPoint ?? this.pickupPoint,
      destinationPoint: destinationPoint ?? this.destinationPoint,
      expectedGoingOnDate: expectedGoingOnDate ?? this.expectedGoingOnDate,
      directionsModel: directionsModel ?? this.directionsModel,
      carModels: carModels ?? this.carModels,
    );
  }
}
