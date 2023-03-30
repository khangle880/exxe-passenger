part of 'join_convenient_trip_cubit.dart';

class JoinConvenientTripState extends Equatable {
  final LocationModel? pickupPoint;
  final LocationModel? destinationPoint;
  final DateTime? dateTime;
  final CompoundingType? carType;
  final PickerDateRange? filterRange;
  final CarModel? filterCarType;
  final CarBrandModel? filterCarBrand;

  const JoinConvenientTripState({
    this.pickupPoint,
    this.destinationPoint,
    this.dateTime,
    this.carType,
    this.filterRange,
    this.filterCarType,
    this.filterCarBrand,
  });

  JoinConvenientTripState copyWith({
    LocationModel? pickupPoint,
    LocationModel? destinationPoint,
    DateTime? dateTime,
    CompoundingType? carType,
    Nullable<PickerDateRange>? filterRange,
    Nullable<CarModel>? filterCarType,
    Nullable<CarBrandModel>? filterCarBrand,
  }) {
    return JoinConvenientTripState(
      pickupPoint: pickupPoint ?? this.pickupPoint,
      destinationPoint: destinationPoint ?? this.destinationPoint,
      dateTime: dateTime ?? this.dateTime,
      carType: carType ?? this.carType,
      filterRange: filterRange == null ? this.filterRange : filterRange.value,
      filterCarType:
          filterCarType == null ? this.filterCarType : filterCarType.value,
      filterCarBrand:
          filterCarBrand == null ? this.filterCarBrand : filterCarBrand.value,
    );
  }

  @override
  List<Object?> get props => [
        pickupPoint,
        destinationPoint,
        dateTime,
        carType,
        filterRange,
        filterCarType,
        filterCarBrand,
      ];
}
