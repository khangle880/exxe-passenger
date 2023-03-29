import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'pagination_helper.dart';

///only used for vertical ListView
class PaginationListView extends StatefulWidget {
  ///your BLOC must be used this mixin [PaginationHelper]

  ///pass into if you want to control another things exclude pagination
  final ScrollController? scrollController;

  final PaginationHelper paginationController;

  ///build your main item
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;

  ///pass into if you don't wanna use the default loading indicator [VueCircularProgressIndicator]
  final WidgetBuilder? loadingIndicatorBuilder;

  // no item builder
  final WidgetBuilder? emptyBuilder;

  ///have to pass into if [showInitialLoadingEffectItem] is true
  final IndexedWidgetBuilder? loadingEffectItemBuilder;

  final int loadingEffectItemCount;

  final double listPaddingStartAndEnd;

  final Axis scrollDirection;

  final double itemPercentBeforeLoadMore;

  final EdgeInsetsGeometry? padding;

  final bool? reverse;

  final bool? enableRefresh;

  /// get length of list
  final int Function()? length;

  // ignore: use_key_in_widget_constructors
  const PaginationListView({
    required this.itemBuilder,
    required this.paginationController,
    this.reverse,
    this.enableRefresh,
    this.separatorBuilder,
    this.scrollController,
    this.loadingIndicatorBuilder,
    this.loadingEffectItemBuilder,
    this.loadingEffectItemCount = 10,
    this.listPaddingStartAndEnd = 0,
    this.scrollDirection = Axis.vertical,
    this.itemPercentBeforeLoadMore = 30,
    this.emptyBuilder,
    this.padding,
    this.length,
  });

  @override
  PaginationListViewState createState() => PaginationListViewState();
}

class PaginationListViewState extends State<PaginationListView> {
  late ScrollController _scrollController;
  late Function onUpdate;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    widget.paginationController.addListener(pagingListen);
  }

  pagingListen() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant PaginationListView oldWidget) {
    if (oldWidget.paginationController != widget.paginationController) {
      widget.paginationController.removeListener(pagingListen);
      widget.paginationController.addListener(pagingListen);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    widget.paginationController.removeListener(pagingListen);
    super.dispose();
  }

  Widget buildItem(int index) {
    //loading items
    if (isFirstLoad) {
      return widget.loadingEffectItemBuilder?.call(context, index) ??
          const Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          );
    }
    if ((index) < length) {
      return widget.itemBuilder.call(context, index);
    }
    if (widget.paginationController.canLoadMore) {
      return StreamBuilder<bool>(
          stream: widget.paginationController.bsIsLoading,
          builder: (context, snapshot) {
            return VisibilityDetector(
                key: GlobalKey(),
                onVisibilityChanged: (visibilityInfo) {
                  var visiblePercentage = visibilityInfo.visibleFraction * 100;
                  if (snapshot.data == false &&
                      visiblePercentage > widget.itemPercentBeforeLoadMore) {
                    widget.paginationController.run();
                  }
                },
                child: widget.loadingIndicatorBuilder?.call(context) ??
                    widget.loadingEffectItemBuilder?.call(context, index) ??
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CircularProgressIndicator(),
                    ));
          });
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVertical = widget.scrollDirection == Axis.vertical;
    return RefreshIndicator(
      notificationPredicate:
          widget.enableRefresh ?? true ? (_) => true : (_) => false,
      onRefresh: () async {
        widget.paginationController.refresh(callListener: true);
      },
      color: Theme.of(context).primaryColor,
      child: listLength == 0
          ? LayoutBuilder(
              builder: (_, constraint) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                    height: constraint.maxHeight,
                    child: (widget.emptyBuilder?.call(context)) ??
                        const SizedBox.shrink()),
              ),
            )
          : ListView.separated(
              padding: widget.padding,
              scrollDirection: widget.scrollDirection,
              controller: _scrollController,
              reverse: widget.reverse ?? false,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: isVertical
                        ? (index == 0 ? widget.listPaddingStartAndEnd : 0)
                        : 0,
                    bottom: isVertical
                        ? (index == listLength - 1
                            ? widget.listPaddingStartAndEnd
                            : 0)
                        : 0,
                    left: isVertical
                        ? 0
                        : (index == 0 ? widget.listPaddingStartAndEnd : 0),
                    right: isVertical
                        ? 0
                        : (index == listLength - 1
                            ? widget.listPaddingStartAndEnd
                            : 0),
                  ),
                  child: buildItem(index),
                );
              },
              separatorBuilder: (context, index) =>
                  widget.separatorBuilder?.call(context, index) ??
                  const SizedBox(),
              itemCount: listLength,
            ),
    );
  }

  int get listLength => isFirstLoad
      ? widget.loadingEffectItemCount
      : widget.paginationController.canLoadMore
          ? length + 1
          : length;

  bool get isFirstLoad => widget.paginationController.isFirstLoad;

  int get length =>
      widget.length?.call() ?? widget.paginationController.items.length;
}
