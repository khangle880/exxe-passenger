import 'package:exxe/src/data/models/car/car_driver_model.dart';
import 'package:exxe/src/data/models/rating/rating_hashtag_model.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class ItemCommentWidget extends StatelessWidget {
  const ItemCommentWidget({Key? key, required this.rating}) : super(key: key);
  final RatingModel rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomNetworkImage(
                host: Apis.baseUrl,
                url: rating.partner!.avatarUrl!.imageUrl,
                size: 40,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rating.partner!.partnerName ?? 'No Name',
                      style: AppStyles.s14w6),
                  const SizedBox(height: 2),
                  ListStarRatingWidget(
                    currentStar: rating.ratingNumber!.toDouble(),
                    size: 15.0,
                    itemPadding: const EdgeInsets.only(
                      right: 5.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        if ((rating.ratingContent ?? "").isNotEmpty)
          Text(
            rating.ratingContent == null ? '' : rating.ratingContent!.trim(),
            style: AppStyles.s16w5.withColor(AppColors.gray70x76),
          ),
        rating.ratingHashtagModel != null
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: _buildHashTag(rating.ratingHashtagModel!),
              )
            : const SizedBox(),
        DashedLineHorizontal(
          height: 1,
          color: AppColors.gray70x76.withAlpha(100),
        ),
      ],
    );
  }

  Wrap _buildHashTag(List<RatingHashtagModel> hasTags) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (int i = 0; i < hasTags.length; i++)
          ChoiceChipWidget(
            child: Text(
              hasTags[i].tagContent!,
              style: AppStyles.s12w5.withColor(AppColors.primaryTextButton),
              maxLines: 2,
            ),
          )
      ],
    );
  }

  static buildShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ShimmerUtils.buildShimmer(
                height: 40,
                width: 40,
                borderRadius: 100,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerUtils.buildShimmerWithText(AppStyles.s14w6,
                      text: 'No Name'),
                  const SizedBox(height: 2),
                  ShimmerUtils.buildShimmer(
                    child: const ListStarRatingWidget(
                      currentStar: 5,
                      size: 15.0,
                      itemPadding: EdgeInsets.only(
                        right: 5.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        ShimmerUtils.buildShimmerWithText(AppStyles.s16w5,
            text: 'rating.ratingContent content'),
        const DashedLineHorizontal(),
      ],
    );
  }
}
