import '../../../../../data/models/models.dart';
import '../../../../../utils/export/ui_export.dart';

class SuggestRideItem extends StatelessWidget {
  const SuggestRideItem({Key? key, required this.compoundingCar})
      : super(key: key);
  final CompoundingCarModel compoundingCar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 8,
                color: const Color(0xFF11101A).withOpacity(.1))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImage(),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: _buildInformationNameWay(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildInformationPriceTypeCar(),
          ),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TypeStatusWidget.compoundingType(
                compoundingCar.compoundingType == CompoundingType.convenient
                    ? CompoundingType.convenient
                    : CompoundingType.compounding,
              ),
              ButtonWidget(
                width: 65,
                height: 28,
                radius: 8,
                backgroundColor: AppColors.primaryLight,
                border: Border.all(color: AppColors.primaryMain),
                onClick: () {
                  Navigator.pushNamed(context, Routes.joinConvenientTripDetail,
                      arguments: {'compoundingCar': compoundingCar});
                },
                child: Text(
                  "Chọn",
                  style: AppStyles.s12w6.copyWith(color: AppColors.primaryMain),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Row _buildInformationPriceTypeCar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Còn trống',
              style: AppStyles.s11w4.withColor(AppColors.gray60x52),
            ),
            const SizedBox(height: 4),
            Text(
              "${compoundingCar.numberAvailableSeat}/${compoundingCar.numberSeatInCar}",
              style: AppStyles.s12w6.withColor(AppColors.gray90x0C),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            Text('Loại xe',
                style: AppStyles.s11w4.withColor(AppColors.gray60x52)),
            const SizedBox(height: 4),
            Text(
              (compoundingCar.car?.name?.replaceAll("XE ", "")).safeText,
              style: AppStyles.s12w6.withColor(AppColors.gray80),
            )
          ],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Chi phí',
                style: AppStyles.s11w4.withColor(AppColors.gray60x52),
              ),
              const SizedBox(height: 2),
              Text(
                (compoundingCar.priceUnit?.priceUnit?.ceil().currencyFormat)
                    .safeText,
                style: AppStyles.s14w6.withColor(AppColors.utilRed),
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInformationNameWay() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            (compoundingCar.fromProvince?.provinceShortName).safeText,
            style: AppStyles.s16w6,
            overflow: TextOverflow.ellipsis,
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
          ],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            (compoundingCar.toProvince?.provinceShortName).safeText,
            style: AppStyles.s16w6,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget _buildImage() {
    return CustomNetworkImage(
      height: 157,
      host: Apis.baseUrl,
      url: compoundingCar.toProvince?.imageUrl?.url,
      fit: BoxFit.cover,
      errorImage: SvgPicture.asset(
        AppIcons.imagePicker,
        color: AppColors.gray60,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
