import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../utils/export/ui_export.dart';

class SelectDateRange extends StatefulWidget {
  const SelectDateRange(
      {Key? key,
      this.range,
      required this.onRangeChanged,
      this.isFuture = false})
      : super(key: key);

  final PickerDateRange? range;
  final bool isFuture;
  final Function(PickerDateRange? range) onRangeChanged;

  @override
  State<SelectDateRange> createState() => _SelectDateRangeState();
}

class _SelectDateRangeState extends State<SelectDateRange> {
  late final Map<String, PickerDateRange> defaultRanges;

  late PickerDateRange? _selected;

  @override
  void initState() {
    super.initState();
    defaultRanges = {
      "Trong hôm nay": PickerDateRange(DateTime.now(), null),
      "7 ngày gần nhất": PickerDateRange(
        DateTime.now().add(Duration(days: widget.isFuture ? 0 : -7)),
        DateTime.now().add(Duration(days: widget.isFuture ? 7 : 0)),
      ),
      "14 ngày gần nhất": PickerDateRange(
        DateTime.now().add(Duration(days: widget.isFuture ? 0 : -14)),
        DateTime.now().add(Duration(days: widget.isFuture ? 14 : 0)),
      ),
    };
    selected = widget.range;
  }

  @override
  void didUpdateWidget(covariant SelectDateRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    selected = widget.range;
  }

  PickerDateRange? get selected => _selected;

  set selected(PickerDateRange? value) {
    _selected = value == null
        ? null
        : defaultRanges.values.firstWhere(
            (element) =>
                element.startDate?.day == value.startDate?.day &&
                element.endDate?.day == value.endDate?.day,
            orElse: () => value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gần đây", style: AppStyles.s14w7),
          const SizedBox(height: 8),
          ...defaultRanges
              .map(
                (key, value) => MapEntry(
                  key,
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        height: 20,
                        width: 20,
                        child: CircleChecker(
                          isSelected: selected == value,
                          onChange: (bool isChecked) {
                            if (isChecked) {
                              selected = value;
                              widget.onRangeChanged(value);
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      Text(key, style: AppStyles.s14w4),
                    ],
                  ).inkWell(
                    onTap: () {
                      selected = value;
                      widget.onRangeChanged(value);
                      setState(() {});
                    },
                  ),
                ),
              )
              .values
              .toList(),
          const SizedBox(height: 16),
          Text("Khoảng thời gian", style: AppStyles.s14w7),
          const SizedBox(height: 8),
          _buildDateField(),
        ],
      ),
    );
  }

  _buildDateField() {
    final String content = selected?.startDate == null
        ? "08 Tháng 4 - 09 Tháng 4"
        : selected!.endDate?.day == null
            ? selected!.startDate!.toFormat('dd MMMM', locale: 'vi')
            : "${selected!.startDate!.toFormat("dd MMMM", locale: "vi")} - ${selected!.endDate!.toFormat("dd MMMM", locale: "vi")}";

    final Color? color = selected?.startDate == null ? AppColors.gray50 : null;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => CustomCalendar.dialog(
            initDate: DateTime.now(),
            onSelectedChanged: (value) {},
            initRange: selected,
            onSelectedRangeChanged: (value) {
              selected = value;
              widget.onRangeChanged(value);
              setState(() {});
            },
            mode: DateRangePickerSelectionMode.range,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.gray05,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                AppIcons.calendar,
                height: 16,
                width: 16,
                color: AppColors.gray70x3b,
              ),
            ),
            const SizedBox(width: 4),
            Text(content, style: AppStyles.s14w4.withColor(color)),
          ],
        ),
      ),
    );
  }
}
