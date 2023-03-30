import 'package:exxe/src/utils/export/ui_export.dart';

class StatusRide extends StatelessWidget {
  const StatusRide({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppStyles.border10,
        border: Border.all(color: color),
      ),
      alignment: Alignment.center,
      child: FittedBox(
        child: TextWidget(
          text: label,
          colorText: color,
          fontSize: AppDimens.text14,
          weight: AppStyles.fontWeightW400,
        ),
      ),
    );
  }
}
