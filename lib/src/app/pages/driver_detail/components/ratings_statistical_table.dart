// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exxe/src/data/models/car/car_driver_model.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class RatingStatisticalTable extends StatelessWidget {
  const RatingStatisticalTable({
    Key? key,
    required this.driver,
  }) : super(key: key);
  final CarDriverModel driver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: 'Nhận xét và đánh giá',
          fontSize: 18.0,
          weight: FontWeight.w700,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildColumLeft(driver.ratingNumber!.toDouble(),
                  driver.ratingCount?.ceil() ?? 0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      _buildNumberRating(5),
                      const SizedBox(height: 10),
                      _buildNumberRating(4),
                      const SizedBox(height: 10),
                      _buildNumberRating(3),
                      const SizedBox(height: 10),
                      _buildNumberRating(2),
                      const SizedBox(height: 10),
                      _buildNumberRating(1),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextWidget(
                        text: '${driver.rating5StarCount} đánh giá',
                        fontSize: 12,
                        colorText: AppColors.gray70x76,
                      ),
                      const SizedBox(height: 10),
                      TextWidget(
                        text: '${driver.rating4StarCount} đánh giá',
                        fontSize: 12,
                        colorText: AppColors.gray70x76,
                      ),
                      const SizedBox(height: 10),
                      TextWidget(
                        text: '${driver.rating3StarCount} đánh giá',
                        fontSize: 12,
                        colorText: AppColors.gray70x76,
                      ),
                      const SizedBox(height: 10),
                      TextWidget(
                        text: '${driver.rating2StarCount} đánh giá',
                        fontSize: 12,
                        colorText: AppColors.gray70x76,
                      ),
                      const SizedBox(height: 10),
                      TextWidget(
                        text: '${driver.rating1StarCount} đánh giá',
                        fontSize: 12,
                        colorText: AppColors.gray70x76,
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberRating(int number) {
    return ListStarRatingWidget(
      currentStar: number.toDouble(),
      size: 15.0,
      itemPadding: const EdgeInsets.symmetric(
        horizontal: 3.0,
      ),
    );
  }

  Widget _buildColumLeft(double ratingNumber, int reviews) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextWidget(
                text: '$ratingNumber/5',
                fontSize: 20.0,
                colorText: AppColors.primaryButton,
                weight: FontWeight.w600,
              ),
              TextWidget(
                text: reviews >= 900 ? '(999+)' : '($reviews)',
                fontSize: 12.0,
                colorText: AppColors.gray70x76,
              ),
            ],
          ),
          const SizedBox(height: 4),
          ListStarRatingWidget(
            currentStar: ratingNumber,
            size: 15.0,
            itemPadding: const EdgeInsets.only(
              right: 6.0,
            ),
          ),
        ],
      ),
    );
  }
}
