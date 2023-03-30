import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../../utils/export/ui_export.dart';

export 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PickupDateRow extends StatelessWidget {
  const PickupDateRow({
    Key? key,
    this.selectedDate,
    required this.onSelectDate,
    this.style,
    this.iconColor,
    this.calendarViewType = CalendarViewType.date,
    this.padding = const EdgeInsets.all(12.0),
    this.selectedColor = AppColors.gray95x14,
    this.hintColor = AppColors.gray50,
    this.dateFormat,
    this.hintText,
    this.view,
  }) : super(key: key);
  final DateTime? selectedDate;
  final Function(DateTime date) onSelectDate;
  final TextStyle? style;
  final Color? iconColor;
  final CalendarViewType calendarViewType;

  final EdgeInsets padding;
  final Color selectedColor;
  final Color hintColor;
  final String? dateFormat;
  final String? hintText;
  final DateRangePickerView? view;

  @override
  Widget build(BuildContext context) {
    Dialog showCalendar(void Function(DateTime value) onSelectedChanged) =>
        Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)), //this right here
          child: SingleChildScrollView(
            child: CustomCalendar(
              onSelectedChanged: onSelectedChanged,
              initDate: selectedDate ?? DateTime.now(),
              view: view,
              type: calendarViewType,
            ),
          ),
        );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          showDialog(
              context: context, builder: (_) => showCalendar(onSelectDate));
        },
        child: Container(
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: SvgPicture.asset(AppIcons.calendar,
                    height: 20,
                    width: 20,
                    color: iconColor ?? AppColors.utilRed),
              ),
              const SizedBox(width: 10.0),
              FittedBox(
                child: Text(
                  selectedDate != null
                      ? selectedDate!.toFormat(dateFormat ?? "EEE, dd.MM.yyyy",
                          locale: "vi")
                      : hintText ?? 'Chọn thời gian',
                  style: (style ?? AppStyles.s14w4).withColor(
                      selectedDate != null ? selectedColor : hintColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
