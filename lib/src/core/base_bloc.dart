import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/export/repo_export.dart';

abstract class BaseController<T> {
  final BehaviorSubject<bool> _loadingController =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<bool> _waitingController =
      BehaviorSubject<bool>.seeded(false);
  final BehaviorSubject<Failure> _errorController = BehaviorSubject<Failure>();

  Stream<bool> get loadingStream => _loadingController.stream;

  Stream<bool> get waitingStream => _waitingController.stream;

  Stream<Failure> get errorStream => _errorController.stream;

  @mustCallSuper
  void dispose() async {
    await _loadingController.drain();
    await _waitingController.drain();
    await _errorController.drain();
    _loadingController.close();
    _waitingController.close();
    _errorController.close();
  }

  void emitLoading(bool loading) {
    if (_loadingController.isClosed) return;
    _loadingController.sink.add(loading);
  }

  void emitWaiting(bool waiting) {
    if (_waitingController.isClosed) return;
    _waitingController.sink.add(waiting);
  }

  void emitError(Failure failure) {
    log(failure.toString());
    if (_errorController.isClosed) return;
    _errorController.sink.add(failure);
  }
}

abstract class BaseCubit<T> extends Cubit<T> with BaseController<T> {
  BaseCubit(super.initialState);
}

abstract class BaseBloc<E, T> extends Bloc<E, T> with BaseController<T> {
  BaseBloc(super.initialState);
}
