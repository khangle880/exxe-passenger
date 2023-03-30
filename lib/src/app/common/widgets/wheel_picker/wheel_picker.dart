import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'infinite_listview.dart';

typedef TextMapper = String Function(String numberText);

class WheelPicker extends StatefulWidget {
  /// Min value user can pick
  final int minValue;

  /// Max value user can pick
  final int maxValue;

  /// Currently selected value
  final int value;

  /// Called when selected value changes
  final ValueChanged<int> onChanged;

  /// Specifies how many items should be shown - defaults to 3
  final int itemCount;

  /// Step between elements. Only for integer datePicker
  /// Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// padding of single item
  final EdgeInsets itemPadding;

  /// size of list
  final double size;

  /// size of list
  final double selectedSizeRate;

  /// Direction of scrolling
  final Axis axis;

  /// Style of non-selected numbers. If null, it uses Theme's bodyText2
  final TextStyle Function(int value)? textStyle;

  /// Style of non-selected numbers. If null, it uses Theme's headline5 with accentColor
  final TextStyle? selectedTextStyle;

  /// Whether to trigger haptic pulses or not
  final bool haptics;

  /// Build the text of each item on the picker
  final TextMapper? textMapper;

  /// Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  /// Decoration to apply to central box where the selected value is placed
  final Decoration? decoration;

  final bool infiniteLoop;

  const WheelPicker({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
    required this.size,
    required this.selectedSizeRate,
    this.itemCount = 3,
    this.step = 1,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 3),
    this.axis = Axis.vertical,
    this.textStyle,
    this.selectedTextStyle,
    this.haptics = false,
    this.decoration,
    this.zeroPad = false,
    this.textMapper,
    this.infiniteLoop = false,
  })  : assert(minValue <= value),
        assert(value <= maxValue),
        super(key: key);

  @override
  State<WheelPicker> createState() => _WheelPickerState();
}

class _WheelPickerState extends State<WheelPicker> {
  late ScrollController _scrollController;

  double get itemExtent =>
      widget.size / (widget.itemCount + widget.selectedSizeRate);

  @override
  void initState() {
    super.initState();
    final initialOffset =
        (widget.value - widget.minValue) ~/ widget.step * itemExtent;
    if (widget.infiniteLoop) {
      _scrollController =
          InfiniteScrollController(initialScrollOffset: initialOffset);
    } else {
      _scrollController = ScrollController(initialScrollOffset: initialOffset);
    }
    _scrollController.addListener(_scrollListener);
    Future.delayed(
      const Duration(milliseconds: 100),
      () => _scrollListener(),
    );
  }

  void _scrollListener() {
    var indexOfMiddleElement = (_scrollController.offset / itemExtent).round();
    if (widget.infiniteLoop) {
      indexOfMiddleElement %= itemCount;
    } else {
      indexOfMiddleElement = indexOfMiddleElement.clamp(0, itemCount - 1);
    }
    final intValueInTheMiddle =
        _intValueFromIndex(indexOfMiddleElement + additionalItemsOnEachSide);

    if (widget.value != intValueInTheMiddle) {
      widget.onChanged(intValueInTheMiddle);
      if (widget.haptics) {
        HapticFeedback.selectionClick();
      }
    }
    Future.delayed(
      const Duration(milliseconds: 20),
      () => _maybeCenterValue(),
    );
  }

  @override
  void didUpdateWidget(WheelPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _maybeCenterValue();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;

  int get itemCount => (widget.maxValue - widget.minValue) ~/ widget.step + 1;

  int get listItemsCount => itemCount + 2 * additionalItemsOnEachSide;

  int get additionalItemsOnEachSide => (widget.itemCount - 1) ~/ 2;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (not) {
        if (not.dragDetails?.primaryVelocity == 0) {
          Future.microtask(() => _maybeCenterValue());
        }
        return true;
      },
      child: (widget.infiniteLoop)
          ? InfiniteListView.builder(
              scrollDirection: widget.axis,
              controller: _scrollController as InfiniteScrollController,
              itemBuilder: _itemBuilder,
              padding: EdgeInsets.zero,
            )
          : SingleChildScrollView(
              scrollDirection: widget.axis,
              controller: _scrollController,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listItemsCount,
                scrollDirection: widget.axis,
                itemBuilder: _itemBuilder,
                padding: EdgeInsets.zero,
              ),
            ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final value = _intValueFromIndex(index % itemCount);

    final themeData = Theme.of(context);
    final defaultStyle =
        widget.textStyle?.call(value) ?? themeData.textTheme.bodyText2;
    final selectedStyle = widget.selectedTextStyle ??
        themeData.textTheme.headline5?.copyWith(color: themeData.accentColor);

    final isExtra = !widget.infiniteLoop &&
        (index < additionalItemsOnEachSide ||
            index >= listItemsCount - additionalItemsOnEachSide);
    final itemStyle = value == widget.value ? selectedStyle : defaultStyle;

    final child = isExtra
        ? const SizedBox.shrink()
        : FittedBox(
            child: AnimatedDefaultTextStyle(
              style: itemStyle ?? const TextStyle(),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Text(
                _getDisplayedValue(value),
              ),
            ),
          );
    var size = value == widget.value
        ? itemExtent * (1 + widget.selectedSizeRate)
        : itemExtent;
    return GestureDetector(
      onTap: () {
        _scrollController.animateTo(
          (index - additionalItemsOnEachSide) * itemExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      },
      behavior: HitTestBehavior.translucent,
      child: AnimatedContainer(
        height: widget.axis == Axis.vertical ? size : 0,
        width: widget.axis == Axis.vertical ? 0 : size,
        padding: widget.itemPadding,
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: child,
      ),
    );
  }

  String _getDisplayedValue(int value) {
    final text = widget.zeroPad
        ? value.toString().padLeft(widget.maxValue.toString().length, '0')
        : value.toString();
    if (widget.textMapper != null) {
      return widget.textMapper!(text);
    } else {
      return text;
    }
  }

  int _intValueFromIndex(int index) {
    index -= additionalItemsOnEachSide;
    index %= itemCount;
    return widget.minValue + index * widget.step;
  }

  void _maybeCenterValue() {
    if (_scrollController.hasClients && !isScrolling) {
      int diff = widget.value - widget.minValue;
      int index = diff ~/ widget.step;
      if (widget.infiniteLoop) {
        final offset = _scrollController.offset + 0.5 * itemExtent;
        final cycles = (offset / (itemCount * itemExtent)).floor();
        index += cycles * itemCount;
      }
      _scrollController.animateTo(
        index * itemExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
