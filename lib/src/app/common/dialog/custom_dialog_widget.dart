import 'package:exxe/src/utils/export/ui_export.dart';

typedef CancelDialogOnClick = void Function();
typedef ConfirmDialogOnClick = void Function();

// ignore: must_be_immutable
class CustomDialogStatusWidget extends StatelessWidget {
  CustomDialogStatusWidget(
      {Key? key,
      required this.title,
      required this.subTitle,
      this.cancel,
      required this.confirm,
      this.onCancel,
      required this.onConfirm,
      required this.iconUrl,
      required this.status})
      : super(key: key);
  final String title;
  final String subTitle;
  String? cancel;
  final String? confirm;
  CancelDialogOnClick? onCancel;
  final ConfirmDialogOnClick onConfirm;
  final String iconUrl;
  final StatusDialog status;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.5,
      backgroundColor: AppColors.primaryLight,
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(iconUrl),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 8),
              child: TextWidget(
                text: title,
                fontSize: AppDimens.text18,
                weight: FontWeight.w700,
              ),
            ),
            TextWidget(
              text: subTitle,
              maxLine: 2,
              textAlign: TextAlign.center,
              fontSize: AppDimens.text14,
              colorText: AppColors.gray70x76,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  status == StatusDialog.Warning
                      ? Expanded(
                          child: ButtonWidgetOld(
                            onClick: onCancel,
                            backgroundColor:
                                AppColors.primaryButton.withAlpha(20),
                            radius: 10,
                            child: TextWidget(
                              text: cancel ?? "Đóng",
                              fontSize: AppDimens.text12,
                              colorText: AppColors.primaryTextButton,
                            ),
                          ),
                        )
                      : Container(),
                  status == StatusDialog.Warning
                      ? const SizedBox(width: 10)
                      : Container(),
                  Expanded(
                    child: ButtonWidgetOld(
                      onClick: onConfirm,
                      backgroundColor: AppColors.primaryButton,
                      radius: 10,
                      child: TextWidget(
                        text: confirm ?? "Confirm",
                        fontSize: AppDimens.text12,
                        colorText: AppColors.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialogConfirmWidget extends StatelessWidget {
  const CustomDialogConfirmWidget(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.confirm,
      required this.onConfirm,
      this.imageUrl})
      : super(key: key);
  final String title;
  final String subTitle;
  final String confirm;
  final ConfirmDialogOnClick onConfirm;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: AppColors.primaryLight,
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryLight, width: 0.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageUrl!.isNotEmpty
                ? Image(
                    image: AssetImage(imageUrl!),
                    width: 150,
                    height: 150,
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: TextWidget(
                text: title,
                fontSize: 18,
                weight: FontWeight.w700,
              ),
            ),
            TextWidget(
              text: subTitle,
              maxLine: 3,
              textAlign: TextAlign.center,
              fontSize: 14,
              colorText: AppColors.gray70x76,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: ButtonWidgetOld(
                onClick: onConfirm,
                height: 45.0,
                backgroundColor: AppColors.primaryButton,
                radius: 10,
                child: Text(
                  confirm,
                  style: AppStyles.s16w6.withColor(AppColors.primaryLight),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
