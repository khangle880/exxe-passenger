import 'package:exxe/src/utils/export/ui_export.dart';

class PickupDate extends StatelessWidget {
  const PickupDate({
    Key? key,
    this.selectedDate,
    required this.onSelectDate,
    this.style,
  }) : super(key: key);
  final DateTime? selectedDate;
  final VoidCallback? onSelectDate;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelectDate,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.calendar,
                width: 25,
                height: 25,
                color: AppColors.utilRed,
              ),
              const SizedBox(width: 10.0),
              FittedBox(
                child: Text(
                  selectedDate != null
                      ? selectedDate!.getDateTimeString
                      : 'Chọn thời gian',
                  style: (style ?? AppStyles.s14w4).withColor(
                      selectedDate != null
                          ? AppColors.gray95x06
                          : AppColors.gray50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
