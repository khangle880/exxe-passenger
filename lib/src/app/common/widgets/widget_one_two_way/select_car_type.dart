import 'package:exxe/src/utils/export/ui_export.dart';

class TypeCarTrip extends StatelessWidget {
  final Function() onTapTypeCar;
  final carType;
  final price;
  final bool isDisable;

  const TypeCarTrip(
      {Key? key,
      required this.onTapTypeCar,
      required this.carType,
      required this.price,
      required this.isDisable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isDisable
        ? Container(
            padding: const EdgeInsets.all(12),
            alignment: Alignment.centerLeft,
            height: 48,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.gray10,
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidget(
                    text: carType,
                    weight: FontWeight.w400,
                    fontSize: AppDimens.text14,
                    colorText: AppColors.gray60,
                  ),
                ),
                Text(
                  price,
                  style: AppStyles.s14w4.withColor(AppColors.gray60),
                ),
                const SizedBox(
                  width: 9,
                ),
                const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: 16,
                )
              ],
            ),
          )
        : GestureDetector(
            onTap: onTapTypeCar,
            child: Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerLeft,
              height: 48,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: AppColors.textLight,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextWidget(
                      text: carType,
                      weight: FontWeight.w400,
                      fontSize: AppDimens.text14,
                      colorText: AppColors.gray95,
                    ),
                  ),
                  Text(
                    price,
                    style: AppStyles.s14w4,
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 16,
                  )
                ],
              ),
            ),
          );
  }
}
