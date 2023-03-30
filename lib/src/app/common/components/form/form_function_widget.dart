import 'package:exxe/src/utils/export/ui_export.dart';

class FormFunctionWidget extends StatelessWidget {
  const FormFunctionWidget(
      {Key? key,
      required this.label,
      required this.hintText,
      this.iconUrl,
      this.onClick,
      this.iconTrailing = false})
      : super(key: key);
  final String label;
  final String hintText;
  final String? iconUrl;
  final bool iconTrailing;
  final Function()? onClick;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontSize: AppDimens.text18,
          weight: FontWeight.w700,
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconUrl != null
                ? SvgPicture.asset(
                    iconUrl!,
                    color: AppColors.gray70x76,
                  )
                : Container(),
            iconUrl != null ? const SizedBox(width: 10) : Container(),
            Expanded(
              child: TextWidget(
                text: hintText,
                colorText: AppColors.gray70x76,
                fontSize: AppDimens.text14,
              ),
            ),
            iconTrailing
                ? SvgPicture.asset(AppIcons.directionRight)
                : Container(),
          ],
        ).inkWell(
          padding: const EdgeInsets.all(10.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppStyles.border10,
          ),
          onTap: onClick,
        ),
      ],
    );
  }
}
