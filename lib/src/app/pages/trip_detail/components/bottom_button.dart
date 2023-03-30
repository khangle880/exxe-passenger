import 'package:exxe/src/utils/export/main_app.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({
    super.key,
    this.firstTitle,
    this.secondTitle,
    this.firstTextStyle,
    this.secondTextStyle,
    this.firstBGColor,
    this.secondBGColor,
    this.onTap,
    this.onTapTwo,
  });

  final String? firstTitle;
  final String? secondTitle;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;
  final Color? firstBGColor;
  final Color? secondBGColor;
  final void Function()? onTap;
  final void Function()? onTapTwo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Row(
        children: [
          if (firstTitle != null)
            Expanded(
              child: ButtonWidget(
                onClick: onTap,
                backgroundColor: firstBGColor ?? AppColors.primaryMainBlur,
                child: Text(
                  firstTitle!,
                  style: firstTextStyle ??
                      AppStyles.s16w6.withColor(AppColors.primaryMain),
                ),
              ),
            ),
          if (firstTitle != null && secondTitle != null)
            const SizedBox(width: 16),
          if (secondTitle != null)
            Expanded(
              child: ButtonWidget(
                onClick: onTapTwo,
                backgroundColor: AppColors.primaryMain,
                child: Text(secondTitle!,
                    style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
              ),
            )
        ],
      ),
    );
  }
}
