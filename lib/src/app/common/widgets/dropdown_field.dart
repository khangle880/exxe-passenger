import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../utils/export/ui_export.dart';

class DropDownField<T> extends StatefulWidget {
  const DropDownField({
    Key? key,
    required this.onSelected,
    required this.list,
    this.itemBuilder,
    required this.hintText,
    this.initialValue,
    this.height = 48,
    this.selectedItemBuilder,
  }) : super(key: key);
  final List<T> list;
  final Function(T? value) onSelected;
  final Widget Function(T value)? itemBuilder;
  final Widget Function(T value)? selectedItemBuilder;
  final String hintText;
  final T? initialValue;
  final double height;

  @override
  State<DropDownField<T>> createState() => _DropDownFieldState<T>();
}

class _DropDownFieldState<T> extends State<DropDownField<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: AppColors.greyLight, borderRadius: BorderRadius.circular(12)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          buttonPadding: const EdgeInsets.only(left: 12, right: 12),
          offset: const Offset(0, 0),
          dropdownDecoration: const BoxDecoration(
            color: AppColors.gray10,
          ),
          itemPadding: const EdgeInsets.only(left: 12),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          isExpanded: true,
          value: selectedValue,
          hint: Text(widget.hintText,
              style: AppStyles.s16w4.withColor(AppColors.gray50)),
          items: widget.list.map((e) {
            return DropdownMenuItem<T>(
              value: e,
              child: widget.itemBuilder?.call(e) ??
                  Text(
                    e.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
            );
          }).toList(),
          onChanged: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
            widget.onSelected(value);
            setState(() {
              selectedValue = value;
            });
          },
        ),
      ),
    );
  }
}
