import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class RatingList extends StatefulWidget {
  const RatingList({Key? key, required this.star, required this.carDriverId})
      : super(key: key);
  final String? star;
  final num carDriverId;

  @override
  State<RatingList> createState() => _RatingListState();
}

class _RatingListState extends State<RatingList> {
  late PaginationHelper controller;
  late IRatingRepo repo;

  @override
  void initState() {
    super.initState();
    repo = GetIt.I();
    initController();
  }

  Future<List<RatingModel>> getRatings(PaginationConfig config) async {
    var result = await repo.getRatingDriver(
      ratingStar: widget.star,
      carDriverId: widget.carDriverId,
      limit: 20,
      offset: config.offset,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data.listRating ?? [];
      },
    );
  }

  void initController() {
    controller = PaginationHelper(
      limit: 20,
      asyncTask: (config) {
        return getRatings(config).then((data) {
          config.canLoadMore = data.length == 20;
          return (data);
        }).catchError((e) {
          log(e.toString());
          throw e;
        });
      },
    );
    controller.run();
  }

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      emptyBuilder: (_) => Center(
        child: Text(
          'Chưa có đánh giá',
          style: AppStyles.s14w6.withColor(AppColors.primaryMain),
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      loadingEffectItemBuilder: (_, __) => ItemCommentWidget.buildShimmer(),
      itemBuilder: (BuildContext context, int index) {
        final item = controller.items[index];
        return ItemCommentWidget(rating: item);
      },
      paginationController: controller,
    );
  }
}
