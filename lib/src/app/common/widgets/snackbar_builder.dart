import '../../../utils/export/ui_export.dart';

class SnackBarBuilder extends SnackBar {
  SnackBarBuilder.success({Key? key, required String title})
      : super(
          key: key,
          content: Row(
            children: [
              SvgPicture.asset(AppIcons.doubleCheck),
              const SizedBox(width: 4),
              Text(
                title,
                style: AppStyles.s12w4.withColor(AppColors.green60),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          backgroundColor: AppColors.green05,
        );
}
