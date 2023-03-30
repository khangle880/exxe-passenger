part of 'pickup_address_bloc.dart';

abstract class PickupAddressEvent extends Equatable {
  const PickupAddressEvent();

  @override
  List<Object?> get props => [];
}

class ChangeProvinceEvent extends PickupAddressEvent {
  final ProvinceModel? province;

  @override
  List<Object?> get props => [province];

  const ChangeProvinceEvent(this.province);
}

class ChangeDistrictEvent extends PickupAddressEvent {
  final DistrictModel? district;

  @override
  List<Object?> get props => [district];

  const ChangeDistrictEvent(this.district);
}

class ChangeWardEvent extends PickupAddressEvent {
  final WardModel? ward;

  @override
  List<Object?> get props => [ward];

  const ChangeWardEvent(this.ward);
}

class ChangeAddressEvent extends PickupAddressEvent {
  final String? address;

  @override
  List<Object?> get props => [address];

  const ChangeAddressEvent(this.address);
}
