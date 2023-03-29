import '../../../utils/export/ui_export.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog(
      {Key? key,
      required this.message,
      this.contentPadding,
      this.onConfirm,
      this.confirmText})
      : super(key: key);
  final String message;
  final EdgeInsets? contentPadding;
  final Function()? onConfirm;
  final String? confirmText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 2),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    AppIcons.carOutline,
                    color: AppColors.primaryMain,
                    width: 52,
                    height: 52,
                  )),
              Padding(
                padding: contentPadding ?? EdgeInsets.zero,
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: AppStyles.s14w4.withColor(AppColors.gray80)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.maxFinite,
                child: ButtonWidget(
                    onClick: onConfirm ??
                        () {
                          Navigator.pop(context);
                        },
                    radius: 12,
                    child: Text(
                      confirmText ?? "OK",
                      style: AppStyles.s16w6.withColor(AppColors.primaryLight),
                    )),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
