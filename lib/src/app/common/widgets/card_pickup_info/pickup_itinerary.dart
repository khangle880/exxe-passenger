import 'package:exxe/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../config/config.dart';
import '../../../../data/data.dart';
import '../dash_line_horizontal.dart';

class PickupItineraryCard extends StatelessWidget {
  const PickupItineraryCard({
    Key? key,
    this.pickupPoint,
    this.destinationPoint,
    required this.onClickedPickupGoingOn,
    required this.onClickedDestinationPoint,
  }) : super(key: key);

  final LocationModel? pickupPoint;
  final LocationModel? destinationPoint;

  /// handle result of search pickup point
  final Function() onClickedPickupGoingOn;

  /// handle result of search destination point
  final Function() onClickedDestinationPoint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 144,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.gray10, spreadRadius: 1, blurRadius: 1)
        ],
      ),
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                border: Border.all(
                    color: AppColors.gray70x76.withAlpha(50), width: 0.5),
                borderRadius: AppStyles.border15,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 1.0,
                      heightFactor: 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            AppIcons.circleBorder,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Container(
                                    width: 2.5,
                                    height: i == 1 || i == 5 ? 5 : 9,
                                    color:
                                        AppColors.primaryMain.withOpacity(0.5),
                                  )
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            AppIcons.locationFillPurple,
                          ),
                        ],
                      ),
                    ),
                  ), // goingOnTitle: ,
                  // destinationTitle: ,
                  // goingOnSubText: goingOnSubText ?? ,
                  Expanded(
                    flex: 8,
                    child: FractionallySizedBox(
                      heightFactor: 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PickLocationField(
                            title: 'Điểm đón',
                            hintText: "Chọn Tỉnh / Thành phố",
                            subTitle: pickupPoint?.province?.provinceName,
                            callback: onClickedPickupGoingOn,
                          ),
                          const Expanded(
                            child: FractionallySizedBox(
                              widthFactor: 1.0,
                              heightFactor: 0.3,
                              child: DashedLineHorizontal(),
                            ),
                          ),
                          PickLocationField(
                            title: 'Điểm đến',
                            hintText: "Chọn Tỉnh / Thành phố",
                            subTitle: destinationPoint?.province?.provinceName,
                            callback: onClickedDestinationPoint,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PickLocationField extends StatelessWidget {
  const PickLocationField({
    Key? key,
    required this.title,
    this.subTitle,
    required this.callback,
    required this.hintText,
  }) : super(key: key);
  final String title;
  final String? subTitle;
  final String hintText;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppStyles.s16w7,
              ),
              const SizedBox(height: 5),
              Text(
                subTitle ?? hintText,
                style: AppStyles.s14w4.withColor(subTitle == null
                    ? AppColors.gray50
                    : AppColors.gray70x76),
              ),
            ],
          ),
        ),
        // if (subTitle != null)
        //   SvgPicture.asset(
        //     AppIcons.edit,
        //   ),
      ],
    ).inkWell(
      onTap: callback
    );
  }
}
