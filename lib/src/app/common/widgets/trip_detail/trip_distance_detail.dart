import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class TripDistanceDetail extends StatelessWidget {
  const TripDistanceDetail({
    super.key,
    required this.leftTitle,
    required this.rightTitle,
    required this.customer,
    this.hasSeparate = false,
    this.hasCover = false,
    this.distanceAbove = false,
    required this.distanceInfo,
    this.separateHeight,
    this.bottomMore,
  });

  final CompoundingCarCustomerModel customer;
  final Widget leftTitle;
  final Widget rightTitle;

  /// Dashed line between two section
  final bool hasSeparate;

  /// Vertical padding of separate dashedLine
  final double? separateHeight;

  /// Container padding
  final bool hasCover;

  final DistanceInfoWidget distanceInfo;

  /// Distance above top of separate
  final bool distanceAbove;

  final Widget? bottomMore;

  /// Distance detail of ride - normal
  factory TripDistanceDetail.info(
      {required Widget title, required CompoundingCarCustomerModel customer}) {
    return TripDistanceDetail(
      leftTitle: title,
      rightTitle: TypeStatusWidget.compoundingType(customer.compoundingType!),
      customer: customer,
      distanceInfo: DistanceInfoWidget.info(customer),
    );
  }

  /// distance detail of ride with compoundingCarState
  factory TripDistanceDetail.status(CompoundingCarCustomerModel customer) {
    return TripDistanceDetail(
      hasCover: true,
      hasSeparate: true,
      leftTitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppIcons.calendar,
              height: 16, width: 16, color: AppColors.primaryMain),
          const SizedBox(width: 4),
          Text(
            customer.expectedGoingOnDate!.getDateTimeString,
            style: AppStyles.s12w6.withColor(AppColors.primaryMain),
          ),
        ],
      ),
      rightTitle: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: customer.state!.colorByState),
        ),
        child: Text(
          customer.state!.name,
          style: AppStyles.s14w6.withColor(customer.state!.colorByState),
        ),
      ),
      customer: customer,
      distanceInfo: DistanceInfoWidget.status(customer),
    );
  }

  /// distance detail of ride in activity tab
  factory TripDistanceDetail.activityItem(
      CompoundingCarCustomerModel customer) {
    return TripDistanceDetail(
      hasCover: true,
      hasSeparate: true,
      leftTitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(AppIcons.calendar,
              height: 16, width: 16, color: AppColors.primaryMain),
          const SizedBox(width: 4),
          Text(
            customer.expectedGoingOnDate!.getDateTimeString,
            style: AppStyles.s12w6.withColor(AppColors.primaryMain),
          ),
        ],
      ),
      rightTitle: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: customer.state!.colorByState),
        ),
        child: Text(
          customer.state!.name,
          style: AppStyles.s14w6.withColor(customer.state!.colorByState),
        ),
      ),
      customer: customer,
      distanceInfo: DistanceInfoWidget.transaction(customer),
    );
  }

  /// distance detail of ride with compoundingCarState in bottom (transaction view)
  factory TripDistanceDetail.transaction(CompoundingCarCustomerModel customer) {
    return TripDistanceDetail(
      hasCover: true,
      distanceAbove: true,
      hasSeparate: true,
      separateHeight: 12,
      leftTitle: Text(
        "#${customer.compoundingCarCustomerCode!}",
        style: AppStyles.s14w6.withColor(AppColors.gray70x76),
      ),
      rightTitle: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: customer.state!.colorByState),
        ),
        child: Text(
          customer.state!.name,
          style: AppStyles.s14w6.withColor(customer.state!.colorByState),
        ),
      ),
      customer: customer,
      distanceInfo: DistanceInfoWidget.transaction(customer),
    );
  }

  static shimmer() {
    return const TripDistanceShimmer();
  }

  // activity
  @override
  Widget build(BuildContext context) {
    final header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftTitle,
        rightTitle,
      ],
    );
    final separate = Padding(
      padding: EdgeInsets.symmetric(vertical: separateHeight ?? 8),
      child: const DashedLineHorizontal(color: AppColors.gray20),
    );
    final body = distanceAbove
        ? Column(
            children: [
              distanceInfo,
              hasSeparate ? separate : const SizedBox(height: 14),
              header,
              if (bottomMore != null) bottomMore!,
            ],
          )
        : Column(
            children: [
              header,
              hasSeparate ? separate : const SizedBox(height: 14),
              distanceInfo,
              if (bottomMore != null) bottomMore!,
            ],
          );

    if (hasCover) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 7,
                spreadRadius: -2,
                color: AppColors.primaryLight.withOpacity(0.05)),
            BoxShadow(
                offset: const Offset(0, 10),
                blurRadius: 15,
                spreadRadius: -3,
                color: const Color(0xFFCACACA).withOpacity(0.1))
          ],
        ),
        child: body,
      );
    } else {
      return body;
    }
  }
}

class TripDistanceShimmer extends StatelessWidget {
  const TripDistanceShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 1),
              blurRadius: 7,
              spreadRadius: -2,
              color: AppColors.primaryLight.withOpacity(0.05)),
          BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 15,
              spreadRadius: -3,
              color: const Color(0xFFCACACA).withOpacity(0.1))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShimmerUtils.buildShimmer(height: 16, width: 16),
                  const SizedBox(width: 4),
                  ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                      text: "hh:mm - dd.MM.yyyy"),
                ],
              ),
              ShimmerUtils.buildShimmerWithText(AppStyles.s14w6,
                  text: "da dat coc",
                  addMore: const Size(8, 4),
                  borderRadius: 5)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ShimmerUtils.buildShimmer(
              child: const DashedLineHorizontal(color: AppColors.gray20),
            ),
          ),
          Stack(
            children: [
              Positioned(
                left: 11,
                bottom: 32,
                top: 30,
                child: ShimmerUtils.buildShimmer(
                  child: SizedBox(
                    height: 10,
                    child: DashedLineVertical(
                      color: AppColors.primaryMain +
                          AppColors.primaryLight.withOpacity(0.8),
                      width: 2,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ShimmerUtils.buildShimmer(
                        child: SvgPicture.asset(AppIcons.circleBorder),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerUtils.buildShimmerWithText(
                              AppStyles.s12w4,
                              text: "Điểm đón",
                            ),
                            const SizedBox(height: 4),
                            ShimmerUtils.buildShimmerWithText(
                              AppStyles.s16w6,
                              text: "Điểm đón Điểm đón Điểm đón",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                              text: 'Số khách'),
                          const SizedBox(height: 4),
                          ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                              text: '10 nguoi'),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ShimmerUtils.buildShimmer(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: SvgPicture.asset(AppIcons.location,
                              height: 16, width: 16),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerUtils.buildShimmerWithText(
                              AppStyles.s12w4,
                              text: "Điểm đến",
                            ),
                            const SizedBox(height: 4),
                            ShimmerUtils.buildShimmerWithText(AppStyles.s16w6,
                                text: "Điểm đến Điểm đến Điểm đến"),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ShimmerUtils.buildShimmerWithText(
                            AppStyles.s12w4,
                            text: 'Loại chuyến',
                          ),
                          const SizedBox(height: 4),
                          ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                              text: "Ghep chuyen",
                              addMore: const Size(24, 8),
                              borderRadius: 8),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
