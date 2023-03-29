import 'package:exxe/src/utils/export/ui_export.dart';

typedef CheckBoxOnChange = void Function(bool);

class CheckBoxWidget extends StatefulWidget {
  const CheckBoxWidget({
    super.key,
    required this.onChange,
    required this.radius,
    this.isSelected,
    this.size,
  });

  final CheckBoxOnChange onChange;
  final double radius;
  final bool? isSelected;
  final double? size;

  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  bool currentCheck = false;

  @override
  void initState() {
    super.initState();
    currentCheck = widget.isSelected ?? false;
  }

  @override
  void didUpdateWidget(covariant CheckBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      currentCheck = widget.isSelected ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      alignment: Alignment.center,
      child: currentCheck
          ? Icon(
              Icons.check,
              size: widget.size != null ? widget.size! * 0.8 : 15,
              color: AppColors.primaryLight,
            )
          : null,
    ).inkWell(
      height: widget.size ?? 20,
      width: widget.size ?? 20,
      decoration: BoxDecoration(
          color: currentCheck ? AppColors.primaryButton : Colors.white,
          borderRadius: BorderRadius.circular(widget.radius),
          border: Border.all(color: AppColors.primaryButton)),
      onTap: () {
        currentCheck = !currentCheck;
        widget.onChange(currentCheck);
        setState(() {});
      },
    );
  }
}
