import '../../../../utils/export/ui_export.dart';

class TextFieldReadOnly extends StatelessWidget {
  const TextFieldReadOnly(
      {Key? key,
      required this.label,
      required this.hintText,
      this.iconUrl,
      this.onClick,
      this.trailing,
      this.labelStyle,
      this.padding = const EdgeInsets.all(12.0),
      this.backgroundColor,
      this.radius = 8,
      this.icon,
      this.textStyle,
      this.isRequired = true})
      : super(key: key);
  final String label;
  final String hintText;
  final String? iconUrl;
  final Function()? onClick;
  final TextStyle? labelStyle;
  final bool isRequired;
  final TextStyle? textStyle;
  final EdgeInsets padding;
  final Color? backgroundColor;
  final double radius;
  final Widget? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: labelStyle ?? AppStyles.s18w7,
            ),
            isRequired
                ? Text(
                    '*',
                    style: AppStyles.s14w7.withColor(AppColors.utilRed),
                  )
                : Container(),
          ],
        ),
        const SizedBox(height: 4),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 12)],
              Expanded(
                child: Text(
                  hintText,
                  style: textStyle ??
                      AppStyles.s14w6.withColor(AppColors.gray70x76),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ).inkWell(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.greyLight,
            borderRadius: BorderRadius.circular(radius),
          ),
          onTap: onClick,
        ),
      ],
    );
  }
}
