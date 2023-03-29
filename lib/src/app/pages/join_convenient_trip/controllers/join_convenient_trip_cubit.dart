import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../data/data.dart';
import '../../../../utils/constants/constants.dart';

part 'join_convenient_trip_state.dart';

class JoinConvenientTripCubit extends Cubit<JoinConvenientTripState> {
  JoinConvenientTripCubit() : super(const JoinConvenientTripState());

  getFromProvince(LocationModel locationModel) {
    emit(state.copyWith(pickupPoint: locationModel));
  }

  getToProvince(LocationModel locationModel) {
    emit(state.copyWith(destinationPoint: locationModel));
  }

  getDateTime(DateTime dateTime) {
    emit(state.copyWith(dateTime: dateTime));
  }

  getCompoundingType(CompoundingType carType) {
    emit(state.copyWith(carType: carType));
  }

  updateFilter({
    PickerDateRange? range,
    CarModel? carType,
    CarBrandModel? carBrand,
  }) {
    emit(state.copyWith(
      filterRange: Nullable(range),
      filterCarType: Nullable(carType),
      filterCarBrand: Nullable(carBrand),
    ));
  }
}
