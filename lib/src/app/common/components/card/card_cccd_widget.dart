import 'package:exxe/src/utils/export/ui_export.dart';

class CardCCCDWidget extends StatelessWidget {
  const CardCCCDWidget(
      {Key? key,
      required this.title,
      required this.label,
      required this.onClick,
      this.margin})
      : super(key: key);
  final String title;
  final String label;
  final Function() onClick;
  final EdgeInsets? margin;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: margin,
          width: double.infinity,
          constraints: const BoxConstraints(
            maxHeight: 32.0,
            minHeight: 24.0,
          ),
          decoration: const BoxDecoration(
            color: AppColors.primaryButton,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          alignment: Alignment.center,
        ),
        GestureDetector(
          onTap: onClick,
          child: Container(
            margin: margin,
            width: double.infinity,
            constraints: const BoxConstraints(
              maxHeight: 120.0,
              minHeight: 100.0,
            ),
            decoration: const BoxDecoration(
              color: AppColors.greyLight,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcons.camera,
                  color: AppColors.primaryTextButton,
                ),
                const SizedBox(height: 10.0),
                TextWidget(
                  text: label,
                  fontSize: AppDimens.text12,
                  colorText: AppColors.primaryTextButton,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
