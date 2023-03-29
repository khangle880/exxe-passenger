import '../../../../utils/export/ui_export.dart';

class OptionRow extends StatelessWidget {
  const OptionRow({Key? key, required this.title, required this.onTap})
      : super(key: key);
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppStyles.s16w5.withColor(AppColors.black),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: SvgPicture.asset(
                AppIcons.directionRight,
                height: 24,
                width: 24,
                color: AppColors.gray70x76,
              ),
            )
          ],
        ),
      ),
    );
  }
}
