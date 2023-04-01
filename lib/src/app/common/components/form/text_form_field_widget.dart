import 'package:exxe/src/utils/export/ui_export.dart';

// ignore: must_be_immutable
class TextFormFieldBuilder extends TextFormField {
  TextFormFieldBuilder.none({
    Key? key,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Function(String)? onSubmit,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    EdgeInsetsGeometry? contentPadding,
    FocusNode? focusNode,
    bool obscureText = false,
    bool readOnly = false,
    Iterable<String>? autofillHints,
    VoidCallback? onEditingComplete,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hintText,
    Color? filledColor,
    int maxLines = 1,
    Color? colorHintText,
    TextStyle? style,
    TextStyle? hintStyle,
    String? initialValue,
    bool? isDense,
    TextAlignVertical? textAlignVertical,
    ScrollController? scrollController,
  }) : super(
          key: key,
          scrollController: scrollController,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          onFieldSubmitted: onSubmit,
          inputFormatters: inputFormatters,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          obscureText: obscureText,
          autofillHints: autofillHints,
          onEditingComplete: onEditingComplete,
          style: style,
          textAlignVertical: textAlignVertical,
          decoration: InputDecoration(
            hoverColor: Colors.transparent,
            isDense: isDense,
            prefixIconConstraints: const BoxConstraints(
              minHeight: 10.0,
              minWidth: 10.0,
            ),
            hintStyle:
                hintStyle ?? AppStyles.s14w5.withColor(AppColors.gray60x52),
            focusColor: AppColors.primaryMain,
            contentPadding: contentPadding,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            hintText: hintText,
            errorMaxLines: 2,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.utilRed, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: AppColors.utilRed, width: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: filledColor ?? AppColors.greyLight,
            errorStyle: AppStyles.s12w4.withColor(
              AppColors.utilRed,
            ),
          ),
        );

  TextFormFieldBuilder.outlineBorder({
    Key? key,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    Function(String)? onSubmit,
    List<TextInputFormatter>? inputFormatters,
    TextEditingController? controller,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    EdgeInsetsGeometry? contentPadding,
    FocusNode? focusNode,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hintText,
    Color? filledColor,
    Color? outlineColor,
    String? initialValue,
  }) : super(
          key: key,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
          onFieldSubmitted: onSubmit,
          inputFormatters: inputFormatters,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          obscureText: obscureText,
          decoration: InputDecoration(
            suffixIconColor: AppColors.gray70x76,
            hintStyle: AppStyles.s14w5.withColor(AppColors.gray60x52),
            prefixIcon: prefixIcon,
            focusColor: AppColors.primaryMain,
            contentPadding: contentPadding,
            suffixIcon: suffixIcon,
            hintText: hintText,
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: outlineColor ?? AppColors.gray70x76, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: outlineColor ?? AppColors.gray70x76, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: outlineColor ?? AppColors.gray70x76, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: outlineColor ?? AppColors.gray70x76, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: outlineColor ?? AppColors.utilRed, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: outlineColor ?? AppColors.utilRed, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: filledColor ?? AppColors.greyLight,
            errorStyle: AppStyles.s12w4.withColor(
              AppColors.utilRed,
            ),
          ),
        );

  TextFormFieldBuilder.search({
    Key? key,
    Function(String)? onChanged,
    String? Function(String?)? validator,
    Function(String)? onSubmit,
    List<TextInputFormatter>? inputFormaters,
    TextEditingController? controller,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    EdgeInsetsGeometry? contentPadding,
    FocusNode? focusNode,
    bool obscureText = false,
    bool readOnly = false,
    Widget? suffixIcon,
    Widget? prefixIcon,
    String? hintText,
    Color? filledColor,
    Color? enableColor,
    Color? focusColor,
    Color? errorColor,
    Color? outlineColor,
    int maxLines = 1,
    Color? colorHintText,
    TextStyle? style,
    TextStyle? hintStyle,
    String? initialValue,
  }) : super(
          key: key,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
          maxLines: maxLines,
          onFieldSubmitted: onSubmit,
          inputFormatters: inputFormaters,
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          obscureText: obscureText,
          style: style,
          decoration: InputDecoration(
            hoverColor: Colors.transparent,
            hintStyle:
                hintStyle ?? AppStyles.s14w5.withColor(AppColors.gray60x52),
            focusColor: AppColors.primaryMain,
            contentPadding: contentPadding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            suffixIconConstraints:
                const BoxConstraints(minHeight: 16, minWidth: 16),
            suffixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: suffixIcon ??
                    SvgPicture.asset(
                      AppIcons.search2,
                      color: AppColors.gray40,
                    )),
            prefixIcon: prefixIcon,
            hintText: hintText,
            errorMaxLines: 2,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: focusColor ??
                      AppColors.primaryMain +
                          AppColors.primaryLight.withOpacity(0.8),
                  width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: outlineColor ?? AppColors.gray10, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: outlineColor ?? AppColors.gray10, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.utilRed, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.utilRed, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: filledColor ?? AppColors.primaryLight,
            errorStyle: AppStyles.s12w4.withColor(
              AppColors.utilRed,
            ),
          ),
        );
}
