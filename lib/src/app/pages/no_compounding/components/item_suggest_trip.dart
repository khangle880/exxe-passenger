import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';

class ItemSuggestTrip extends StatelessWidget {
  final CompoundingCarModel item;

  const ItemSuggestTrip({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 8.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 1;
                i <= (size.width - 10 - size.width * 0.15) / (8 * 2);
                i++)
              Container(
                width: 8,
                height: 1.5,
                color: AppColors.gray70x76.withAlpha(100),
              )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcons.circleBorder),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (int i = 1; i <= 2; i++)
                            Container(
                              width: 2,
                              height: 7,
                              decoration: BoxDecoration(
                                color: AppColors.primaryButton.withAlpha(100),
                                borderRadius: AppStyles.border15,
                              ),
                            )
                        ],
                      ),
                    ),
                    SvgPicture.asset(AppIcons.locationFillPurple),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.fromProvince!.provinceShortName!,
                            style: AppStyles.s14w7),
                        const Spacer(),
                        Text(item.toProvince!.provinceShortName!,
                            style: AppStyles.s14w7)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextWidget(
                            text: 'Khoảng cách',
                            fontSize: AppDimens.text12,
                            colorText: AppColors.gray70x76.withAlpha(150),
                          ),
                          Text('${item.distance} km', style: AppStyles.s12w6),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextWidget(
                            text: 'Thời gian dự kiến',
                            fontSize: AppDimens.text12,
                            colorText: AppColors.gray70x76.withAlpha(150),
                          ),
                          Text(
                            item.expectedGoingOnDate!
                                .toFormat('HH:mm - dd.MM.yyyy'),
                            style: AppStyles.s12w6,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(AppIcons.car),
                  const SizedBox(width: 10),
                  Text("${item.numberSeatInCar} chỗ", style: AppStyles.s12w6)
                ],
              ),
            ),
            Text(
              item.priceUnit!.priceUnit!.ceil().currencyFormat,
              style: AppStyles.s12w7.copyWith(color: AppColors.utilRed),
            ),
          ],
        ),
      ],
    ).gestureDetector(onTap: () {
      Navigator.pushNamed(context, Routes.joinConvenientTripDetail, arguments: {
        'compoundingCar': item,
      });
    });
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.calendar,
              color: AppColors.primaryButton,
              width: 15.0,
              height: 15.0,
            ),
            FittedBox(
              child: TextWidget(
                text:
                    "${item.expectedGoingOnDate?.toFormat('HH:mm dd.MM.yyyy')}",
                colorText: AppColors.primaryButton,
                fontSize: AppDimens.text12,
              ),
            ),
          ],
        ),
        FittedBox(
          child: TypeStatusWidget.compoundingType(CompoundingType.convenient),
        )
      ],
    );
  }
}
