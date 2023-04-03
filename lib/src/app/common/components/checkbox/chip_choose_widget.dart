import 'package:exxe/src/utils/export/ui_export.dart';

typedef OnClickChip = void Function();

class ChoiceChipWidget extends StatelessWidget {
  const ChoiceChipWidget(
      {Key? key,
      required this.child,
      this.onClickChip,
      this.padding,
      this.minWidth,
      this.maxWidth,
      this.backgroundColor})
      : super(key: key);
  final Widget child;
  final OnClickChip? onClickChip;
  final EdgeInsets? padding;
  final double? minWidth;
  final double? maxWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth ?? 50,
        maxWidth: maxWidth ?? (size.width - 56) / 2,
      ),
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primaryButton.withAlpha(10),
          borderRadius: AppStyles.border15,
        ),
        child: child,
      ),
    ).inkWell(
      onTap: onClickChip == null ? null : () => onClickChip,
    );
  }
}
