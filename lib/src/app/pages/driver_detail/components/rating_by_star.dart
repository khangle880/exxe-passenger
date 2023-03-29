// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:exxe/src/data/models/car/car_driver_model.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../common/widgets/widgets.dart';
import 'rating_list.dart';

class CommentCustomer extends StatefulWidget {
  const CommentCustomer({
    Key? key,
    this.rating,
    required this.partnerId,
  }) : super(key: key);
  final List<RatingModel>? rating;
  final num partnerId;

  @override
  State<CommentCustomer> createState() => _CommentCustomerState();
}

class _CommentCustomerState extends State<CommentCustomer> {
  late ScrollController _scrollController;
  int? chooseRatingStarIndex;
  List<RatingModel>? listRatingChange;
  late final PageController _pageController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: 0, keepPage: true);
    listRatingChange = widget.rating;
    chooseRatingStarIndex = 0;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i <= 5; i++) _buildItemStar(i),
          ],
        ),
        Expanded(
          child: _buildPages(),
        ),
      ],
    );
  }

  Widget _buildPages() {
    return PageView(
      onPageChanged: (page) {
        setState(() {
          chooseRatingStarIndex = page;
        });
      },
      controller: _pageController,
      children: List.generate(
        6,
        (index) => KeepAlivePage(
          child: RatingList(
            star: index == 0 ? null : index.toString(),
            carDriverId: widget.partnerId,
          ),
        ),
      ),
    );
  }

  Widget _buildItemStar(int star) {
    return GestureDetector(
      onTap: () {
        _pageController.jumpToPage(star);
        setState(() {
          chooseRatingStarIndex = star;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: chooseRatingStarIndex == star
              ? AppColors.accBlueMain
              : AppColors.primaryButton.withAlpha(20),
          borderRadius: AppStyles.border15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextWidget(
              text: star == 0 ? '' : '$star ',
              fontSize: 12,
              colorText: chooseRatingStarIndex == star
                  ? AppColors.primaryLight
                  : AppColors.primaryTextButton,
            ),
            const Icon(Icons.star, color: AppColors.marigoldd40, size: 12),
          ],
        ),
      ),
    );
  }
}
