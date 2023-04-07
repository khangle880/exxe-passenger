import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/models/models.dart';

class ListOptionCar extends StatelessWidget {
  const ListOptionCar({
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
    return carTypes == null
        ? Text(
            'Dữ liệu rỗng',
            style: AppStyles.s14w5.withColor(AppColors.utilRed),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: carTypes!.map((e) {
              final numberSeat = e.carId!.numberSeat ?? 0;
              return _buildItemList(
                numberSeat < 6
                    ? AppIcons.car
                    : numberSeat < 8
                        ? AppIcons.car7
                        : AppIcons.car16,
                e.carId!.name!,
                e.priceUnit!.ceil().currencyFormat,
                currentSelect == e,
              ).inkWell(
                onTap: () => onSelected(e),
              );
            }).toList(),
          );
  }

  Widget _buildItemList(
      String iconUrl, String typeCar, String traling, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryButton.withAlpha(10)
            : AppColors.primaryLight,
        borderRadius: AppStyles.border15,
        border: Border.all(
          width: 0.5,
          color: isSelected
              ? AppColors.primaryButton
              : AppColors.gray70x76.withAlpha(50),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(iconUrl),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: 'Loại xe',
                  fontSize: 14,
                  colorText: AppColors.gray70x76,
                ),
                TextWidget(
                  text: typeCar,
                  fontSize: 14,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
          TextWidget(
            text: traling,
            fontSize: 14.0,
            colorText: AppColors.primaryTextButton,
          ),
        ],
      ),
    );
  }
}
