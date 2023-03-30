import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class DistanceInfoWidget extends StatelessWidget {
  const DistanceInfoWidget({
    Key? key,
    required this.rightInfoFirstRow,
    required this.rightInfoSecondRow,
    required this.fromAddress,
    required this.toAddress,
  }) : super(key: key);
  final String fromAddress;
  final String toAddress;

  /// right widget for first row
  final Widget rightInfoFirstRow;

  /// right widget for second row
  final Widget rightInfoSecondRow;

  /// Distance info with distance and expected goingOnDate
  factory DistanceInfoWidget.info(CompoundingCarCustomerModel carCustomer) {
    return DistanceInfoWidget.defaultAddressView(
      carCustomer: carCustomer,
      rightInfoFirstRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Khoảng cách',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          Text(
            '${carCustomer.distance!.durationFormat} km',
            style: AppStyles.s12w6.withColor(AppColors.gray90x0C),
          ),
        ],
      ),
      rightInfoSecondRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Thời gian dự kiến',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          Text(
            carCustomer.duration!.getTimeFromHours,
            style: AppStyles.s12w6.withColor(AppColors.gray90x0C),
          ),
        ],
      ),
    );
  }

  /// Distance info with compoundingCarState
  factory DistanceInfoWidget.status(CompoundingCarCustomerModel carCustomer) {
    return DistanceInfoWidget.defaultAddressView(
      carCustomer: carCustomer,
      rightInfoFirstRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
              carCustomer.state! == CompoundingCarState.cancel
                  ? 'Loại xe'
                  : 'Số khách',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          Text(
            carCustomer.state! == CompoundingCarState.cancel
                ? carCustomer.car!.name!
                : '${carCustomer.numberSeat!.ceil()} người',
            style: AppStyles.s12w6,
          ),
        ],
      ),
      rightInfoSecondRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Loại chuyến',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          const SizedBox(height: 4),
          TypeStatusWidget.compoundingType(carCustomer.compoundingType!),
        ],
      ),
    );
  }

  /// Distance detail compounding car state is done with car name and distance
  factory DistanceInfoWidget.done(CompoundingCarCustomerModel carCustomer) {
    return DistanceInfoWidget.defaultAddressView(
      carCustomer: carCustomer,
      rightInfoFirstRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Loại xe',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          Text(
            carCustomer.car!.name!,
            style: AppStyles.s12w6,
          ),
        ],
      ),
      rightInfoSecondRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Khoảng cách',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          const SizedBox(height: 4),
          Text(
            "${carCustomer.distance} km",
            style: AppStyles.s12w6,
          ),
        ],
      ),
    );
  }

  /// Distance detail with price and compoundingType
  factory DistanceInfoWidget.transaction(
      CompoundingCarCustomerModel carCustomer) {
    return DistanceInfoWidget.defaultAddressView(
      carCustomer: carCustomer,
      rightInfoFirstRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Giá tiền',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          Text(
            ((carCustomer.priceUnit?.priceUnit ?? carCustomer.amountTotal)
                    ?.ceil()
                    .currencyFormat)
                .safeText,
            style: AppStyles.s14w7.withColor(AppColors.utilRed),
          ),
        ],
      ),
      rightInfoSecondRow: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Loại chuyến',
              style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
          const SizedBox(height: 4),
          if (carCustomer.compoundingType != null)
            TypeStatusWidget.compoundingType(carCustomer.compoundingType!),
        ],
      ),
    );
  }

  factory DistanceInfoWidget.defaultAddressView(
      {required CompoundingCarCustomerModel carCustomer,
      required Widget rightInfoFirstRow,
      required Widget rightInfoSecondRow}) {
    return DistanceInfoWidget(
      rightInfoFirstRow: rightInfoFirstRow,
      rightInfoSecondRow: rightInfoSecondRow,
      fromAddress: carCustomer.fromAddressShow.safeText,
      toAddress: carCustomer.toAddressShow.safeText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 11,
          bottom: 32,
          top: 30,
          child: DashedLineVertical(
            color:
                AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.8),
            width: 2,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  AppIcons.circleBorder,
                  height: 24,
                  width: 24,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Điểm đón",
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d),
                      ),
                      Text(
                        fromAddress,
                        style: AppStyles.s16w6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                rightInfoFirstRow,
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(AppIcons.location,
                      height: 16, width: 16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Điểm đến",
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d),
                      ),
                      Text(
                        toAddress,
                        style: AppStyles.s16w6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                rightInfoSecondRow,
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class DistancePickStation extends StatelessWidget {
  const DistancePickStation(
      {Key? key,
      required this.onTapFromProvinceName,
      required this.onTapToProvinceName,
      required this.pickupPoint,
      required this.destinationPoint,
      this.pickupAddress})
      : super(key: key);

  final Function() onTapFromProvinceName;
  final Function() onTapToProvinceName;
  final LocationModel pickupPoint;
  final LocationModel destinationPoint;
  final String? pickupAddress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 11,
          bottom: 30,
          top: 30,
          child: DashedLineVertical(
            color:
                AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.8),
            width: 2,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SvgPicture.asset(AppIcons.circleBorder),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pickupAddress ??
                            pickupPoint.station?.stationName ??
                            "Chọn trạm đón",
                        style: AppStyles.s16w6,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        pickupPoint.province?.provinceName ??
                            'Chọn tỉnh Thành phố',
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(AppIcons.edit),
                ),
              ],
            ).inkWell(
              onTap: onTapFromProvinceName,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    AppIcons.location,
                    height: 16,
                    width: 16,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destinationPoint.station?.stationName ??
                            "Chọn trạm đến",
                        style: AppStyles.s16w6,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        destinationPoint.province?.provinceName ??
                            'Chọn tỉnh Thành phố',
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset(AppIcons.edit),
                ),
              ],
            ).inkWell(
              onTap: onTapToProvinceName,
            ),
          ],
        ),
      ],
    );
  }
}
