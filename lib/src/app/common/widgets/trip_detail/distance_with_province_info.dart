import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class DistanceWithProvinceInfo extends StatelessWidget {
  const DistanceWithProvinceInfo(
    this.compoundingCar, {
    Key? key,
  }) : super(key: key);
  final CompoundingCarCustomerModel compoundingCar;

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
                        compoundingCar.fromAddressShow.safeText,
                        style: AppStyles.s16w6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        compoundingCar.fromProvince!.provinceName.safeText,
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Khoảng cách',
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
                    Text(
                      '${compoundingCar.distance!} km',
                      style: AppStyles.s12w6.withColor(AppColors.gray90x0C),
                    ),
                  ],
                )
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
                        compoundingCar.toAddressShow.safeText,
                        style: AppStyles.s16w6,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        compoundingCar.toProvince!.provinceName.safeText,
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Thời gian dự kiến',
                        style: AppStyles.s12w4.withColor(AppColors.gray60x9d)),
                    Text(
                      compoundingCar.duration!.getTimeFromHours,
                      style: AppStyles.s12w6.withColor(AppColors.gray90x0C),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
