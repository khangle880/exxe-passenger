// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_login_bloc.dart';

abstract class AuthLoginEvent extends Equatable {
  const AuthLoginEvent();

  @override
  List<Object> get props => [];
}

class ChangedPhoneLoginEvent extends AuthLoginEvent {
  final String phone;
  final MethodLogin? method;

  const ChangedPhoneLoginEvent({required this.phone, this.method});
}

class ChangedPasswordLoginEvent extends AuthLoginEvent {
  final String password;

  const ChangedPasswordLoginEvent({required this.password});
}

class CheckPhoneHasRegister extends AuthLoginEvent {
  const CheckPhoneHasRegister();
}

class ResetPhoneEvent extends AuthLoginEvent {
  const ResetPhoneEvent();
}

class ResetPasswordEvent extends AuthLoginEvent {
  final TokenModel token;

  const ResetPasswordEvent({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}

class ResetAllEvent extends AuthLoginEvent {}

class SubmitFormPhonePasswordEvent extends AuthLoginEvent {}

class SubmitFormOTPEvent extends AuthLoginEvent {
  final String accessToken;

  @override
  List<Object> get props => [accessToken];

  const SubmitFormOTPEvent(this.accessToken);
}

class LoginEvent extends AuthLoginEvent {}

class UpdateStatusEvent extends AuthLoginEvent {
  final FormLoginStatus status;

  const UpdateStatusEvent(this.status);
}

class CheckHasPassEvent extends AuthLoginEvent {}
