import 'package:exxe/src/utils/export/ui_export.dart';
// ignore: must_be_immutable

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  /// [mainColor] body color of button. Default: Colors.white
  Color enableBackgroundColor;

  Color? backgroundColor;

  /// [splashColor] color for splash effect. Default: Colors.grey
  Color? splashColor;

  /// [shadowColor] color for shadow button. Default: Colors.black38
  /// [disableColor] color button if button disable / function onClick off. Default: Colors.grey

  /// [onClick] action when button clicked
  Function()? onClick;

  /// [onDoubleClick] action when button double clicked
  Function()? onDoubleClick;

  /// [onLongClick] action when button long press
  Function()? onLongClick;

  /// [width] width of button
  double? width;

  /// [height] height of button
  double? height;

  /// [padding] padding of button
  EdgeInsetsGeometry? padding;
  BoxBorder? border;

  /// [child] child of button. Widget can be anything as can as possible
  Widget child;

  double? radius;

  bool isExpand;

  ButtonWidget({
    Key? key,
    required this.child,
    this.height,
    this.backgroundColor,
    this.enableBackgroundColor = AppColors.primaryMain,
    this.onClick,
    this.onDoubleClick,
    this.onLongClick,
    this.padding,
    this.radius,
    this.splashColor = Colors.transparent,
    this.width,
    this.border,
    this.isExpand = false,
  }) : super(key: key);

  Widget bottomSingle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.maxFinite,
        child: this,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        border: border,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(radius ?? 12),
        color: backgroundColor ??
            (onClick == null && onDoubleClick == null && onLongClick == null
                ? AppColors.primaryMain +
                    AppColors.primaryLight.withOpacity(0.6)
                : enableBackgroundColor),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius ?? 12),
          splashColor: splashColor,
          onTap: onClick,
          onLongPress: onLongClick,
          onDoubleTap: onDoubleClick,
          hoverColor: Colors.transparent,
          child: Container(
            width: width,
            height: height ?? 45.0,
            padding: width == null
                ? padding ?? const EdgeInsets.all(7.0)
                : height == null
                    ? const EdgeInsets.all(7.0)
                    : null,
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
    if (isExpand) {
      return Expanded(child: widget);
    } else {
      return widget;
    }
  }
}
