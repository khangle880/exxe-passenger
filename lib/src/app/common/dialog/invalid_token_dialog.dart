import 'package:flutter/material.dart';

import 'dialog_control.dart';

class InvalidTokenDialog {
  static bool isOpen = false;

  static Future show(BuildContext context,
      {required Function() onConfirm}) async {
    if (isOpen) {
      close(context);
      return;
    }

    isOpen = true;
    AppDialog.I.showNotification(
      message: "Phiên bản hết hạn vui lòng đăng nhập lại",
      onConfirm: onConfirm,
      barrierDismissible: false,
    );
  }

  static void close(BuildContext context) {
    if (!isOpen) {
      return;
    }
    Navigator.pop(context);
    isOpen = false;
  }
}
