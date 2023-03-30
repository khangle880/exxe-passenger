part of 'form_register_bloc.dart';

abstract class FormRegisterEvent extends Equatable {
  const FormRegisterEvent();

  @override
  List<Object> get props => [];
}

class ChangeFullNameEvent extends FormRegisterEvent {
  final String name;

  const ChangeFullNameEvent(this.name);

  @override
  List<Object> get props => [name];
}

class ChangeGenderEvent extends FormRegisterEvent {
  final Gender gender;

  const ChangeGenderEvent(this.gender);

  @override
  List<Object> get props => [gender];
}

class ChangeBirthDateEvent extends FormRegisterEvent {
  final DateTime birthDate;

  const ChangeBirthDateEvent(this.birthDate);

  @override
  List<Object> get props => [birthDate];
}

class VerifyPhoneNumberEvent extends FormRegisterEvent {
  final bool success;

  const VerifyPhoneNumberEvent(this.success);

  @override
  List<Object> get props => [success];
}

class ChangeIdentityEvent extends FormRegisterEvent {
  final String identityNumber;

  const ChangeIdentityEvent(this.identityNumber);

  @override
  List<Object> get props => [identityNumber];
}

class ChangeEmailEvent extends FormRegisterEvent {
  final String email;

  const ChangeEmailEvent(this.email);

  @override
  List<Object> get props => [email];
}

class ChangeAddress extends FormRegisterEvent {
  final LocationModel location;

  const ChangeAddress(this.location);

  @override
  List<Object> get props => [location];
}

class CreateUserInformationEvent extends FormRegisterEvent {}

class LoadGeneralInfoEvent extends FormRegisterEvent {}
