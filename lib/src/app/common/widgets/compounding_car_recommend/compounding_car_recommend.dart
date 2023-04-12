import 'package:exxe/src/utils/export/logic_export.dart';
import '../../../../utils/export/ui_export.dart';

class CompoundingCarRecommend extends StatefulWidget {
  const CompoundingCarRecommend({
    Key? key,
    this.isShowFilter = false,
    this.from,
    this.to,
    this.goingOnTime,
    this.padding = const EdgeInsets.all(0),
    this.externalScrollController,
    required this.type,
    required this.onItemSelected,
    this.carId,
    this.fromExpectedGoingOnDate,
    this.toExpectedGoingOnDate,
  }) : super(key: key);
  final bool isShowFilter;
  final LocationModel? from;
  final LocationModel? to;
  final DateTime? goingOnTime;
  final num? carId;
  final DateTime? fromExpectedGoingOnDate;
  final DateTime? toExpectedGoingOnDate;
  final EdgeInsets padding;
  final ScrollController? externalScrollController;
  final CompoundingType type;
  final Function(CompoundingCarModel compoundingCarModel) onItemSelected;

  @override
  State<CompoundingCarRecommend> createState() =>
      _CompoundingCarRecommendState();
}

class _CompoundingCarRecommendState extends State<CompoundingCarRecommend> {
  late final ICompoundingCarCtrlRepo repo;
  late PaginationHelper controller;

  //Tabbar
  int selectedIndex = 2;
  Color enableColor = AppColors.primaryButton;
  Color disableColor = AppColors.gray60;

  @override
  void initState() {
    super.initState();
    repo = GetIt.I<CompoundingCarControllerRepo>();
    initController();
  }

  @override
  void didUpdateWidget(covariant CompoundingCarRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    initController();
  }

  void initController() {
    controller = PaginationHelper<CompoundingCarModel>(
      limit: 20,
      asyncTask: (config) {
        return getRecommendCompoundingCars(config).then((data) {
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

  Future<List<CompoundingCarModel>> getRecommendCompoundingCars(
      PaginationConfig config) async {
    var result = await repo.getCompoundingCarAvailable(
      offset: config.offset,
      type: widget.type,
      fromProvinceId: widget.from?.provinceId,
      toProvinceId: widget.to?.provinceId,
      carId: widget.carId,
      fromExpectedGoingOnDate: widget.fromExpectedGoingOnDate,
      toExpectedGoingOnDate:
          widget.toExpectedGoingOnDate ?? widget.fromExpectedGoingOnDate,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: widget.padding,
          height: 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Chuyến đi gợi ý",
                style: AppStyles.s16w7.copyWith(
                  color:
                      AppColors.primaryMain + AppColors.black.withOpacity(0.8),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                    log("index colors $selectedIndex");
                  });
                },
                child: SvgPicture.asset(
                  AppIcons.appCircle,
                  width: 24,
                  height: 24,
                  color: selectedIndex == 1 ? enableColor : disableColor,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                    log("index colors $selectedIndex");
                  });
                },
                child: SvgPicture.asset(
                  AppIcons.appRectangle,
                  width: 24,
                  height: 24,
                  color: selectedIndex == 2 ? enableColor : disableColor,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: SvgPicture.asset(
                  AppIcons.filter06,
                  width: 24,
                  height: 24,
                  color: disableColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: selectedIndex == 1
              ? PaginationGridView(
                  scrollController: widget.externalScrollController,
                  padding: widget.padding.copyWith(bottom: 50),
                  emptyBuilder: (_) => Center(
                    child:
                        Text('Không có chuyến phù hợp', style: AppStyles.s16w6),
                  ),
                  loadingEffectItemCount: 8,
                  loadingIndicatorBuilder: (_) =>
                      const RecommendGridItemShimmer(),
                  length: () => controller.canShowItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = controller.canShowItems[index];
                    return RecommendGridItem(
                      compoundingCar: item,
                      onItemSelected: widget.onItemSelected,
                    );
                  },
                  paginationController: controller,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  itemHeight: 210,
                )
              : PaginationListView(
                  scrollController: widget.externalScrollController,
                  padding: widget.padding.copyWith(bottom: 50),
                  emptyBuilder: (_) => Center(
                    child:
                        Text('Không có chuyến phù hợp', style: AppStyles.s16w6),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  loadingEffectItemBuilder: (_, __) =>
                      const RecommendListItemShimmer(),
                  length: () => controller.canShowItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = controller.canShowItems[index];
                    return RecommendListItem(
                      compoundingCar: item,
                      onItemSelected: widget.onItemSelected,
                    );
                  },
                  paginationController: controller,
                ),
        ),
      ],
    );
  }
}
