import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class RecommendListItem extends StatelessWidget {
  const RecommendListItem(
      {Key? key, required this.compoundingCar, required this.onItemSelected})
      : super(key: key);
  final CompoundingCarModel compoundingCar;
  final Function(CompoundingCarModel compoundingCarModel) onItemSelected;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        DistanceWidget(compoundingCar),
        const SizedBox(height: 8),
        CompoundingCarTimeWidget(compoundingCar),
        const Divider(thickness: 1),
        Row(
          children: [
            Text("Cước phí :",
                style: AppStyles.s16w6.withColor(AppColors.gray60x52)),
            const Spacer(),
            Text(
              compoundingCar.priceUnit?.priceUnit?.ceil().currencyFormat ?? "0",
              style: AppStyles.s18w7.withColor(AppColors.utilRed),
            )
          ],
        ),
      ],
    );

    return GestureDetector(
      onTap: () {
        onItemSelected(compoundingCar);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                  spreadRadius: -2,
                  color: AppColors.black.withOpacity(.05)),
              BoxShadow(
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                  spreadRadius: -3,
                  color: const Color(0xFFCACACA).withOpacity(.1))
            ]),
        child: body,
      ),
    );
  }

  Widget _buildHeader() {
    final color = (compoundingCar.car?.numberSeat ?? 0) < 6
        ? AppColors.green60
        : AppColors.accent;
    return Row(
      children: [
        TypeStatusWidget.compoundingType(compoundingCar.compoundingType!),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color + AppColors.primaryLight.withOpacity(0.95),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            "${compoundingCar.car?.name?.toLowerCase().replaceAll("xe ", "").capitalize()}",
            style: AppStyles.s12w6.withColor(color),
          ),
        )
      ],
    );
  }
}

class RecommendListItemShimmer extends StatelessWidget {
  const RecommendListItemShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 16,
              color: const Color(0xFF11101A).withOpacity(.1))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                  text: "Mot chuyen",
                  addMore: const Size(24, 8),
                  borderRadius: 8),
              const SizedBox(width: 4),
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                  text: "4 cho", addMore: const Size(24, 8), borderRadius: 8),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: ShimmerUtils.buildShimmerWithText(
                      AppStyles.s18w6.withColor(AppColors.primaryMain),
                      text: "TP Ho Chi Minh"),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                      text: "100km"),
                  const SizedBox(height: 4),
                  ShimmerUtils.buildShimmer(
                      child: SvgPicture.asset(AppIcons.dashArrow)),
                ],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: ShimmerUtils.buildShimmerWithText(AppStyles.s18w6,
                      text: "TP Ho Chi Minh"),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerUtils.buildShimmerWithText(AppStyles.s14w4,
                        text: "Ngày giờ đi"),
                    const SizedBox(height: 4),
                    ShimmerUtils.buildShimmerWithText(AppStyles.s16w7,
                        text: "18:00 - 21.03.2023"),
                  ],
                ),
              ),
              ShimmerUtils.buildShimmer(
                child: const SizedBox(
                    height: 40, child: VerticalDivider(thickness: 1)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ShimmerUtils.buildShimmerWithText(AppStyles.s14w4,
                        text: "Ngày giờ về"),
                    const SizedBox(height: 4),
                    ShimmerUtils.buildShimmerWithText(AppStyles.s16w7,
                        text: "18:00 - 21.03.2023"),
                  ],
                ),
              ),
            ],
          ),
          ShimmerUtils.buildShimmer(child: const Divider(thickness: 1)),
          Row(
            children: [
              ShimmerUtils.buildShimmerWithText(AppStyles.s16w6,
                  text: "Cước phí :"),
              const Spacer(),
              ShimmerUtils.buildShimmerWithText(AppStyles.s18w7,
                  text: "2.000.000d"),
            ],
          ),
        ],
      ),
    );
  }
}

class DistanceWidget extends StatelessWidget {
  const DistanceWidget(this.compoundingCar, {Key? key}) : super(key: key);
  final CompoundingCarModel compoundingCar;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            (compoundingCar.fromProvince?.provinceName).safeText,
            style: AppStyles.s18w6.withColor(AppColors.primaryMain),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${compoundingCar.distance!.ceil()}km",
              style: AppStyles.s12w6.withColor(AppColors.gray70x3b),
            ),
            const SizedBox(height: 4),
            SvgPicture.asset(AppIcons.dashArrow),
          ],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            (compoundingCar.toProvince?.provinceName).safeText,
            style: AppStyles.s18w6.withColor(AppColors.orangeMain),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class CompoundingCarTimeWidget extends StatelessWidget {
  const CompoundingCarTimeWidget(this.compoundingCar, {Key? key})
      : super(key: key);
  final CompoundingCarModel compoundingCar;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ngày giờ đi",
                  style: AppStyles.s14w4.withColor(AppColors.gray60x9d)),
              const SizedBox(height: 4),
              Text(
                compoundingCar.expectedGoingOnDate?.getDateTimeString ?? "---",
                style: AppStyles.s16w7.withColor(AppColors.utilRed),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40, child: VerticalDivider(thickness: 1)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Ngày giờ về",
                  style: AppStyles.s14w4.withColor(AppColors.gray60x9d)),
              const SizedBox(height: 4),
              Text(
                compoundingCar.expectedPickingUpDate?.getDateTimeString ??
                    "---",
                style: AppStyles.s16w7.withColor(AppColors.primaryMain),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
