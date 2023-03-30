import '../../../../utils/export/ui_export.dart';

class RideInfoRow extends StatelessWidget {
  const RideInfoRow(
    this.title, {
    Key? key,
    this.value,
    this.valueColor,
    this.padding,
    this.positive,
    this.bold = false,
  }) : super(key: key);
  final String? value;
  final String title;
  final Color? valueColor;
  final EdgeInsets? padding;
  final bool? positive;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return Container();
    final sign = positive == null
        ? ""
        : positive!
            ? "+ "
            : "- ";
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: (bold ? AppStyles.s15w7 : AppStyles.s14w4)
                .withColor(AppColors.gray60x9d),
          ),
          Text(
            sign + value!,
            style: (bold
                ? AppStyles.s15w7.withColor(valueColor ??
                    AppColors.primaryMain + AppColors.black.withOpacity(.4))
                : AppStyles.s14w4.withColor(valueColor)),
          ),
        ],
      ),
    );
  }
}
