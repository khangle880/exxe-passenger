import 'package:flutter_countdown_timer/index.dart';
import '../../../utils/export/ui_export.dart';

enum CountDownButtonType { buttonWidget, inkwell }

class CountDownButton extends StatefulWidget {
  const CountDownButton({
    Key? key,
    this.onClick,
    required this.content,
    required this.backgroundColor,
    required this.textStyle,
    required this.endTime,
    this.onEnd,
    this.type = CountDownButtonType.buttonWidget,
  }) : super(key: key);
  final Function()? onClick;
  final String content;
  final Color Function(bool isWaiting) backgroundColor;
  final TextStyle Function(bool isWaiting) textStyle;
  final Function()? onEnd;
  final CountDownButtonType type;

  /// can use DateTime.now().millisecondsSinceEpoch + waitMilliSeconds
  final int endTime;

  @override
  State<CountDownButton> createState() => _CountDownButtonState();
}

class _CountDownButtonState extends State<CountDownButton> {
  late final CountdownTimerController controller;
  late bool isWaiting;

  @override
  void initState() {
    super.initState();
    isWaiting = true;
    controller =
        CountdownTimerController(endTime: widget.endTime, onEnd: onEnd);
  }

  void onEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      isWaiting = false;
      setState(() {});
      widget.onEnd?.call();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == CountDownButtonType.inkwell) {
      return InkWell(
        onTap: isWaiting ? null : widget.onClick,
        child: _buildTextCountDown(),
      );
    }
    return ButtonWidget(
      onClick: isWaiting ? null : widget.onClick,
      backgroundColor: widget.backgroundColor(isWaiting),
      radius: 12,
      child: _buildTextCountDown(),
    );
  }

  _buildTextCountDown() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.content,
          style: widget.textStyle(isWaiting),
        ),
        if (isWaiting)
          CountdownTimer(
            controller: controller,
            widgetBuilder: (_, time) {
              if (time == null) {
                return Container();
              }
              return Text(
                ' ${(time.min ?? 0).toString().padLeft(2, '0')}:${(time.sec ?? 0).toString().padLeft(2, '0')}',
                style: widget.textStyle(isWaiting),
              );
            },
          )
      ],
    );
  }
}
