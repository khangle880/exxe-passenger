import 'package:exxe/src/utils/export/ui_export.dart';

class TypeStatusWidget extends StatelessWidget {
  const TypeStatusWidget({
    Key? key,
    required this.baseColor,
    required this.name,
  }) : super(key: key);
  final Color baseColor;
  final String name;

  factory TypeStatusWidget.compoundingType(CompoundingType type) {
    return TypeStatusWidget(
      baseColor: type.colorByTrip,
      name: type.name,
    );
  }

  factory TypeStatusWidget.paymentPurpose(PaymentPurpose type) {
    return TypeStatusWidget(
      baseColor: type.getStatusColor,
      name: type.getStatusTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor + AppColors.primaryLight.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FittedBox(
        child: Text(
          name,
          style: AppStyles.s12w6.withColor(baseColor),
        ),
      ),
    );
  }
}
