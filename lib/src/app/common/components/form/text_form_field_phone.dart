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
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCountryCodePhone(),
        const SizedBox(width: 10),
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

  Widget _buildCountryCodePhone() {
    return Container(
      height: 49.0,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppStyles.border10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            child: TextWidget(
              text: '+84',
              fontSize: 14,
              colorText: AppColors.gray70x76,
            ),
          ),
          SvgPicture.asset(
            AppIcons.directionDown,
            color: AppColors.gray70x76,
          )
        ],
      ),
    );
  }
}
