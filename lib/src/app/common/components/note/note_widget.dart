import 'package:exxe/src/utils/export/ui_export.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget(
      {super.key,
      this.padding,
      this.margin,
      this.decoration,
      this.style,
      required this.controller,
      required this.hintText,
      this.onChanged,
      required this.onTapClearText,
      this.height});
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Decoration? decoration;
  final TextStyle? style;
  final void Function(String)? onChanged;
  final TextEditingController controller;
  final void Function() onTapClearText;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: decoration,
      child: TextFormField(
        textAlign: TextAlign.start,
        maxLength: 150,
        inputFormatters: [
          LengthLimitingTextInputFormatter(150),
        ],
        maxLines: 4,
        style: style,
        onChanged: onChanged,
        textInputAction: TextInputAction.done,
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          suffix: const Icon(
            Icons.clear,
            color: AppColors.primaryDark,
          ).gestureDetector(onTap: onTapClearText),
          hintText: hintText,
          hintStyle: AppStyles.s14w4.withColor(AppColors.gray50),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
