part of 'change_password_cubit.dart';

enum ChangePassState {
  checking,
  create,
  update,
  reset,
  changed,
}

class ChangePasswordState extends Equatable {
  final String? oldPass;
  final String? newPass;
  final String? rePassword;
  final String? stringeeToken;
  final TokenModel? newToken;
  final ChangePassState state;

  const ChangePasswordState({
    this.oldPass,
    this.newPass,
    this.newToken,
    this.rePassword,
    this.stringeeToken,
    this.state = ChangePassState.checking,
  });

  ChangePasswordState copyWith({
    String? oldPass,
    String? newPass,
    String? rePassword,
    TokenModel? newToken,
    String? stringeeToken,
    ChangePassState? state,
  }) {
    return ChangePasswordState(
      oldPass: oldPass ?? this.oldPass,
      newPass: newPass ?? this.newPass,
      rePassword: rePassword ?? this.rePassword,
      newToken: newToken ?? this.newToken,
      stringeeToken: stringeeToken ?? this.stringeeToken,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [
        oldPass,
        newPass,
        rePassword,
        stringeeToken,
        newToken,
        state,
      ];
}
