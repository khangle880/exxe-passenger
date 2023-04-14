import '../../../../utils/export/ui_export.dart';

class TextFormFieldPhone extends StatefulWidget {
  const TextFormFieldPhone(
      {Key? key,
      required this.controller,
      this.validator,
      this.suffixIcon,
      this.onChanged,
      this.contentPadding,
      this.textInputAction})
      : super(key: key);
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;
  final TextInputAction? textInputAction;

  @override
  State<TextFormFieldPhone> createState() => _TextFormFieldPhoneState();
}

class _TextFormFieldPhoneState extends State<TextFormFieldPhone> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormFieldBuilder.none(
            key: const ValueKey('phone'),
            onChanged: widget.onChanged!,
            textInputAction: TextInputAction.next,
            filledColor: AppColors.white,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onSubmit: (v) {
              FocusScope.of(context).nextFocus();
            },
            keyboardType: TextInputType.phone,
            validator: widget.validator,
            hintText: 'Nhập số điện thoại',
            controller: widget.controller,
            contentPadding: widget.contentPadding ?? const EdgeInsets.all(10.0),
            suffixIcon: widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
