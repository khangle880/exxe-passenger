import 'package:flutter/material.dart';
import 'pagination_helper.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'sliver_grid_delegate_fixed_cross_axis_count.dart';

///only used for vertical ListView
class PaginationGridView extends StatefulWidget {
  ///your BLOC must be used this mixin [PaginationHelper]
  final PaginationHelper paginationController;

  ///pass into if you want to control another things exclude pagination
  final ScrollController? scrollController;

  ///build your main item
  final IndexedWidgetBuilder itemBuilder;

  ///pass into if you don't wanna use the default loading indicator [VueCircularProgressIndicator]
  final WidgetBuilder? loadingIndicatorBuilder;

  // no item builder
  final WidgetBuilder? emptyBuilder;

  ///have to pass into if [showInitialLoadingEffectItem] is true
  final IndexedWidgetBuilder? loadingEffectItemBuilder;

  final int loadingEffectItemCount;

  final double listPaddingStartAndEnd;

  final Axis scrollDirection;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double itemHeight;

  final double itemPercentBeforeLoadMore;

  final bool shrinkWap;

  final EdgeInsetsGeometry? padding;

  final ScrollPhysics? physics;

  /// get length of list
  final int Function()? length;

  const PaginationGridView({
    Key? key,
    required this.paginationController,
    required this.itemBuilder,
    required this.itemHeight,
    this.scrollController,
    this.loadingIndicatorBuilder,
    this.loadingEffectItemBuilder,
    this.loadingEffectItemCount = 20,
    this.listPaddingStartAndEnd = 0,
    this.scrollDirection = Axis.vertical,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 0,
    this.crossAxisSpacing = 0,
    this.itemPercentBeforeLoadMore = 30,
    this.shrinkWap = false,
    this.padding,
    this.physics,
    this.emptyBuilder,
    this.length,
  }) : super(key: key);

  // this assert make sure the load more and loading effect work well

  @override
  PaginationGridViewState createState() => PaginationGridViewState();
}

class PaginationGridViewState extends State<PaginationGridView> {
  late ScrollController _scrollController;

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
  void didUpdateWidget(covariant PaginationGridView oldWidget) {
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

  Widget? buildItem(int index) {
    //loading items
    if (isFirstLoad) {
      return widget.loadingIndicatorBuilder?.call(context) ??
          const Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          );
    }
    if (index < length) {
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
                      visiblePercentage > widget.itemPercentBeforeLoadMore &&
                      index == listLength - 1) {
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
          : GridView.builder(
              physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
              padding: widget.padding,
              shrinkWrap: widget.shrinkWap,
              scrollDirection: widget.scrollDirection,
              controller: _scrollController,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: widget.crossAxisSpacing,
                mainAxisSpacing: widget.mainAxisSpacing,
                height: widget.itemHeight,
              ),
              itemCount: listLength,
              itemBuilder: (BuildContext ctx, index) {
                return Padding(
                    padding: EdgeInsets.only(
                        top: isVertical
                            ? (index <= (widget.crossAxisCount - 1)
                                ? widget.listPaddingStartAndEnd
                                : 0)
                            : 0,
                        bottom: isVertical
                            ? (index >= length
                                ? widget.listPaddingStartAndEnd
                                : 0)
                            : 0,
                        left: !isVertical
                            ? (index <= (widget.crossAxisCount - 1)
                                ? widget.listPaddingStartAndEnd
                                : 0)
                            : 0,
                        right: !isVertical
                            ? (index >= length
                                ? widget.listPaddingStartAndEnd
                                : 0)
                            : 0),
                    child: buildItem(index));
              }),
    );
  }

  int get listLength {
    if (isFirstLoad) {
      return widget.loadingEffectItemCount;
    } else {
      if (widget.paginationController.canLoadMore) {
        int returnInt =
            (length ~/ widget.crossAxisCount + 2) * widget.crossAxisCount;

        if (length % widget.crossAxisCount == 0) {
          returnInt = returnInt - widget.crossAxisCount;
        }

        return returnInt;
      } else {
        return length;
      }
    }
  }

  bool get isFirstLoad => widget.paginationController.isFirstLoad;

  int get length =>
      widget.length?.call() ?? widget.paginationController.items.length;
}
