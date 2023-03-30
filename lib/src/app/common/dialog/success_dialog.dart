import '../../../utils/export/ui_export.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog(
      {Key? key,
      required this.title,
      required this.message,
      this.contentPadding,
      this.onConfirm,
      this.confirmText})
      : super(key: key);
  final String title;
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
                child: SvgPicture.asset(AppIcons.checkCircle,
                    color: AppColors.greenMain, height: 92, width: 92),
              ),
              Padding(
                padding: contentPadding ?? EdgeInsets.zero,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: AppStyles.s18w7),
                    const SizedBox(height: 4),
                    Text(message,
                        textAlign: TextAlign.center,
                        style: AppStyles.s14w4.withColor(AppColors.gray80)),
                  ],
                ),
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
