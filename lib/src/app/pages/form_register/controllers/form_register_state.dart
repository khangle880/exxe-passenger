part of 'form_register_bloc.dart';

class FormRegisterState extends Equatable {
  final String? name;
  final Gender? gender;
  final DateTime? birthDate;
  final bool phoneConfirmed;
  final String? identityNumber;
  final String? email;
  final LocationModel? location;
  final PartnerModel? userInfo;
  final CallDataApiType type;

  const FormRegisterState({
    this.name,
    this.gender,
    this.birthDate,
    this.phoneConfirmed = false,
    this.identityNumber,
    this.email,
    this.location,
    this.userInfo,
    this.type = CallDataApiType.create,
  });

  @override
  List<Object?> get props => [
        name,
        gender,
        birthDate,
        phoneConfirmed,
        identityNumber,
        email,
        location,
        userInfo,
        type,
      ];

  FormRegisterState copyWith({
    String? name,
    Gender? gender,
    DateTime? birthDate,
    bool? phoneConfirmed,
    String? identityNumber,
    String? email,
    LocationModel? location,
    PartnerModel? userInfo,
    CallDataApiType? type,
  }) {
    return FormRegisterState(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phoneConfirmed: phoneConfirmed ?? this.phoneConfirmed,
      identityNumber: identityNumber ?? this.identityNumber,
      email: email ?? this.email,
      location: location ?? this.location,
      userInfo: userInfo ?? this.userInfo,
      type: type ?? this.type,
    );
  }
}
