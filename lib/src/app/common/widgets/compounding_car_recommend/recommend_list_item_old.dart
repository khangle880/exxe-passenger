import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class RecommendListItemOld extends StatelessWidget {
  const RecommendListItemOld(
      {Key? key, required this.compoundingCar, required this.onItemSelected})
      : super(key: key);
  final CompoundingCarModel compoundingCar;
  final Function(CompoundingCarModel compoundingCarModel) onItemSelected;

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        _buildInformationNameWay(),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeStatusWidget.compoundingType(compoundingCar.compoundingType!),
            const SizedBox(width: 4),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${compoundingCar.car?.name?.toLowerCase().replaceAll("xe ", "").capitalize() ?? ''}${compoundingCar.compoundingType == CompoundingType.compounding ? " : " : ""}",
                    style: AppStyles.s12w6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (compoundingCar.compoundingType ==
                      CompoundingType.compounding)
                    Expanded(
                      child: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final length =
                            compoundingCar.numberSeatInCar?.ceil() ?? 0;
                        num spacing =
                            (constraints.maxWidth - (length * 14)) / length;
                        if (spacing < 0 || spacing > 4) spacing = 4;
                        return Wrap(
                          runSpacing: 4,
                          spacing: spacing.toDouble(),
                          children: List.generate(
                            length,
                            (index) =>
                                ((compoundingCar.numberSeat ?? 0).ceil() >=
                                        index + 1
                                    ? SvgPicture.asset(AppIcons.userFilled)
                                    : SvgPicture.asset(AppIcons.userOutline,
                                        color: AppColors.primaryMain)),
                          ),
                        );
                      }),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              (compoundingCar.priceUnit?.priceUnit?.ceil().currencyFormat)
                  .safeText,
              style: AppStyles.s14w6.withColor(AppColors.utilRed),
              overflow: TextOverflow.ellipsis,
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
        padding: const EdgeInsets.all(8.0),
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

  Widget _buildInformationNameWay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (compoundingCar.fromProvince?.provinceName).safeText,
                style: AppStyles.s15w6.withColor(AppColors.primaryMain),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              compoundingCar.compoundingType!.getSvg(width: 24),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              compoundingCar.expectedGoingOnDate!.toFormat('dd.MM.yyyy'),
              style: AppStyles.s12w6.withColor(AppColors.primaryMain),
            ),
            SvgPicture.asset(AppIcons.longArrow),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  compoundingCar.expectedGoingOnDate!.toFormat("HH:mm"),
                  style: AppStyles.s12w6,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  " - ${compoundingCar.distance!.round()}km",
                  style: AppStyles.s12w6,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (compoundingCar.toProvince?.provinceName).safeText,
                style: AppStyles.s15w6.withColor(AppColors.orangeMain),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              ButtonWidget(
                width: 65,
                height: 24,
                radius: 8,
                backgroundColor: AppColors.primaryLight,
                border: Border.all(color: AppColors.primaryMain),
                onClick: () {
                  onItemSelected(compoundingCar);
                },
                child: Text(
                  "Chọn",
                  style: AppStyles.s12w6.copyWith(color: AppColors.primaryMain),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class RecommendListItemShimmerOld extends StatelessWidget {
  const RecommendListItemShimmerOld({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerUtils.buildShimmerWithText(AppStyles.s15w6,
                          text: "TP.HCM"),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ShimmerUtils.buildShimmer(height: 20, width: 20),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                          text: "dd.MM.yyyy"),
                      ShimmerUtils.buildShimmer(
                        child: SvgPicture.asset(AppIcons.longArrow),
                      ),
                      ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                          text: "12h00p"),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ShimmerUtils.buildShimmerWithText(AppStyles.s15w6,
                          text: "TP.HCM"),
                      const SizedBox(height: 8),
                      ShimmerUtils.buildShimmer(
                          width: 65, height: 24, borderRadius: 8)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                text: "Ghep chuyen",
                addMore: const Size(24, 8),
                borderRadius: 8),
            const SizedBox(width: 4),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                      text: "Xe 4 cho"),
                  const SizedBox(width: 4),
                  ShimmerUtils.buildShimmer(
                    child: Wrap(
                      runSpacing: 4,
                      spacing: 4,
                      children: List.generate(
                        6,
                        (index) => SvgPicture.asset(AppIcons.userFilled),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            ShimmerUtils.buildShimmerWithText(AppStyles.s14w6,
                text: "20.000.000D")
          ],
        ),
      ],
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 16,
                color: const Color(0xFF11101A).withOpacity(.1))
          ]),
      child: body,
    );
  }
}
