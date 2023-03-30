import 'package:equatable/equatable.dart';

import '../../../../utils/export/logic_export.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends BaseCubit<ChangePasswordState> {
  ChangePasswordCubit(this.repo,
      {ChangePassState? state, String? stringeeToken})
      : super(ChangePasswordState(
          state: stringeeToken != null
              ? ChangePassState.reset
              : ChangePassState.checking,
          stringeeToken: stringeeToken,
        ));
  final IUserRepo repo;

  checkHasPassword() async {
    if (state.stringeeToken != null) return;
    final result = await repo.checkHasPassword();
    result.fold((failure) {
      log(failure.toString());
      emitError(failure);
    }, (hasPass) {
      if (hasPass) {
        emit(state.copyWith(state: ChangePassState.update));
      } else {
        emit(state.copyWith(state: ChangePassState.create));
      }
    });
  }

  createPassword() async {
    emitWaiting(true);
    final result =
        await repo.createNewPassword(state.newPass!, state.rePassword!);
    emitWaiting(false);
    result.fold((failure) {
      log(failure.toString());
      emitError(failure);
    }, (data) {
      emit(state.copyWith(state: ChangePassState.changed));
    });
  }

  changePassword() async {
    emitWaiting(true);
    final result = await repo.changePassword(
        old: state.oldPass!,
        newPass: state.newPass!,
        rePass: state.rePassword!);

    emitWaiting(false);
    result.fold((failure) {
      log(failure.toString());
      emitError(failure);
    }, (data) {
      emit(state.copyWith(state: ChangePassState.changed));
    });
  }

  resetPassword() async {
    emitWaiting(true);
    final result = await repo.resetPassword(
      stringeeToken: state.stringeeToken!,
      newPass: state.newPass!,
      rePass: state.rePassword!,
    );
    emitWaiting(false);
    result.fold((failure) {
      log(failure.toString());
      emitError(failure);
    }, (data) {
      emit(state.copyWith(state: ChangePassState.changed, newToken: data));
    });
  }

  updateFormField({
    String? oldPass,
    String? newPass,
    String? rePassword,
    String? stringeeToken,
  }) {
    emit(
      state.copyWith(
        oldPass: oldPass,
        newPass: newPass,
        rePassword: rePassword,
        stringeeToken: stringeeToken,
      ),
    );
  }

  changeState(ChangePassState changePassState) {
    emit(state.copyWith(
        oldPass: "", newPass: "", rePassword: "", state: changePassState));
  }
}
