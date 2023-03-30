import 'package:exxe/src/utils/export/ui_export.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  const ConfirmLogoutDialog({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
    this.onEnd,
  }) : super(key: key);
  final Function() onCancel;
  final Function() onConfirm;
  final Function()? onEnd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        width: 344,
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppIcons.outlineCar,
                color: AppColors.primaryMain,
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 16),
              Text("Bạn có chắc muốn đăng xuất?", style: AppStyles.s18w7),
              const SizedBox(height: 4),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidgetOld(
                      onClick: onCancel,
                      radius: 12,
                      backgroundColor: AppColors.primaryMain +
                          AppColors.primaryLight.withOpacity(0.95),
                      child: Text(
                        "Huỷ",
                        style: AppStyles.s14w6.withColor(AppColors.primaryMain),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                 child: ButtonWidgetOld(
                   onClick: onConfirm,
                   radius: 12,
                   backgroundColor: AppColors.primaryMain,
                   child: Text(
                     "Đăng xuất",
                     style: AppStyles.s14w6.withColor(AppColors.primaryLight),
                   ),
                 ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
