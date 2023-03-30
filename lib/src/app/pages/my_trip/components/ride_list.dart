import 'package:exxe/src/data/data.dart';

import '../../../../utils/export/ui_export.dart';

class RideListWidget extends StatefulWidget {
  const RideListWidget(
      {Key? key,
      required this.group,
      required this.padding,
      required this.reverse})
      : super(key: key);
  final CompoundingCarStateGroup group;
  final EdgeInsets padding;
  final bool reverse;

  @override
  State<RideListWidget> createState() => _RideListWidgetState();
}

class _RideListWidgetState extends State<RideListWidget> {
  late final CompoundingCarControllerRepo repo;
  late PaginationHelper<CompoundingCarCustomerModel> controller;
  late RemoveListener removeListener;

  @override
  void didUpdateWidget(covariant RideListWidget oldWidget) {
    if (oldWidget.reverse != widget.reverse) {
      initController();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    repo = GetIt.I();
    initController();
    initListenUserAction();
  }

  void initController() {
    controller = PaginationHelper(
      limit: 20,
      asyncTask: (config) {
        return getCompoundingCustomerCars(config).then((data) {
          config.canLoadMore = data.length == 20;
          return (data);
        }).catchError((e) {
          log(e.toString());
          config.canLoadMore = false;
          throw e;
        });
      },
    );
    controller.run();
  }

  refreshListWithoutEffect() {
    controller.refresh();
  }

  initListenUserAction() {
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction) {
        final group = widget.group;
        if (state.action == ActionStateEnum.syncTrip &&
            state.payload is CompoundingCarCustomerModel) {
          final payload = state.payload as CompoundingCarCustomerModel;
          if (group == CompoundingCarStateGroup.all ||
              group.states.contains(payload.state)) {
            refreshListWithoutEffect();
          } else {
            controller.items.removeWhere((element) =>
                element.compoundingCarCustomerId ==
                payload.compoundingCarCustomerId);
            controller.callListeners();
          }
        } else if (group == CompoundingCarStateGroup.all &&
            [
              ActionStateEnum.createRide,
              ActionStateEnum.updateRide,
              ActionStateEnum.confirmRide,
              ActionStateEnum.confirmDepositRide,
              ActionStateEnum.cancelRide,
              ActionStateEnum.deleteDraft,
            ].contains(state.action)) {
          refreshListWithoutEffect();
        } else if (state.action == ActionStateEnum.deleteDraft) {
          final payload = state.payload as CompoundingCarCustomerModel;
          controller.items.removeWhere((element) =>
              element.compoundingCarCustomerId ==
              payload.compoundingCarCustomerId);
          controller.updateList(controller.items);
          // if ([CompoundingCarStateGroup.draft].contains(group)) {
          //   refreshListWithoutEffect();
          // }
        } else if (state.action == ActionStateEnum.createRide) {
          if ([CompoundingCarStateGroup.draft].contains(group)) {
            refreshListWithoutEffect();
          }
        } else if (state.action == ActionStateEnum.updateRide) {
          if ([CompoundingCarStateGroup.draft].contains(group)) {
            refreshListWithoutEffect();
          }
        } else if (state.action == ActionStateEnum.confirmRide) {
          if ([CompoundingCarStateGroup.draft].contains(group)) {
            refreshListWithoutEffect();
          }
        } else if (state.action == ActionStateEnum.confirmDepositRide) {
          if ([
            CompoundingCarStateGroup.draft,
            CompoundingCarStateGroup.processing
          ].contains(group)) {
            refreshListWithoutEffect();
          }
        } else if (state.action == ActionStateEnum.cancelRide &&
            state.payload is CompoundingCarCustomerModel) {
          final payload = state.payload as CompoundingCarCustomerModel;
          controller.items.removeWhere((element) =>
              element.compoundingCarCustomerId ==
              payload.compoundingCarCustomerId);
          controller.updateList(controller.items);
          // if ([CompoundingCarStateGroup.cancel].contains(group)) {
          //   refreshListWithoutEffect();
          // }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    removeListener();
  }

  Future<List<CompoundingCarCustomerModel>> getCompoundingCustomerCars(
      PaginationConfig config) async {
    var result = await repo.getHistoryCompoundingCarCustomer(
      offset: config.offset,
      states: widget.group.states,
      reverse: widget.reverse,
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

  void _onTap(CompoundingCarCustomerModel item) {
    Navigator.pushNamed(context, Routes.tripDetail, arguments: item);
  }

  @override
  Widget build(BuildContext context) {
    return PaginationListView(
      padding: widget.padding,
      emptyBuilder: (_) => Center(
        child: Text('Không có chuyến phù hợp', style: AppStyles.s16w6),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      loadingEffectItemBuilder: (_, index) => TripDistanceDetail.shimmer(),
      length: () => controller.canShowItems.length,
      itemBuilder: (BuildContext context, int index) {
        final item = controller.canShowItems[index];
        return GestureDetector(
          onTap: () => _onTap(item),
          child: _buildItem(item),
        );
      },
      paginationController: controller,
    );
  }

  _buildItem(CompoundingCarCustomerModel item) {
    return TripDistanceDetail.activityItem(item);
  }
}
