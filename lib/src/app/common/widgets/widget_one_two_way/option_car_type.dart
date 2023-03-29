import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';

// ignore: must_be_immutable
class OptionCarType extends StatelessWidget {
  const OptionCarType({
    Key? key,
    this.carTypes,
    this.currentSelect,
    required this.onSelected,
  }) : super(key: key);
  final List<CarPriceModel>? carTypes;
  final CarPriceModel? currentSelect;
  final Function(CarPriceModel) onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ModalBottomSheet.instance.show(
          context,
          PickupCarType(
            carTypes: carTypes,
            currentSelect: currentSelect,
            onSelected: onSelected,
          ),
          backgroundColor: AppColors.greyLight,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: AppStyles.border15,
          border: Border.all(
            width: 0.5,
            color: AppColors.gray70x76.withAlpha(50),
          ),
        ),
        child: currentSelect != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLeft(currentSelect!.carId!, context),
                  Container(
                    width: 2,
                    height: 40,
                    color: AppColors.gray70x76.withAlpha(100),
                  ),
                  _buildRight(currentSelect?.priceUnit?.ceil() ?? 0)
                ],
              )
            : const SizedBox().appCenterProgressLoading,
      ),
    );
  }

  Expanded _buildRight(int price) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextWidget(
            text: 'Giá tham khảo',
            fontSize: 12,
            colorText: AppColors.gray70x76,
          ),
          const SizedBox(height: 5.0),
          TextWidget(
            text: price.currencyFormat,
            fontSize: 18,
            colorText: AppColors.textError,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Expanded _buildLeft(CarModel type, BuildContext context) {
    return Expanded(
      child: Row(
        key: key,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          type.carId == 2
              ? SvgPicture.asset(AppIcons.car)
              : type.carId == 1
                  ? SvgPicture.asset(AppIcons.car7)
                  : SvgPicture.asset(AppIcons.car16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Loại xe',
                  fontSize: 14.0,
                  colorText: AppColors.gray70x76,
                ),
                TextWidget(
                  text: type.carId == 2
                      ? 'XE 5 CHỖ'
                      : type.carId == 1
                          ? 'XE 7 CHỖ'
                          : 'XE 16 CHỖ',
                  fontSize: AppDimens.text14,
                  weight: FontWeight.w600,
                )
              ],
            ),
          ),
          SvgPicture.asset(AppIcons.directionDown)
        ],
      ),
    );
  }
}
