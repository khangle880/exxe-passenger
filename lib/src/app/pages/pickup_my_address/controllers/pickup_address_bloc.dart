import 'package:equatable/equatable.dart';

import '../../../../utils/export/logic_export.dart';

part 'pickup_address_event.dart';

part 'pickup_address_state.dart';

class PickupAddressBloc
    extends BaseBloc<PickupAddressEvent, PickupAddressState> {
  final IDataControllerRepo repo;

  PickupAddressBloc(this.repo)
      : super(PickupAddressState(
            provinces: GetIt.I<LocationHelper>().provinces)) {
    on<ChangeProvinceEvent>((event, emit) async {
      emit(
        state.copyWith(
            province: Nullable(event.province),
            district: Nullable(null),
            ward: Nullable(null),
            address: Nullable(null),
            districts: Nullable(null),
            wards: Nullable(null)),
      );
      if (event.province != null) {
        final result =
            await repo.getListDistrict([event.province!.provinceId!]);
        result.fold((failure) => log(failure.toString()), (data) {
          emit(state.copyWith(districts: Nullable(data)));
        });
      }
    });
    on<ChangeDistrictEvent>((event, emit) async {
      emit(
        state.copyWith(
            district: Nullable(event.district),
            ward: Nullable(null),
            address: Nullable(null),
            wards: Nullable(null)),
      );
      if (event.district != null) {
        final result = await repo.getListWard([event.district!.districtId!]);
        result.fold((failure) => log(failure.toString()), (data) {
          emit(state.copyWith(wards: Nullable(data)));
        });
      }
    });
    on<ChangeWardEvent>((event, emit) {
      emit(state.copyWith(
        ward: Nullable(event.ward),
        address: Nullable(null),
      ));
    });
    on<ChangeAddressEvent>((event, emit) {
      emit(state.copyWith(address: Nullable(event.address)));
    });
  }
}
