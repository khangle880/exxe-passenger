part of 'select_province_station_cubit.dart';

class SelectProvinceStationState extends Equatable {
  final ProvinceModel? selectedProvince;
  final StationModel? selectedStation;
  final List<StationModel>? stations;

  const SelectProvinceStationState({
    this.selectedProvince,
    this.selectedStation,
    this.stations,
  });

  SelectProvinceStationState copyWith({
    Nullable<ProvinceModel>? selectedProvince,
    Nullable<StationModel>? selectedStation,
    List<StationModel>? stations,
  }) {
    return SelectProvinceStationState(
      selectedProvince: selectedProvince == null
          ? this.selectedProvince
          : selectedProvince.value,
      selectedStation: selectedStation == null
          ? this.selectedStation
          : selectedStation.value,
      stations: stations ?? this.stations,
    );
  }

  @override
  List<Object?> get props => [
        selectedProvince,
        selectedStation,
        stations,
      ];
}
