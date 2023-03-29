// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_login_bloc.dart';

class AuthLoginState extends Equatable {
  const AuthLoginState({
    this.phone = '',
    this.password = '',
    this.formState = FormLoginStatus.none,
    this.smsCode = '',
    this.verificationId = '',
    this.resendToken = 0,
    this.message = '',
  });

  final String phone;
  final String password;
  final FormLoginStatus formState;

  //field  otp
  final String? smsCode;
  final String? verificationId;
  final int? resendToken;

  final String message;

  @override
  List<Object> get props => [
        phone,
        password,
        formState,
        smsCode!,
        verificationId!,
        resendToken!,
        message
      ];

  AuthLoginState copyWith(
      {String? phone,
      String? password,
      FormLoginStatus? formState,
      String? smsCode,
      String? verificationId,
      int? resendToken,
      String? message}) {
    return AuthLoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      formState: formState ?? this.formState,
      smsCode: smsCode ?? this.smsCode,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
      message: message ?? this.message,
    );
  }
}

enum FormLoginStatus {
  none,
  submitting,
  failed,
  success,
  notCompatible,
  needPassword,
  needRegister,
  needVerify,
}
