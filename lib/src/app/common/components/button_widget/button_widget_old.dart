import 'package:exxe/src/utils/export/ui_export.dart';

// ignore: must_be_immutable

// ignore: must_be_immutable
class ButtonWidgetOld extends StatelessWidget {
  /// [mainColor] body color of button. Default: Colors.white
  Color backgroundColor;

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
  BoxBorder? borderSize;

  /// [child] child of button. Widget can be anything as can as possible
  Widget child;
  double radius;
  ButtonWidgetOld({
    Key? key,
    required this.child,
    this.height,
    this.backgroundColor = AppColors.primaryButton,
    this.onClick,
    this.onDoubleClick,
    this.onLongClick,
    this.padding,
    required this.radius,
    this.splashColor = Colors.transparent,
    this.width,
    this.borderSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: borderSize,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(radius),
        color: onClick == null && onDoubleClick == null && onLongClick == null
            ? AppColors.buttonDisable
            : backgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
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
  }
}
