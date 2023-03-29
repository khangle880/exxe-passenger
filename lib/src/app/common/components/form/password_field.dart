import '../../../../utils/export/ui_export.dart';

class PasswordField extends StatefulWidget {
  const PasswordField(this.onChanged, {Key? key, this.validator})
      : super(key: key);
  final Function(String value) onChanged;
  final String? Function(String? value)? validator;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  toggleObscureText() {
    obscureText = !obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormFieldBuilder.none(
      onChanged: widget.onChanged,
      obscureText: obscureText,
      validator: widget.validator ??
          (value) {
            if (value!.isEmpty) {
              return 'Vui lòng điền mật khẩu';
            } else if (!value.isValidPassword()) {
              return 'Mật khẩu không hợp lệ';
            }
            return null;
          },
      hintText: 'Nhập mật khẩu của bạn',
      keyboardType: TextInputType.visiblePassword,
      contentPadding: const EdgeInsets.all(12.0),
      textAlignVertical: TextAlignVertical.center,
      suffixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: InkWell(
          onTap: toggleObscureText,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.all(4),
            child: (obscureText)
                ? const Icon(
                    Icons.visibility_off,
                    size: 18.0,
                  )
                : const Icon(
                    Icons.visibility_outlined,
                    size: 18.0,
                  ),
          ),
        ),
      ),
    );
  }
}
