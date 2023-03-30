import '../../../../utils/export/ui_export.dart';

class CustomFormField<T> extends StatelessWidget {
  const CustomFormField(
      {Key? key, required this.child, required this.validator})
      : super(key: key);
  final Widget child;
  final String? Function(T? value) validator;

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (state) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          child,
          if (state.errorText != null) const SizedBox(height: 4),
          if (state.errorText != null)
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(state.errorText!,
                  style: AppStyles.s12w4.withColor(AppColors.utilRed)),
            ),
        ],
      ),
      validator: validator,
    );
  }
}
