import '../../../../utils/export/ui_export.dart';

class RequiredTextField extends StatelessWidget {
  const RequiredTextField({
    Key? key,
    required this.initialValue,
    required this.onChanged,
    required this.label,
    required this.hintText,
    this.keyBoardType,
    this.inputFormatters,
  }) : super(key: key);
  final String initialValue;
  final Function(String value) onChanged;
  final String label;
  final String hintText;
  final TextInputType? keyBoardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldLabelTop(
      initialValue: initialValue,
      label: label,
      isRequired: true,
      labelTextStyle: AppStyles.s16w7,
      hintText: hintText,
      textStyle: AppStyles.s16w4.withColor(AppColors.gray90x27),
      hintStyle: AppStyles.s16w4.withColor(AppColors.gray50),
      onChanged: onChanged,
      keyBoardType: keyBoardType,
      inputFormatters: inputFormatters,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Đây là một trường bắt buộc";
        }
        return null;
      },
    );
  }
}
