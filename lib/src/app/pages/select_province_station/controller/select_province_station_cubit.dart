import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';

part 'select_province_station_state.dart';

class SelectProvinceStationCubit extends Cubit<SelectProvinceStationState> {
  SelectProvinceStationCubit() : super(const SelectProvinceStationState());


  changeProvince(ProvinceModel provinceModel) {
    emit(state.copyWith(
        selectedProvince: Nullable(provinceModel),
        stations: provinceModel.pickingUpStations));
  }

  changeStation(StationModel stationModel) {
    emit(state.copyWith(selectedStation: Nullable(stationModel)));
  }

  clearSelection() {
    emit(
      state.copyWith(
        selectedProvince: Nullable(null),
        selectedStation: Nullable(null),
      ),
    );
  }
}
