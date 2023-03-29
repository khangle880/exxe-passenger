// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exxe/src/data/data.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class CarNameDiver extends StatelessWidget {
  const CarNameDiver({
    Key? key,
    required this.carInfomation,
  }) : super(key: key);
  final CarInformation carInfomation;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(carInfomation.carBrand!.brandName!,
            style: AppStyles.s12w5.withColor(AppColors.gray70x76)),
        carInfomation.standardId?.standardId != null
            ? Row(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    width: 3,
                    height: 3.0,
                    decoration: const ShapeDecoration(
                      color: AppColors.gray70x76,
                      shape: CircleBorder(),
                    ),
                  ),
                  Text(
                      carInfomation.standardId!.standardName ??
                          'Chưa có biển số',
                      style: AppStyles.s12w5.withColor(AppColors.gray70x76)),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
