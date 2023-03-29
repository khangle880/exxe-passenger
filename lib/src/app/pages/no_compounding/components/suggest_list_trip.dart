import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';
import 'item_suggest_trip.dart';

class SuggestListTrip extends StatefulWidget {
  const SuggestListTrip({
    Key? key,
    required this.closeSuggestionTrip,
    this.goingOnTime,
    this.from,
    this.to,
    this.date,
  }) : super(key: key);
  final Function() closeSuggestionTrip;
  final DateTime? goingOnTime;
  final LocationModel? from;
  final LocationModel? to;
  final DateTime? date;

  @override
  State<SuggestListTrip> createState() => _SuggestListTripState();
}

class _SuggestListTripState extends State<SuggestListTrip>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;
  late PageController pageController;
  double scale = 1.0;
  int currentIndex = 0;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.7);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    animation =
        Tween<Offset>(begin: const Offset(1.0, .0), end: const Offset(0.0, 0.0))
            .animate(CurvedAnimation(
                parent: animationController, curve: Curves.easeInBack));
    animationController.forward();
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
      if (status == AnimationStatus.reverse) {}
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  Future<List<CompoundingCarModel>> getRecommendCompoundingCars() async {
    var result = await GetIt.I<CompoundingCarControllerRepo>()
        .getCompoundingCarAvailable(
      type: CompoundingType.convenient,
      fromProvinceId: widget.from?.provinceId,
      toProvinceId: widget.to?.provinceId,
      expectedGoingOnDate: widget.date,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () async {
            await animationController.reverse();
            widget.closeSuggestionTrip();
          },
          child: Container(
            margin: const EdgeInsets.only(right: 10.0),
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              shape: const CircleBorder(),
              color: AppColors.redxDF3,
              shadows: [
                BoxShadow(
                  color: AppColors.primaryText.withAlpha(50),
                  blurRadius: 0.3,
                ),
              ],
            ),
            child: Center(
              child: SvgPicture.asset(
                AppIcons.close,
                color: AppColors.redxDF12,
              ),
            ),
          ),
        ),
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget? child) {
            return SlideTransition(
              position: animation,
              child: child!,
            );
          },
          child: SizedBox(
            width: size.width,
            height: 174,
            child: FutureBuilder<List<CompoundingCarModel>>(
              future: getRecommendCompoundingCars(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<CompoundingCarModel>> snapshot) {
                if (snapshot.hasError) {
                  return const SizedBox();
                }
                if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                  List<CompoundingCarModel> snap = snapshot.data!;
                  return PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      currentIndex = index;
                      setState(() {});
                    },
                    itemCount: snap.length,
                    itemBuilder: (context, index) {
                      return AnimatedScale(
                        scale: currentIndex == index ? scale : 0.9,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.only(
                              bottom: 10, left: 5.0, right: 5.0),
                          padding: const EdgeInsets.all(10.0),
                          width: size.width,
                          decoration: BoxDecoration(
                            color: currentIndex == index
                                ? AppColors.primaryLight
                                : AppColors.primaryLight.withAlpha(150),
                            borderRadius: AppStyles.border15,
                          ),
                          child: ItemSuggestTrip(item: snap[index]),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        )
      ],
    );
  }
}
