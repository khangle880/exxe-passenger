import 'package:exxe/src/data/models/news/news_model.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class ItemNewsWidget extends StatelessWidget {
  const ItemNewsWidget(this.data, {Key? key}) : super(key: key);

  final NewsModel data;

  static shimmer() {
    return const ItemNewsWidgetShimmer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: data.thumbnail ?? "",
            fit: BoxFit.cover,
            height: 147,
            width: double.maxFinite,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 147,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Text(
            data.title ?? "",
            style: AppStyles.s14w6,
            maxLines: 3,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.createdAt!.toFormat("dd.MM.yyyy"),
                  style: AppStyles.s10w4.withColor(AppColors.gray60x9d),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.utilRed + AppColors.primaryLightBlur,
                    ),
                    child: FittedBox(
                      child: Text(
                        data.category?.categoryName ?? "",
                        style: AppStyles.s10w4.withColor(AppColors.utilRed),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    ).inkWell(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.newsDetail,
          arguments: {
            'postId': data.postId,
          },
        );
      },
    );
  }
}

class ItemNewsWidgetShimmer extends StatelessWidget {
  const ItemNewsWidgetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 147,
                width: double.maxFinite,
                color: Colors.grey,
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: ShimmerUtils.buildShimmerWithText(AppStyles.s14w6,
                text: "tinh tuctinh tuctinh tuctinh tuctinh tuc"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ShimmerUtils.buildShimmerWithText(AppStyles.s14w6,
                text: "tinh tuctinh tuctinh"),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerUtils.buildShimmerWithText(AppStyles.s10w4,
                      text: "dd-mm-yyyy"),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ShimmerUtils.buildShimmer(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.utilRed + AppColors.primaryLightBlur,
                        ),
                        child: FittedBox(
                          child: Text(
                            "exxe do day",
                            style: AppStyles.s10w4.withColor(AppColors.utilRed),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
