import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../utils/export/ui_export.dart';
import 'wheel_picker/pickup_time_wheel.dart';

enum CalendarViewType {
  date,
  dateTime,
  time,

  /// in this type initial date and max date must near expected going on date
  inTwoHour,
}

class CustomCalendar extends StatefulWidget {
  static showCalendar(
    BuildContext context,
    Function(DateTime date) onSelectedChanged, {
    CalendarViewType type = CalendarViewType.dateTime,
    DateTime? initDate,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    final initReal = minDate != null
        ? (initDate?.difference(minDate).isNegative ?? false)
            ? minDate
            : initDate
        : initDate;
    showDialog(
      context: context,
      builder: (_) => CustomCalendar.dialog(
        initDate: initReal ?? DateTime.now(),
        onSelectedChanged: onSelectedChanged,
        type: type,
        minDate: minDate ?? DateTime.now(),
        maxDate: maxDate,
      ),
    );
  }

  static Dialog dialog({
    required DateTime initDate,
    required Function(DateTime value) onSelectedChanged,
    Function(PickerDateRange value)? onSelectedRangeChanged,
    bool disableDate = false,
    bool pickTime = false,
    bool pickRange = false,
    PickerDateRange? initRange,
    DateTime? minDate,
    DateTime? maxDate,
    DateRangePickerView? view,
    CalendarViewType type = CalendarViewType.date,
    DateRangePickerSelectionMode? mode,
  }) =>
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: CustomCalendar(
          onSelectedChanged: onSelectedChanged,
          initDate: initDate,
          disableDate: disableDate,
          pickRange: pickRange,
          pickTime: pickTime,
          initRange: initRange,
          minDate: minDate,
          maxDate: maxDate,
          view: view,
          type: type,
          mode: mode,
          onSelectedRangeChanged: onSelectedRangeChanged,
        ),
      );

  CustomCalendar({
    Key? key,
    required this.onSelectedChanged,
    this.onSelectedRangeChanged,
    required this.initDate,
    this.initRange,
    this.disableDate = false,
    this.pickTime = false,
    this.pickRange = false,
    this.type = CalendarViewType.date,
    DateTime? minDate,
    DateTime? maxDate,
    this.view,
    this.mode,
  }) : super(key: key) {
    this.minDate = minDate ?? DateTime(1900);
    this.maxDate = maxDate ?? DateTime(2400);
  }

