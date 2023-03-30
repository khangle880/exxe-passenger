import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';
import 'no_compounding_note.dart';
import 'suggest_list_trip.dart';

class ListAvailableTrip extends StatefulWidget {
  final LocationModel? from;
  final LocationModel? to;
  final DateTime? date;

  const ListAvailableTrip({
    Key? key,
    this.from,
    this.to,
    this.date,
  }) : super(key: key);

  @override
  State<ListAvailableTrip> createState() => _ListAvailableTripState();
}

class _ListAvailableTripState extends State<ListAvailableTrip>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 10.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeIn));
    animationController.repeat();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ListAvailableTrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    closeSuggestionTrip();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  double dx = 0.0;
  bool isRun = false;
  bool isShowList = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isShowList
        ? SuggestListTrip(
            closeSuggestionTrip: closeSuggestionTrip,
            from: widget.from,
            to: widget.to,
            date: widget.date,
          )
        : Column(
            children: [
              SizedBox(
                width: size.width,
                height: 60,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedPositioned(
                      top: 0.0,
                      right: isRun ? 400 : 0,
                      onEnd: () {
                        isShowList = true;
                        setState(() {});
                      },
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      child: GestureDetector(
                        onPanUpdate: (DragUpdateDetails details) {
                          dx -= details.delta.dx;
                          if (dx <= 0) {
                            return;
                          }
                          if (dx > MediaQuery.of(context).size.width * 0.1) {
                            isRun = true;
                          }
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            const NoCompoundingNote(),
                            const SizedBox(width: 10),
                            AnimatedContainer(
                              padding: const EdgeInsets.all(10.0),
                              width: size.width * 0.33 + dx,
                              decoration: BoxDecoration(
                                color: AppColors.greyLight,
                                borderRadius: dx >
                                        MediaQuery.of(context).size.width * 0.33
                                    ? AppStyles.border15
                                    : AppStyles.borderLeft20TopLeftBottomLeft,
                              ),
                              duration: const Duration(milliseconds: 200),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppIcons.arrowLeftCircle),
                                  const SizedBox(width: 5.0),
                                  Column(
                                    children: [
                                      FittedBox(
                                        child: TextWidget(
                                          text: 'Các chuyến',
                                          maxLine: 2,
                                          fontSize: AppDimens.text12,
                                          weight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                          colorText:
                                              AppColors.primaryTextButton,
                                        ),
                                      ),
                                      FittedBox(
                                        child: TextWidget(
                                          text: 'có sẵn',
                                          maxLine: 2,
                                          fontSize: AppDimens.text12,
                                          weight: FontWeight.w700,
                                          textAlign: TextAlign.center,
                                          colorText:
                                              AppColors.primaryTextButton,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
  }

  void closeSuggestionTrip() {
    setState(() {
      isShowList = false;
      isRun = false;
      dx = 0;
    });
  }
}
