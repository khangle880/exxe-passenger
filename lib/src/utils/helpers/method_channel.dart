import 'package:flutter/services.dart';

class AppMethodChannel {
  static const vnPayChannel = MethodChannel('passenger/vn_pay');

  static AppMethodChannel instance = AppMethodChannel();

  static AppMethodChannel get I => instance;

  void openVnpaySdk(String returnUrl) {
    vnPayChannel.invokeMethod(
      'open_sdk',
      {
        "url": returnUrl,
      },
    );
  }
}
