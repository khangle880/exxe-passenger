import '../../../../utils/export/ui_export.dart';

class InvoiceChecker extends StatefulWidget {
  const InvoiceChecker(
      {Key? key,
      this.onCheckChanged,
      this.onNameChanged,
      this.onAddressChanged,
      this.onTaxCodeChanged,
      this.onEmailChanged,
      this.onPhoneChanged,
      this.name,
      this.address,
      this.taxCode,
      this.email,
      this.phone})
      : super(key: key);
  final Function(bool value)? onCheckChanged;
  final Function(String value)? onNameChanged;
  final Function(String value)? onAddressChanged;
  final Function(String value)? onTaxCodeChanged;
  final Function(String value)? onEmailChanged;
  final Function(String value)? onPhoneChanged;
  final String? name;
  final String? address;
  final String? taxCode;
  final String? email;
  final String? phone;

  @override
  State<InvoiceChecker> createState() => _InvoiceCheckerState();
}

class _InvoiceCheckerState extends State<InvoiceChecker> {
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(
              () {
                isAgree = !isAgree;
              },
            );
            widget.onCheckChanged?.call(isAgree);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: isAgree,
                  activeColor: AppColors.primaryMain,
                  onChanged: (bool value) {
                    setState(
                      () {
                        isAgree = !isAgree;
                      },
                    );
                    widget.onCheckChanged?.call(value);
                  },
                ),
                Expanded(
                  child: Text(
                    "Xuất hóa đơn điện tử",
                    style: AppStyles.s14w7.withColor(AppColors.primaryMain +
                        AppColors.black.withOpacity(.9)),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isAgree)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // company name
                const SizedBox(height: 8),
                TextFieldJumpFirstUnFocus(
                  initValue: widget.name,
                  hintText: "Tên công ty",
                  onChanged: widget.onNameChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Đây là một trường bắt buộc";
                    }
                    return null;
                  },
                ),
                // address
                const SizedBox(height: 16),
                TextFieldJumpFirstUnFocus(
                  initValue: widget.address,
                  hintText: "Địa chỉ",
                  onChanged: widget.onAddressChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Đây là một trường bắt buộc";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // ma so thue
                TextFieldJumpFirstUnFocus(
                  initValue: widget.taxCode,
                  hintText: "Mã số thuế",
                  onChanged: widget.onTaxCodeChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Đây là một trường bắt buộc";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// Email
                TextFieldJumpFirstUnFocus(
                  initValue: widget.email,
                  hintText: "Email",
                  onChanged: widget.onEmailChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Đây là một trường bắt buộc";
                    }
                    if (!value.isValidEmail()) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// Phone
                TextFieldJumpFirstUnFocus(
                  initValue: widget.phone,
                  hintText: "Số điện thoại",
                  onChanged: widget.onPhoneChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Đây là một trường bắt buộc";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
      ],
    );
  }
}

class TextFieldJumpFirstUnFocus extends StatefulWidget {
  const TextFieldJumpFirstUnFocus({
    Key? key,
    required this.hintText,
    this.initValue,
    this.onChanged,
    this.suffixIcon,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
  }) : super(key: key);
  final String? initValue;
  final String hintText;
  final Function(String value)? onChanged;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final TextInputType? keyboardType;

  @override
  State<TextFieldJumpFirstUnFocus> createState() =>
      _TextFieldJumpFirstUnFocusState();
}

class _TextFieldJumpFirstUnFocusState extends State<TextFieldJumpFirstUnFocus> {
  final FocusNode _focus = FocusNode();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    if (!_focus.hasFocus) {
      controller.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldBuilder.none(
      initialValue: widget.initValue,
      onChanged: widget.onChanged,
      focusNode: _focus,
      scrollController: controller,
      keyboardType: widget.keyboardType,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "Đây là một trường bắt buộc";
            }
            return null;
          },
      // suffixIcon: suffixIcon,
      inputFormatters: widget.inputFormatters,
      hintText: widget.hintText,
      style: AppStyles.s14w5,
      suffixIcon: widget.suffixIcon,
      filledColor: AppColors.gray10.withOpacity(0.9),
      textInputAction: TextInputAction.next,
      hintStyle: AppStyles.s14w5.withColor(AppColors.gray50),
    );
  }
}
