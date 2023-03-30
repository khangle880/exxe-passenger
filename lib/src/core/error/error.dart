// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../app/app_state.dart';
import '../../app/common/common.dart';

abstract class Failure extends Equatable {
  final Exception? exception;

  showDefaultDialog();

  Failure({this.exception});

  @override
  List<Object?> get props => [exception];
}

// General failures
class ServerFailure extends Failure {
  final String serverMessage;

  ServerFailure(this.serverMessage, {Exception? exception})
      : super(exception: exception) {
    if (serverMessage == "Token không có hiệu lực!") {
      GetIt.I<AppState>().createAction(ActionStateEnum.invalidToken);
    }
  }

  @override
  String toString() {
    return serverMessage;
  }

  @override
  showDefaultDialog() {
    if (serverMessage != "Token không có hiệu lực!") {
      AppDialog.I.showError(message: serverMessage);
    }
  }
}

// General failures
class WarningFailure extends Failure {
  final String serverMessage;

  WarningFailure(this.serverMessage, {Exception? exception})
      : super(exception: exception);

  @override
  String toString() {
    return serverMessage;
  }

  @override
  showDefaultDialog() {
    AppDialog.I.showWarning(message: serverMessage);
  }
}

class CacheFailure extends Failure {
  CacheFailure({Exception? exception}) : super(exception: exception);

  @override
  showDefaultDialog() {}
}

class UnknownFailure extends Failure {
  final String errorMessage;

  UnknownFailure(this.errorMessage, {Exception? exception})
      : super(exception: exception);

  @override
  showDefaultDialog() {
    AppDialog.I.showError(message: "Đã có lỗi, vui lòng thử lại sau");
  }

  @override
  String toString() {
    return errorMessage;
  }
}
