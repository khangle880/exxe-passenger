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
    this.methodLogin = MethodLogin.checkPhone,
  });

  final String phone;
  final String password;
  final FormLoginStatus formState;
  final MethodLogin methodLogin;
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
        message,
        methodLogin,
      ];

  AuthLoginState copyWith({
    String? phone,
    String? password,
    FormLoginStatus? formState,
    String? smsCode,
    String? verificationId,
    int? resendToken,
    String? message,
    MethodLogin? methodLogin,
  }) {
    return AuthLoginState(
      phone: phone ?? this.phone,
      password: password ?? this.password,
      formState: formState ?? this.formState,
      smsCode: smsCode ?? this.smsCode,
      verificationId: verificationId ?? this.verificationId,
      resendToken: resendToken ?? this.resendToken,
      message: message ?? this.message,
      methodLogin: methodLogin ?? this.methodLogin,
    );
  }
}

enum FormLoginStatus {
  none,
  success,
  notCompatible,
  needPassword,
  needRegister,
  needVerify,
}
