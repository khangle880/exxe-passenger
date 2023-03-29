import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

class ThrottleHelper {
  late final PublishSubject<Function()> throttler;

  ThrottleHelper() {
    throttler = PublishSubject<Function()>();
  }

  Function() throttle(int throttleDurationInMillis, Function() function) {
    throttler
        .throttleTime(Duration(milliseconds: throttleDurationInMillis))
        .forEach(
      (f) {
        f();
      },
    );

    return () {
      if (!throttler.isClosed) {
        throttler.add(function);
      }
    };
  }

  dispose() {
    throttler.close();
  }
}

class DebounceHelper {
  final int milliseconds;
  Timer? timer;

  DebounceHelper({required this.milliseconds});

  run(VoidCallback action) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
