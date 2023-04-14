import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';
import 'check_password_dialog.dart';
import 'ride_payment_dialog.dart';

class AppDialog {
  static AppDialog instance = AppDialog();

  static AppDialog get I => instance;

  void showLoadingLocation({required String msg}) {
    SmartDialog.show(
      clickMaskDismiss: false,
      backDismiss: false,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 4),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                msg,
                style: AppStyles.s16w6,
                textAlign: TextAlign.center,
              )
            ],
          ),
        );
      },
    );
  }

  void showToast(String msg) {
    SmartDialog.showToast(msg);
  }

  void showLoading() {
    SmartDialog.show(
      backDismiss: false,
      clickMaskDismiss: false,
      builder: (_) => Dialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: const SizedBox().appCenterProgressLoading,
      ),
    );
  }

  void closeDialog() {
    SmartDialog.dismiss();
  }

  void showWarning({
    required String message,
    bool? barrierDismissible,
    Function()? onCancel,
    Function()? onConfirm,
    String? cancelTitle,
    String? confirmTitle,
    bool hasCancel = false,
  }) {
    showCustomDialog(
        barrierDismissible: barrierDismissible,
        content: WarningDialog(
          onConfirm: onConfirm ?? closeDialog,
          onCancel: onCancel ?? closeDialog,
          confirmTitle: confirmTitle,
          cancelTitle: cancelTitle,
          message: message,
          hasCancel: hasCancel,
        ));
  }

  void showError({
    required String message,
    Function()? onConfirm,
    String? title,
    String? buttonTitle,
    bool? barrierDismissible,
  }) {
    final content = ErrorDialog(
      title: title,
      buttonTitle: buttonTitle,
      message: message,
      onConfirm: onConfirm ?? closeDialog,
    );
    showCustomDialog(content: content, barrierDismissible: barrierDismissible);
  }

  void showCancelDeposit({
    bool? barrierDismissible,
    Function()? onConfirm,
    Function()? onCancel,
    Function()? onDepositReturnedEnd,

    /// milliseconds
    int? countdownNumber,
    required bool canReturned,
  }) {
    final content = CancelDepositDialog(
      onCancel: onCancel ?? closeDialog,
      onConfirm: onConfirm ?? closeDialog,
      canReturned: canReturned,
      countdownNumber: countdownNumber,
      onDepositReturnedEnd: onDepositReturnedEnd,
    );
    showCustomDialog(content: content);
  }

  void showConfirmLogOutDialog({
    Function()? onConfirm,
    Function()? onCancel,
  }) {
    final content = ConfirmLogoutDialog(
        onCancel: onCancel ?? closeDialog, onConfirm: onConfirm ?? closeDialog);
    showCustomDialog(content: content);
  }

  void showSuccess({
    bool? barrierDismissible,
    required final String title,
    required final String message,
    required Function()? onConfirm,
    EdgeInsets? contentPadding,
    String? confirmText,
  }) {
    final content = SuccessDialog(
      onConfirm: onConfirm ?? closeDialog,
      title: title,
      contentPadding: contentPadding,
      message: message,
    );
    showCustomDialog(content: content, barrierDismissible: barrierDismissible);
  }

  void showCancelReasonSuccess({
    bool? barrierDismissible,
    required Function()? onConfirm,
  }) {
    final content = CancelReasonDialog(onConfirm: onConfirm ?? closeDialog);
    showCustomDialog(content: content, barrierDismissible: barrierDismissible);
  }

  void showNotification({
    bool? barrierDismissible,
    required final String message,
    Function()? onConfirm,
    EdgeInsets? contentPadding,
    String? confirmText,
  }) {
    final content = NotificationDialog(
      onConfirm: onConfirm ?? closeDialog,
      contentPadding: contentPadding,
      message: message,
    );
    showCustomDialog(content: content, barrierDismissible: barrierDismissible);
  }

  void showCustomDialog({
    bool? barrierDismissible,
    required Widget content,
  }) {
    SmartDialog.show(
      clickMaskDismiss: barrierDismissible,
      backDismiss: barrierDismissible,
      builder: (context) {
        return content;
      },
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void showCheckPasswordDialog({
    bool? barrierDismissible,
    required Function() onConfirm,
  }) {
    final content = CheckPasswordDialog(onConfirm: onConfirm);
    showCustomDialog(content: content, barrierDismissible: barrierDismissible);
  }

  void showNeedPaymentDialog({
    required List<CompoundingCarCustomerModel> customerCars,
    bool? barrierDismissible,
    Function()? onConfirm,
    String? confirmTitle,
    Widget? icon,
    required BuildContext rootContext,
  }) {
    final content = RideNeedPaymentDialog(
      compoundingCustomerCars: customerCars,
      onConfirm: onConfirm ?? closeDialog,
      rootContext: rootContext,
    );
    showCustomDialog(content: content, barrierDismissible: barrierDismissible);
  }
}
