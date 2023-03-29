import 'dart:async';
import 'package:exxe/src/utils/export/ui_export.dart';

class Toast {
  static OverlayEntry? _overlayEntry;
  static bool isVisible = false;
  static void show(String msg, BuildContext context, int duration) async {
    Color backgroundColor = AppColors.accBlueMain;
    if (isVisible) return;
    Toast._createView(msg, context, backgroundColor, duration);
  }

  static void _createView(
    String msg,
    BuildContext context,
    Color background,
    int duration,
  ) async {
    var overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _ToastAnimatedWidget(
        overlayEntry: _overlayEntry!,
        msg: msg,
        backgroundColor: background,
        duration: duration,
      ),
    );
    isVisible = true;
    overlayState.insert(_overlayEntry!);
  }
}

class _ToastAnimatedWidget extends StatefulWidget {
  const _ToastAnimatedWidget({
    Key? key,
    required this.backgroundColor,
    required this.overlayEntry,
    required this.msg,
    required this.duration,
  }) : super(key: key);

  final Color backgroundColor;
  final OverlayEntry overlayEntry;
  final String msg;
  final int duration;

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastAnimatedWidget>
    with SingleTickerProviderStateMixin {
//update this value later
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: widget.duration), () {});
        if (widget.overlayEntry.mounted) {
          widget.overlayEntry.remove();
          Toast.isVisible = false;
        }
      }
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 50,
        left: 100.0,
        right: 100.0,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0, 0.0),
          ).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.linearToEaseOut),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 50.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcons.checkCircle, color: AppColors.primaryLight,),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextWidget(
                      text: widget.msg,
                      colorText: AppColors.primaryLight,
                      maxLine: 2,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                
                // GestureDetector(
                //   onTap: () {
                //     widget.overlayEntry.remove();
                //     Toast.isVisible = false;
                //   },
                //   child: TextWidget(
                //     text: "Đóng",
                //     colorText: AppColors.primaryTextButton,
                //     weight: FontWeight.w600,
                //     textAlign: TextAlign.left,
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }
}
