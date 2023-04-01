import '../../../utils/export/ui_export.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog(
      {Key? key,
      this.onConfirm,
      required this.onCancel,
      this.cancelTitle,
      this.confirmTitle,
      required this.message,
      this.hasCancel = false})
      : super(key: key);
  final Function()? onConfirm;
  final bool hasCancel;
  final Function()? onCancel;
  final String? cancelTitle;
  final String? confirmTitle;
  final String message;

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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text("Cảnh báo",
                  style: AppStyles.s18w6.withColor(AppColors.orangeMain)),
              const SizedBox(height: 12),
              Text(
                message,
                style: AppStyles.s16w6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (hasCancel) ...[
                    Expanded(
                      child: ButtonWidget(
                        onClick: onCancel ??
                            () {
                              Navigator.pop(context);
                            },
                        radius: 12,
                        backgroundColor: AppColors.primaryMain +
                            AppColors.primaryLight.withOpacity(0.95),
                        child: Text(
                          cancelTitle ?? "Hủy",
                          style:
                              AppStyles.s16w6.withColor(AppColors.primaryMain),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: ButtonWidget(
                      onClick: onConfirm ??
                          () {
                            Navigator.pop(context);
                          },
                      radius: 12,
                      backgroundColor: AppColors.primaryMain,
                      child: Text(
                        confirmTitle ?? "Đồng ý",
                        style:
                            AppStyles.s16w6.withColor(AppColors.primaryLight),
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
