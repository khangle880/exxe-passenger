import '../../../utils/export/ui_export.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog(
      {Key? key,
      required this.message,
      this.title,
      this.buttonTitle,
      this.onConfirm})
      : super(key: key);
  final String message;
  final String? title;
  final String? buttonTitle;
  final Function()? onConfirm;

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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppIcons.warning,
                height: 87,
                width: 87,
              ),
              const SizedBox(height: 16),
              if (title != null) ...[
                Text(
                  title!,
                  style: AppStyles.s16w6,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
              ],
              Text(
                message,
                style: AppStyles.s16w6,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                          onClick: onConfirm ??
                              () {
                                Navigator.pop(context);
                              },
                          radius: 12,
                          child: Text(
                            buttonTitle ?? "Trở lại",
                            style: AppStyles.s16w6
                                .withColor(AppColors.primaryLight),
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