  final Function(DateTime value) onSelectedChanged;
  final Function(PickerDateRange value)? onSelectedRangeChanged;
  final DateTime initDate;
  final PickerDateRange? initRange;
  final bool disableDate;
  final bool pickTime;
  final bool pickRange;
  late final DateTime minDate;
  late final DateTime maxDate;
  final DateRangePickerView? view;
  final CalendarViewType type;
  final DateRangePickerSelectionMode? mode;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  final DateRangePickerController controller = DateRangePickerController();
  Duration? selectedTime;
  BehaviorSubject<DateTime?> currentSelected = BehaviorSubject.seeded(null);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AbsorbPointer(
            absorbing: widget.type == CalendarViewType.time ||
                widget.type == CalendarViewType.inTwoHour,
            child: CustomCalendarPickupDate(
              initDate: widget.initDate,
              initRange: widget.initRange,
              disableDate: widget.disableDate,
              minDate: widget.minDate,
              view: widget.view,
              mode: widget.mode,
              controller: controller,
              onSelectionChanged: (args) {
                currentSelected.add(controller.selectedDate);
              },
            ),
          ),
          if (widget.type == CalendarViewType.time ||
              widget.type == CalendarViewType.dateTime ||
              widget.type == CalendarViewType.inTwoHour) ...[
            Divider(
              color: AppColors.primaryMainBlur,
              height: 2,
              thickness: 1,
            ),
            const SizedBox(height: 16),
            Text(
              "Thời gian",
              style: AppStyles.s18w6,
            ),
            const SizedBox(height: 8),
            StreamBuilder<DateTime?>(
              stream: currentSelected.stream,
              builder: (_, snapshot) {
                return _buildTimeView();
              },
            ),
            const SizedBox(height: 24),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: ButtonWidget(
              onClick: () {
                if (widget.mode == DateRangePickerSelectionMode.range &&
                    controller.selectedRange != null) {
                  widget.onSelectedRangeChanged
                      ?.call(controller.selectedRange!);
                } else {
                  if (widget.type == CalendarViewType.inTwoHour) {
                    widget.onSelectedChanged(DateUtils.dateOnly(widget.maxDate)
                        .add(selectedTime ?? const Duration()));
                  } else {
                    widget.onSelectedChanged(
                        DateUtils.dateOnly(controller.selectedDate!)
                            .add(selectedTime ?? const Duration()));
                  }
                }
                Navigator.pop(context);
              },
              enableBackgroundColor: AppColors.accBlueMain,
              width: double.maxFinite,
              radius: 12,
              child: Text(
                'OK',
                style: AppStyles.s16w6.withColor(AppColors.primaryLight),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildTimeView() {
    const step = Duration(minutes: 15);
    if (widget.type == CalendarViewType.inTwoHour) {
      final minEnableDuration = Duration(
          hours: widget.maxDate.hour - 2, minutes: widget.maxDate.minute);
      return PickupTimeWheel(
        initTime: widget.initDate.time,
        maxValue: Duration(hours: widget.maxDate.hour + 11, minutes: 59),
        minValue: Duration(hours: widget.maxDate.hour - 12),
        maxEnablePick: widget.maxDate.time,
        minEnablePick: minEnableDuration,
        step: step,
        onChanged: (value) {
          final date = DateUtils.dateOnly(widget.maxDate);
          selectedTime = value;
          controller.selectedDate = date.add(value);
        },
      );
    }

    DateTime currentDate = currentSelected.value ?? widget.initDate;
    if (currentDate.time > (const Duration(hours: 24) - step) &&
        (currentDate.add(step).difference(widget.maxDate).isNegative)) {
      currentDate = currentDate.date.add(const Duration(days: 1));
      currentSelected.add(currentDate.date.add(const Duration(days: 1)));
      return const SizedBox();
    }

    final isMinDate = widget.minDate.isSameDate(currentDate.date);
    final minTime =
        isMinDate ? widget.minDate.time : const Duration(hours: 0, minutes: 0);
    final isMaxDate = widget.maxDate.date.isSameDate(currentDate.date);
    final maxTime = isMaxDate
        ? widget.maxDate.time
        : const Duration(hours: 23, minutes: 59);

    return PickupTimeWheel(
      initTime: currentDate.time,
      maxValue: const Duration(hours: 23, minutes: 59),
      minValue: const Duration(hours: 0),
      minEnablePick: minTime,
      maxEnablePick: maxTime,
      step: step,
      onChanged: (value) {
        selectedTime = value;
      },
    );
  }
}

class CustomCalendarPickupDate extends StatefulWidget {
  const CustomCalendarPickupDate({
    Key? key,
    required this.initDate,
    required this.disableDate,
    this.initRange,
    this.minDate,
    this.view,
    this.mode,
    this.controller,
    this.onSelectionChanged,
  }) : super(key: key);
  final DateTime initDate;
  final PickerDateRange? initRange;
  final bool disableDate;
  final DateTime? minDate;
  final DateRangePickerView? view;
  final DateRangePickerSelectionMode? mode;
  final DateRangePickerController? controller;
  final void Function(DateRangePickerSelectionChangedArgs)? onSelectionChanged;

  @override
  State<CustomCalendarPickupDate> createState() =>
      _CustomCalendarPickupDateState();
}

class _CustomCalendarPickupDateState extends State<CustomCalendarPickupDate> {
  late final DateRangePickerController _controller;
  String headerString = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DateRangePickerController();
  }

  void viewChanged(DateRangePickerViewChangedArgs args) {
    final DateTime visibleStartDate = args.visibleDateRange.startDate!;
    final DateTime visibleEndDate = args.visibleDateRange.endDate!;
    final int totalVisibleDays =
        (visibleEndDate.difference(visibleStartDate).inDays);
    final DateTime midDate =
        visibleStartDate.add(Duration(days: totalVisibleDays ~/ 2));
    if (_controller.view == DateRangePickerView.decade) {
      headerString =
          "${DateFormat('yyyy').format(visibleStartDate)} - ${DateFormat('yyyy').format(visibleEndDate)}";
    } else if (_controller.view == DateRangePickerView.year) {
      headerString = DateFormat('yyyy').format(midDate);
    } else {
      headerString = "Tháng ${DateFormat('M').format(midDate)}";
    }
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  _controller.backward!();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(AppIcons.chevronLeft,
                      width: 24, height: 24, color: AppColors.primaryMain),
                ),
              ),
              Expanded(
                child: Text(headerString,
                    textAlign: TextAlign.center, style: AppStyles.s18w6),
              ),
              InkWell(
                onTap: () {
                  _controller.forward!();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(AppIcons.chevronRight,
                      width: 24, height: 24, color: AppColors.primaryMain),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SfDateRangePicker(
            view: widget.view ?? DateRangePickerView.month,
            controller: _controller,
            headerHeight: 0,
            showNavigationArrow: true,
            minDate: widget.minDate,
            todayHighlightColor:
                AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.6),
            selectionMode: widget.mode ?? DateRangePickerSelectionMode.single,
            initialSelectedDate: widget.initDate,
            initialSelectedRange: widget.initRange,
            onViewChanged: viewChanged,
            onSelectionChanged: widget.onSelectionChanged,
            monthViewSettings: DateRangePickerMonthViewSettings(
              dayFormat: "E",
              viewHeaderStyle: DateRangePickerViewHeaderStyle(
                textStyle: AppStyles.s14w7.withColor(AppColors.primaryMain +
                    AppColors.primaryLight.withOpacity(0.3)),
              ),
              showTrailingAndLeadingDates: true,
              firstDayOfWeek: 1,
              numberOfWeeksInView: 6,
            ),
            selectionShape: DateRangePickerSelectionShape.rectangle,
            selectionColor: AppColors.primaryMain,
            selectionTextStyle:
                AppStyles.s15w4.withColor(AppColors.primaryLight),
            startRangeSelectionColor: AppColors.primaryMain,
            endRangeSelectionColor: AppColors.primaryMain,
            rangeSelectionColor: AppColors.primaryMain,
            rangeTextStyle: AppStyles.s15w4.withColor(AppColors.primaryLight),
            monthCellStyle: DateRangePickerMonthCellStyle(
              textStyle: AppStyles.s15w4,
              disabledDatesTextStyle:
                  AppStyles.s15w4.withColor(AppColors.gray40),
              leadingDatesTextStyle: AppStyles.s15w4.withColor(
                  AppColors.primaryMain +
                      AppColors.primaryLight.withOpacity(0.6)),
              trailingDatesTextStyle: AppStyles.s15w4.withColor(
                  AppColors.primaryMain +
                      AppColors.primaryLight.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }
}
