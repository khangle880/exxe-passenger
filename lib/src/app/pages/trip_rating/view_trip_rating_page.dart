import 'package:exxe/src/app/pages/trip_rating/components/list_hashtag.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../data/data.dart';

// ignore: must_be_immutable
class ViewTripRatingPage extends StatefulWidget {
  final CompoundingCarCustomerModel carCustomer;

  const ViewTripRatingPage({Key? key, required this.carCustomer})
      : super(key: key);

  @override
  State<ViewTripRatingPage> createState() => _ViewTripRatingPageState();
}

class _ViewTripRatingPageState extends State<ViewTripRatingPage> {
  final ValueNotifier<int> currentStar = ValueNotifier(5);

  List<int> listChoiceHashtagIds = [];

  @override
  void dispose() {
    currentStar.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.gray05,
          title: 'Đánh giá chuyến đi',
          context: context,
          fontSizeTitle: 18.0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAvatar(),
              buildTitle(),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: ListStarRatingWidget(
                  currentStar:
                      widget.carCustomer.rating!.ratingNumber!.toDouble(),
                  size: 50.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 3.0),
                ),
              ),
              widget.carCustomer.rating!.ratingTagIds != null
                  ? ListHashTag(
                      hasTags: widget.carCustomer.rating!.ratingTagIds!,
                      onClick: (int id) {},
                      currentList: listChoiceHashtagIds,
                    )
                  : const SizedBox(),
              if ((widget.carCustomer.rating?.ratingContent ?? '')
                  .isNotEmpty) ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Đánh giá của bạn',
                    style: AppStyles.s16w6,
                  ),
                ),
                Text(
                  widget.carCustomer.rating!.ratingContent ?? "",
                  style: AppStyles.s14w4.withColor(AppColors.primaryDark),
                ),
              ]
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin:
              const EdgeInsets.only(bottom: 24, left: 24, right: 24, top: 16),
          child: ButtonWidgetOld(
            radius: 10.0,
            onClick: () {
              Navigator.pop(context);
            },
            backgroundColor: AppColors.primaryButton,
            child: Text(
              'Quay lại',
              style: AppStyles.s16w6.withColor(AppColors.primaryLight),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAvatar() => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: widget.carCustomer.carDriverId?.avatarUrl?.imageUrl != null
              ? Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.primaryLight.withOpacity(0.6) +
                            AppColors.primaryMain),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: CustomNetworkImage(
                    size: 100,
                    decoration: const BoxDecoration(
                      color: AppColors.gray20,
                      shape: BoxShape.circle,
                    ),
                    host: Apis.baseUrl,
                    url: widget.carCustomer.carDriverId!.avatarUrl!.imageUrl!,
                  ),
                )
              : SvgPicture.asset(
                  AppIcons.user,
                  width: 100,
                  height: 100,
                ),
        ),
      );

  Widget buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: FittedBox(
            child: TextWidget(
              text: 'Cảm ơn bạn đã đánh giá chuyến đi',
              fontSize: 18,
              weight: FontWeight.w700,
              textAlign: TextAlign.center,
              maxLine: 2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: TextWidget(
            text:
                'Cảm ơn bạn đã cho chúng tôi biết trải nghiệm với EXXE bằng cách đánh giá cuốc xe này.',
            fontSize: 14,
            colorText: AppColors.gray70x76,
            textAlign: TextAlign.center,
            maxLine: 3,
          ),
        ),
      ],
    );
  }
}
