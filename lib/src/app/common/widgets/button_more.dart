import '../../../utils/export/ui_export.dart';

class ButtonMore extends StatelessWidget {
  const ButtonMore({Key? key, this.onTap}) : super(key: key);
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
          color: AppColors.accOrgangeMain + AppColors.primaryLight.withOpacity(0.85),
          borderRadius: AppStyles.border8
      ),
      child: Text(
        "Xem thêm",
        style: AppStyles.s12w6.withColor(AppColors.orangeMain),
      ),
    ).inkWell(
      onTap: onTap
    );
  }
}
