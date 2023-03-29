part of 'pickup_address_bloc.dart';

class PickupAddressState extends Equatable {
  final ProvinceModel? province;
  final DistrictModel? district;
  final WardModel? ward;
  final String? address;
  final List<ProvinceModel> provinces;
  final List<DistrictModel>? districts;
  final List<WardModel>? wards;

  const PickupAddressState({
    this.province,
    this.district,
    this.ward,
    required this.provinces,
    this.districts,
    this.wards,
    this.address,
  });

  @override
  List<Object?> get props => [
        province,
        district,
        ward,
        address,
        provinces,
        districts,
        wards,
      ];

  PickupAddressState copyWith({
    Nullable<ProvinceModel>? province,
    Nullable<DistrictModel>? district,
    Nullable<WardModel>? ward,
    Nullable<String>? address,
    Nullable<List<DistrictModel>>? districts,
    Nullable<List<WardModel>>? wards,
  }) {
    return PickupAddressState(
      province: province == null ? this.province : province.value,
      district: district == null ? this.district : district.value,
      ward: ward == null ? this.ward : ward.value,
      address: address == null ? this.address : address.value,
      provinces: provinces,
      districts: districts == null ? this.districts : districts.value,
      wards: wards == null ? this.wards : wards.value,
    );
  }
}

