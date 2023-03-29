import 'package:exxe/src/utils/export/ui_export.dart';

class ModalBottomSheet {
  static ModalBottomSheet instance = ModalBottomSheet();
  void show(BuildContext context, Widget child,
      {Color? backgroundColor = AppColors.primaryLight}) async {
    await showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: AppStyles.borderTop20LeftRight),
        elevation: 0.0,
        backgroundColor: backgroundColor,
        context: context,
        builder: (context) {
          return child;
        });
  }
}
