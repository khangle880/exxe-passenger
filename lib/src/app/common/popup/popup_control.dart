import 'package:exxe/src/utils/export/ui_export.dart';

class PopupControl {
  static PopupControl instance = PopupControl();

  static PopupControl get I => instance;

  showPopup(BuildContext context, Widget child) async {
    await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.2,
            end: 1.0,
          ).animate(
            CurvedAnimation(parent: a1, curve: Curves.linearToEaseOut),
          ),
          child: Opacity(
            opacity: a1.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 100),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return _buildDialog(
          child,
        );
      },
    );
  }

  Widget _buildDialog(Widget child) {
    return Dialog(
      elevation: 0.5,
      backgroundColor: AppColors.primaryLight,
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: child,
    );
  }
}
