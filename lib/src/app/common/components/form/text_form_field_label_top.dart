import '../../../../utils/export/ui_export.dart';

class TextFormFieldLabelTop extends StatelessWidget {
  const TextFormFieldLabelTop(
      {Key? key,
      required this.label,
      this.controller,
      this.onChanged,
      this.validator,
      this.keyBoardType,
      this.suffixIcon,
      this.textInputAction,
      this.hintText,
      this.obscure = false,
      this.isRequired = false,
      this.isError = false,
      this.labelTextStyle,
      this.textStyle,
      this.hintStyle,
      this.initialValue, this.inputFormatters})
      : super(key: key);
  final bool? obscure;
  final TextEditingController? controller;
  final String label;
  final TextStyle? labelTextStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final String? hintText;
  final bool isRequired;
  final bool? isError;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: labelTextStyle ?? AppStyles.s18w7,
            ),
            isRequired
                ? Text(
                    '*',
                    style: AppStyles.s14w7.withColor(AppColors.utilRed),
                  )
                : Container(),
          ],
        ),
        const SizedBox(height: 4.0),
        Container(
          decoration: BoxDecoration(
            border: isError!
                ? Border.all(color: AppColors.utilRed, width: 0.5)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormFieldBuilder.none(
            initialValue: initialValue,
            onChanged: onChanged,
            validator: validator,
            controller: controller,
            keyboardType: keyBoardType,
            textInputAction: textInputAction,
            contentPadding: const EdgeInsets.all(12.0),
            suffixIcon: suffixIcon,
            hintText: hintText,
            obscureText: obscure!,
            style: textStyle,
            hintStyle: hintStyle,
            inputFormatters: inputFormatters,
          ),
        )
      ],
    );
  }
}
