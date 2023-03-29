import 'package:flutter_countdown_timer/index.dart';

import '../../../utils/export/ui_export.dart';

class CountDownText extends StatefulWidget {
  const CountDownText(
      {Key? key, this.onEnd, required this.textStyle, required this.endTime})
      : super(key: key);
  final Function()? onEnd;
  final int endTime;
  final TextStyle Function(bool isWaiting) textStyle;

  @override
  State<CountDownText> createState() => _CountDownTextState();
}

class _CountDownTextState extends State<CountDownText> {
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
    return CountdownTimer(
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
    );
  }
}
