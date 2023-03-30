import 'package:exxe/src/app/common/widgets/wheel_picker/wheel_picker.dart';

import '../../../../utils/export/ui_export.dart';

class PickupTimeWheel extends StatefulWidget {
  const PickupTimeWheel(
      {Key? key,
      required this.initTime,
      required this.maxValue,
      required this.minValue,
      this.minEnablePick,
      this.maxEnablePick,
      this.onChanged,
      required this.step})
      : super(key: key);
  final Duration initTime;
  final Duration maxValue;
  final Duration minValue;
  final Duration step;
  final Duration? minEnablePick;
  final Duration? maxEnablePick;
  final Function(Duration value)? onChanged;

  @override
  State<PickupTimeWheel> createState() => _PickupTimeWheelState();
}

class _PickupTimeWheelState extends State<PickupTimeWheel> {
  late int _currentValue;
  late Duration minEnablePick;
  late Duration maxEnablePick;
  final DateTime formatDate = DateTime(2000, 0, 0, 0, 0, 0);

  @override
  void initState() {
    super.initState();
    minEnablePick = widget.minEnablePick ?? widget.minValue;
    maxEnablePick = widget.maxEnablePick ?? widget.maxValue;
    _updateRange();
    _loadFirstValue();
  }

  @override
  void didUpdateWidget(covariant PickupTimeWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minEnablePick != widget.minEnablePick ||
        oldWidget.maxEnablePick != widget.maxEnablePick) {
      _updateRange();
      if (!isCanPick(_currentValue)) {
        _loadFirstValue();
      }
    }
  }

  _loadFirstValue() {
    final initTime = widget.initTime.inMilliseconds
        .clamp(minEnablePick.inMilliseconds, maxEnablePick.inMilliseconds);
    _currentValue = initTime;
    _currentValue =
        _roundByStep(Duration(milliseconds: initTime)).inMilliseconds;
    widget.onChanged?.call(Duration(milliseconds: _currentValue));
  }

  isCanPick(value) {
    return value >= minEnablePick.inMilliseconds &&
        value <= maxEnablePick.inMilliseconds;
  }

  Duration _roundByStep(Duration value, {bool up = true}) {
    final duration = Duration(
        milliseconds: (value.inMilliseconds +
                (up ? (widget.step.inMilliseconds - 1) : 0)) ~/
            widget.step.inMilliseconds *
            widget.step.inMilliseconds);
    if (isCanPick(duration.inMilliseconds)) {
      return duration;
    } else {
      return value;
    }
  }

  _updateRange() {
    minEnablePick = _roundByStep(widget.minEnablePick ?? widget.minValue);
    maxEnablePick =
        _roundByStep(widget.maxEnablePick ?? widget.maxValue, up: false);
  }

  @override
  Widget build(BuildContext context) {
    isCanPick(value) {
      return value >= minEnablePick.inMilliseconds &&
          value <= maxEnablePick.inMilliseconds;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  final value = _currentValue - widget.step.inMilliseconds;
                  if (isCanPick(value)) {
                    setState(() {
                      _currentValue = value;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    AppIcons.chevronLeft,
                    width: 24,
                    height: 24,
                    color: AppColors.primaryMain,
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return WheelPicker(
                    minValue: widget.minValue.inMilliseconds,
                    maxValue: widget.maxValue.inMilliseconds,
                    // infiniteLoop: true,
                    itemCount: 5,
                    value: _currentValue,
                    step: widget.step.inMilliseconds,
                    textMapper: (value) => formatDate
                        .add(Duration(milliseconds: int.parse(value)))
                        .toFormat('HH:mm'),
                    textStyle: (value) {
                      final color = isCanPick(value)
                          ? AppColors.primaryMain +
                              AppColors.primaryLight.withOpacity(.6)
                          : AppColors.gray30;
                      return AppStyles.s16w4.withColor(color);
                    },
                    itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                    selectedTextStyle:
                        AppStyles.s24w6.withColor(AppColors.primaryMain),
                    size: constraints.maxWidth,
                    selectedSizeRate: (69 / 46) - 1,
                    onChanged: (value) {
                      if (isCanPick(value)) {
                        setState(() {
                          _currentValue = value;
                        });
                        widget.onChanged?.call(Duration(milliseconds: value));
                      }
                    },
                    axis: Axis.horizontal,
                  );
                }),
              ),
              InkWell(
                onTap: () {
                  final value = _currentValue + widget.step.inMilliseconds;
                  if (isCanPick(value)) {
                    setState(() {
                      _currentValue = value;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    AppIcons.chevronRight,
                    width: 24,
                    height: 24,
                    color: AppColors.primaryMain,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sáng",
              style: AppStyles.s18w7.withColor(
                _isAm(_currentValue) ? null : AppColors.gray40,
              ),
            ).inkWell(
              onTap: () {
                if (!_isAm(_currentValue)) {
                  final newValue = minEnablePick.inMilliseconds < 0
                      ? 0
                      : minEnablePick.inMilliseconds;
                  if (isCanPick(newValue)) {
                    setState(() {
                      _currentValue = newValue;
                    });
                  }
                }
              },
            ),
            const SizedBox(width: 16),
            Text(
              "Chiều",
              style: AppStyles.s18w7.withColor(
                !_isAm(_currentValue) ? null : AppColors.gray40,
              ),
            ).inkWell(
              onTap: () {
                if (_isAm(_currentValue)) {
                  final newValue = minEnablePick.inMilliseconds < 0
                      ? minEnablePick.inMilliseconds
                      : 12 * 60 * 60 * 1000;

                  if (isCanPick(newValue)) {
                    setState(() {
                      _currentValue = newValue;
                    });
                  }
                }
              },
            )
          ],
        )
      ],
    );
  }

  _isAm(int milisecound) {
    return formatDate
        .add(Duration(milliseconds: _currentValue))
        .toFormat('a')
        .contains("AM");
  }
}
