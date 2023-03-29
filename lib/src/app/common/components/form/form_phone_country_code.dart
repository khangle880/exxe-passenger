import 'package:exxe/src/utils/export/ui_export.dart';

class FormPhoneCountryCode extends StatefulWidget {
  const FormPhoneCountryCode(
      {Key? key,
      required this.controller,
      this.validator,
      this.suffixIcon,
      this.onchanged,
      this.contentPadding})
      : super(key: key);
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onchanged;
  final Widget? suffixIcon;
  final EdgeInsets? contentPadding;

  @override
  State<FormPhoneCountryCode> createState() => _FormPhoneCountryCodeState();
}

class _FormPhoneCountryCodeState extends State<FormPhoneCountryCode> {
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
            onChanged: widget.onchanged!,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            textInputAction: TextInputAction.done,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
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
      height: 45.0,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppStyles.border10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FittedBox(
            child: TextWidget(
              text: '+84',
              fontSize: AppDimens.text14,
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
