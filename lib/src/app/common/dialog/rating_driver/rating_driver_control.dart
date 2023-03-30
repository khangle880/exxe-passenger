import 'package:exxe/src/utils/export/ui_export.dart';

class DialogRatingDriver {
  static DialogRatingDriver instance = DialogRatingDriver();

  void showDialogRatingLess(BuildContext context) async {
    await showGeneralDialog(
      transitionBuilder: (context, a1, a2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: const Offset(0, 0.0),
          ).animate(
            CurvedAnimation(parent: a1, curve: Curves.linearToEaseOut),
          ),
          child: Opacity(
            opacity: a1.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return CustomDialogConfirmWidget(
          title: 'Đánh giá thành công',
          onConfirm: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home));
          },
          subTitle:
              'Cảm ơn đánh giá của bạn và mong được đồng hành cùng những chuyến đi tiếp theo!',
          imageUrl: 'assets/images/rating_driver/star_less_then_4.jpg',
          confirm: 'Hoàn tất',
        );
      },
    );
  }

  void showDialogRatingBigger(BuildContext context) async {
    await showGeneralDialog(
      transitionBuilder: (context, a1, a2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: const Offset(0, 0.0),
          ).animate(
            CurvedAnimation(parent: a1, curve: Curves.linearToEaseOut),
          ),
          child: Opacity(
            opacity: a1.value,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return CustomDialogConfirmWidget(
          title: 'Đánh giá thành công',
          onConfirm: () {
            Navigator.popUntil(context, ModalRoute.withName(Routes.home));
          },
          subTitle:
              'Cảm ơn đánh giá của bạn và mong được đồng hành cùng những chuyến đi tiếp theo!',
          imageUrl: 'assets/images/rating_driver/star_5.jpg',
          confirm: 'Hoàn tất',
        );
      },
    );
  }
}
