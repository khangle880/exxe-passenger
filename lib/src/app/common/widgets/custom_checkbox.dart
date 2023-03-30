import '../../../utils/export/ui_export.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.size,
      required this.padding})
      : super(key: key);
  final bool? value;
  final void Function(bool? value) onChanged;
  final double size;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      height: size,
      width: size,
      child: Builder(builder: (context) {
        Color getColor(Set<MaterialState> states) {
          const Set<MaterialState> interactiveStates = <MaterialState>{
            MaterialState.pressed,
            MaterialState.hovered,
            MaterialState.focused,
          };
          if (states.any(interactiveStates.contains)) {
            return AppColors.primaryMain.withAlpha(15);
          }
          return AppColors.primaryMain;
        }

        return Checkbox(
          fillColor: MaterialStateProperty.resolveWith(getColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          splashRadius: 4,
          value: value,
          onChanged: onChanged,
        );
      }),
    );
  }
}
