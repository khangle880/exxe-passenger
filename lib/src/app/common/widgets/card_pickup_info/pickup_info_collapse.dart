import 'package:exxe/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import 'pickup_date.dart';

class PickupInfoCollapseCard extends StatelessWidget {
  const PickupInfoCollapseCard({
    Key? key,
    this.pickupPoint,
    this.destinationPoint,
    required this.onClickedPickupGoingOn,
    required this.onClickedDestinationPoint,
    this.selectedDate,
    required this.onSelectDate,
  }) : super(key: key);

  final LocationModel? pickupPoint;
  final LocationModel? destinationPoint;

  final DateTime? selectedDate;
  final VoidCallback? onSelectDate;

  /// handle result of search pickup point
  final Function() onClickedPickupGoingOn;

  /// handle result of search destination point
  final Function() onClickedDestinationPoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.gray10, spreadRadius: 1, blurRadius: 1)
        ],
      ),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.gray10, spreadRadius: 1, blurRadius: 1)
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppIcons.circleBorder,
                    width: 25,
                    height: 25,
                  ),
                  Expanded(
                    child: Text(
                      pickupPoint?.province?.provinceName! ?? "Điểm đón",
                      style: AppStyles.s16w4.withColor(
                          pickupPoint?.addressShow == null
                              ? AppColors.gray50
                              : AppColors.gray70x76),
                    ).inkWell(
                      onTap: onClickedPickupGoingOn,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: SvgPicture.asset(
                      AppIcons.arrow,
                      width: 25,
                      height: 25,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SvgPicture.asset(
                      AppIcons.locationFillPurple,
                      width: 25,
                      height: 25,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      destinationPoint?.province?.provinceName! ?? "Điểm đến",
                      style: AppStyles.s16w4.withColor(
                          destinationPoint?.addressShow == null
                              ? AppColors.gray50
                              : AppColors.gray70x76),
                    ).inkWell(
                      onTap: onClickedDestinationPoint,
                    ),
                  ),
                ],
              ),
            ),
          ),
          PickupDate(
            selectedDate: selectedDate,
            onSelectDate: onSelectDate,
            style: AppStyles.s16w4,
          ),
        ],
      ),
    );
  }
}
