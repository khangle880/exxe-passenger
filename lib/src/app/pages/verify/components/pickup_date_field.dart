import '../../../../utils/export/ui_export.dart';
import 'pickup_date_row.dart';

class PickupDateField extends StatelessWidget {
  const PickupDateField({
    Key? key,
    required this.date,
    required this.label,
    required this.onSelectDate,
    this.isRequired = true,
    this.dateFormat,
    this.hintText,
    this.calendarViewType = CalendarViewType.date,
  }) : super(key: key);
  final DateTime? date;
  final Function(DateTime value) onSelectDate;
  final String label;
  final bool isRequired;
  final String? dateFormat;
  final String? hintText;
  final CalendarViewType calendarViewType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: AppStyles.s16w7,
            ),
            if (isRequired)
              Text(
                '*',
                style: AppStyles.s14w7.withColor(AppColors.utilRed),
              )
          ],
        ),
        const SizedBox(height: 4),
        CustomFormField(
          validator: (value) {
            if (date == null && isRequired) {
              return "Đây là một trường bắt buộc";
            }
            return null;
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.gray05,
              borderRadius: BorderRadius.circular(8),
            ),
            child: PickupDateRow(
              selectedDate: date,
              onSelectDate: onSelectDate,
              dateFormat: dateFormat ?? 'dd.MM.yyyy',
              iconColor: AppColors.primaryMain,
              style: AppStyles.s16w4,
              selectedColor: AppColors.gray90x27,
              calendarViewType: calendarViewType,
              view: DateRangePickerView.decade,
              hintText: hintText,
            ),
          ),
        )
      ],
    );
  }
}
