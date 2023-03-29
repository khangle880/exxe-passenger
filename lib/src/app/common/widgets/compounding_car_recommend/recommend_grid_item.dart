import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class RecommendGridItem extends StatelessWidget {
  const RecommendGridItem(
      {Key? key, required this.compoundingCar, required this.onItemSelected})
      : super(key: key);
  final CompoundingCarModel compoundingCar;
  final Function(CompoundingCarModel compoundingCarModel) onItemSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onItemSelected(compoundingCar);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greyLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: compoundingCar.compoundingType!.getSvg(),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    AppIcons.passenger_number,
                    height: 16,
                    width: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${compoundingCar.numberSeatInCar!.ceil() - compoundingCar.numberAvailableSeat!.ceil()}/${compoundingCar.numberSeatInCar!.ceil()}',
                    style: AppStyles.s12w6,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DashedLineHorizontal(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(compoundingCar.fromProvince!.provinceShortName!,
                    style: AppStyles.s14w7),
                SvgPicture.asset(
                  AppIcons.arrow,
                  height: 12,
                  width: 12,
                ),
                Text(compoundingCar.toProvince!.provinceShortName!,
                    style: AppStyles.s14w7)
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.calendar,
                  height: 16,
                  width: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    compoundingCar.expectedGoingOnDate!
                        .toFormat('HH:mm - dd.MM.yyyy'),
                    style: AppStyles.s12w6,
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.navigate_map,
                  height: 16,
                  width: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                    child: Text(
                  '${compoundingCar.distance} km',
                  style: AppStyles.s12w6,
                  overflow: TextOverflow.ellipsis,
                )),
                const SizedBox(width: 8),
                SvgPicture.asset(AppIcons.clockCircle, width: 16, height: 16),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '~${compoundingCar.duration!.getTimeFromHoursShort}',
                    style: AppStyles.s12w6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.outlineCar,
                  height: 16,
                  width: 16,
                ),
                const SizedBox(width: 4),
                Text("${compoundingCar.numberSeatInCar} chỗ",
                    style: AppStyles.s12w6)
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: DashedLineHorizontal(),
            ),
            Row(
              children: [
                Text(
                  compoundingCar.priceUnit!.priceUnit!.ceil().currencyFormat,
                  style: AppStyles.s12w7.copyWith(color: AppColors.utilRed),
                ),
                const Spacer(),
                ButtonWidget(
                  width: 53,
                  height: 24,
                  radius: 8,
                  enableBackgroundColor: AppColors.primaryLight,
                  border: Border.all(color: AppColors.primaryMain),
                  onClick: () {
                    onItemSelected(compoundingCar);
                  },
                  child: Text(
                    "Chọn",
                    style:
                        AppStyles.s12w5.copyWith(color: AppColors.primaryMain),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RecommendGridItemShimmer extends StatelessWidget {
  const RecommendGridItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerUtils.buildShimmer(height: 20, width: 25),
                  const Spacer(),
                  ShimmerUtils.buildShimmer(
                    child: SvgPicture.asset(
                      AppIcons.passenger_number,
                      width: 16,
                      height: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ShimmerUtils.buildShimmer(height: 20, width: 25),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ShimmerUtils.buildShimmer(
              child: const DashedLineHorizontal(color: AppColors.gray20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerUtils.buildShimmerWithText(AppStyles.s14w7,
                  text: "TP.HCM"),
              ShimmerUtils.buildShimmer(
                child: SvgPicture.asset(
                  AppIcons.arrow,
                  width: 12,
                  height: 12,
                ),
              ),
              ShimmerUtils.buildShimmerWithText(AppStyles.s14w7,
                  text: "Bduong"),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ShimmerUtils.buildShimmer(
                child: SvgPicture.asset(
                  AppIcons.calendar,
                  width: 16,
                  height: 16,
                ),
              ),
              const SizedBox(width: 4),
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                  text: "hh:mm - dd:mm:yyyy"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ShimmerUtils.buildShimmer(
                child: SvgPicture.asset(
                  AppIcons.navigate_map,
                  height: 16,
                  width: 16,
                ),
              ),
              const SizedBox(width: 4),
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w6, text: "290.0km"),
              const Spacer(),
              ShimmerUtils.buildShimmer(
                child: SvgPicture.asset(
                  AppIcons.clockCircle,
                  height: 16,
                  width: 16,
                ),
              ),
              const SizedBox(width: 4),
              ShimmerUtils.buildShimmer(
                child: Text("~", style: AppStyles.s12w6),
              ),
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w6, text: "hh:mm"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ShimmerUtils.buildShimmer(
                child: SvgPicture.asset(
                  AppIcons.outlineCar,
                  width: 16,
                  height: 16,
                ),
              ),
              const SizedBox(width: 4),
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                  text: "cho ngoi"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ShimmerUtils.buildShimmer(
              child: const DashedLineHorizontal(color: AppColors.gray20),
            ),
          ),
          Row(
            children: [
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w7,
                  text: "3.333.333 d"),
              const Spacer(),
              ShimmerUtils.buildShimmer(width: 53, height: 24, borderRadius: 8)
            ],
          ),
        ],
      ),
    );
  }
}
