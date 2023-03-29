import 'package:exxe/src/utils/export/ui_export.dart';

// ignore: must_be_immutable
class FormLabelWidget extends StatelessWidget {
  FormLabelWidget(
      {Key? key,
      required this.controller,
      required this.label,
      this.onChanged,
      this.validator,
      this.keyBoardType,
      this.suffixIcon,
      this.textInputAction,
      this.hintText,
      this.obs = false,
      this.isRequired = false,
      this.isError = false})
      : super(key: key);
  final TextEditingController controller;
  bool? obs;
  final String label;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final String? hintText;
  final bool isRequired;
  final bool? isError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              text: label,
              fontSize: AppDimens.text18,
              weight: FontWeight.w700,
            ),
            isRequired
                ? TextWidget(
                    text: '*',
                    colorText: AppColors.textError,
                  )
                : Container(),
          ],
        ),
        const SizedBox(height: 4.0),
        Container(
          decoration: BoxDecoration(
            border: isError!
                ? Border.all(color: AppColors.textError, width: 0.5)
                : null,
            borderRadius: AppStyles.border10,
          ),
          child: TextFormFieldBuilder.none(
            onChanged: onChanged!,
            validator: validator,
            controller: controller,
            keyboardType: keyBoardType,
            textInputAction: textInputAction,
            contentPadding: const EdgeInsets.all(15.0),
            suffixIcon: suffixIcon,
            hintText: hintText,
            obscureText: obs!,
          ),
        )
      ],
    );
  }
}
