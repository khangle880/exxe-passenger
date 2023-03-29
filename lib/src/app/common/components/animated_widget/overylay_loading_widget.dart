import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:lottie/lottie.dart';

class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget(
      {Key? key, required this.child, required this.isLoading})
      : super(key: key);
  final Widget child;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppColors.primaryDark.withOpacity(0.5),
              )
            : Container(),
        isLoading
            ? Center(
                child: Lottie.asset(
                'assets/lottie/loading.json',
                width: 150,
                height: 150,
                animate: true,
              ))
            : Container()
      ],
    );
  }
}
