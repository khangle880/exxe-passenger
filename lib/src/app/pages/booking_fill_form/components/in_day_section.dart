import 'dart:math';

import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import '../controllers/booking_fill_form_cubit.dart';

class InDaySection extends StatelessWidget {
  const InDaySection(
      {Key? key,
      required this.goingDate,
      required this.distance,
      required this.duration,
      required this.numKmPerDay,
      required this.maxDistanceTravelingInDay})
      : super(key: key);
  final DateTime goingDate;
  final num distance;
  final num duration;
  final num numKmPerDay;
  final num maxDistanceTravelingInDay;

  DateTime get returnDateMin => goingDate.getCanReturnMin(
      distance: distance, maxDistanceInDay: numKmPerDay);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BookingFillFormCubit>();

    final canReturnTime =
        goingDate.add(Duration(milliseconds: duration.hourToMilliseconds));
    final availableInDay = canReturnTime
        .difference(goingDate.date.add(AppConstant.maxTimeInDay))
        .isNegative;
    final canSwitch = availableInDay && distance <= maxDistanceTravelingInDay;

    return BlocBuilder<BookingFillFormCubit, BookingFillFormState>(
      builder: (context, state) {
        DateTime? maxDate;
        if (state.currentWaitingBlock != null) {
          // maxTime = endBlock - ride duration
          final maxMilliseconds = state.currentWaitingBlock!
                  .endBlockTime(goingDate.time.inMilliseconds) -
              (state.duration ?? 0).hourToMilliseconds;

          maxDate = state.currentWaitingBlock!.priority == true
              ? null
              : goingDate.date.add(Duration(milliseconds: maxMilliseconds));
        }

        final minMilliseconds = max(state.duration!,
                state.currentWaitingBlock?.numberHourBeforeBlock ?? 0)
            .hourToMilliseconds;

        final minDate = goingDate.add(Duration(milliseconds: minMilliseconds));
        if (state.expectedPickingUpDate != null &&
            (state.expectedPickingUpDate!.isBefore(minDate) ||
                (maxDate != null &&
                    state.expectedPickingUpDate!.isAfter(maxDate)))) {
          final minutes = (minDate.time.inMinutes).roundUp(15).ceil();
          final pickupDate = minDate.date.add(Duration(minutes: minutes));
          bloc.getExpectedPickingUpDate(pickupDate);
        }

        return AnimatedContainer(
          margin: const EdgeInsets.only(bottom: 12),
          duration: const Duration(milliseconds: 500),
          child: Column(
            children: [
              canSwitch
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(bottom: 12),
                      height: 20,
                      child: Row(
                        children: [
                          Switch(
                            value: state.isInDay ?? false,
                            activeColor: AppColors.primaryMain,
                            onChanged: (bool value) {
                              if (value) {
                                bloc.getExpectedPickingUpDate(
                                  goingDate
                                      .add(Duration(hours: duration.ceil())),
                                  isInDay: value,
                                );
                              } else {
                                bloc.getExpectedPickingUpDate(
                                  null,
                                  isInDay: value,
                                );
                              }
                            },
                          ),
                          const Text("Đi trong ngày",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    )
                  : const SizedBox(),
              state.isInDay ?? false
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CustomFormField(
                        child: _buildWaitingBlock(
                          blocks: state.waitingCharges,
                          currentBlock: state.currentWaitingBlock,
                          bloc: bloc,
                        ),
                        validator: (value) {
                          if (state.currentWaitingBlock == null) {
                            return "Vui lòng chọn gói thời gian";
                          }
                          return null;
                        },
                      ),
                    )
                  : const SizedBox(),
              CustomFormField(
                validator: (value) {
                  if (state.expectedPickingUpDate == null) {
                    return "Thiếu thời gian";
                  }
                  return null;
                },
                child: InfoTimeTripDetail(
                  isDisableDate: state.isInDay ?? false,
                  isDisableTime: state.isInDay == true &&
                      state.currentWaitingBlock == null,
                  onTapCalendar: () {
                    _onShowCalendarPickingUp(
                      bloc: bloc,
                      state: state,
                      context: context,
                      maxDate: maxDate,
                      minDate: minDate,
                    );
                  },
                  flex: 5,
                  textDate: "Ngày về",
                  selectedDate: state.expectedPickingUpDate != null
                      ? state.expectedPickingUpDate!.toFormat('dd.MM.yyyy')
                      : 'Chọn ngày về',
                  selectedTime: state.expectedPickingUpDate != null
                      ? state.expectedPickingUpDate!.toFormat("HH:mm")
                      : 'Giờ : Phút',
                  style: state.expectedPickingUpDate == null
                      ? AppStyles.s14w4.withColor(AppColors.gray50)
                      : AppStyles.s14w4.withColor(AppColors.gray95),
                  onTapTime: () {
                    _onShowCalendarPickingUp(
                      bloc: bloc,
                      state: state,
                      context: context,
                      maxDate: maxDate,
                      minDate: minDate,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _onShowCalendarPickingUp({
    required BookingFillFormCubit bloc,
    required BookingFillFormState state,
    required BuildContext context,
    DateTime? maxDate,
    DateTime? minDate,
  }) {
    if (state.isInDay == true) {
      CustomCalendar.showCalendar(
        context,
        (date) {
          bloc.getExpectedPickingUpDate(date);
        },
        type: CalendarViewType.time,
        minDate: minDate,
        initDate: goingDate
            .add(Duration(milliseconds: state.duration!.hourToMilliseconds)),
        maxDate: maxDate,
      );
    } else {
      CustomCalendar.showCalendar(
        context,
        (date) {
          bloc.getExpectedPickingUpDate(date);
        },
        type: CalendarViewType.dateTime,
        minDate: returnDateMin,
        initDate: goingDate
            .add(Duration(milliseconds: state.duration!.hourToMilliseconds)),
      );
    }
  }

  _buildWaitingBlock({
    List<WaitingChargeBlockModel>? blocks,
    WaitingChargeBlockModel? currentBlock,
    required BookingFillFormCubit bloc,
  }) {
    if (blocks == null) {
      return SizedBox(
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            5,
            (index) => Container(
              width: 130,
              margin: const EdgeInsets.only(right: 10, left: 2),
              padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                boxShadow: [
                  BoxShadow(
                      color: AppColors.gray10, blurRadius: 1, spreadRadius: 1)
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                      text: "tai khoan exxe"),
                  ShimmerUtils.buildShimmerWithText(AppStyles.s10w4,
                      text: "100000000"),
                  const SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    if (blocks.isEmpty) {
      return const SizedBox();
    }
    return SizedBox(
      height: 70,
      child: BlocBuilder<BookingFillFormCubit, BookingFillFormState>(
        builder: (context, state) {
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = blocks[index];

              return _buildWaitingBlockItem(
                block: item,
                isSelected: item == currentBlock,
                onSelected: () {
                  bloc.getWaitingBlock(item);
                },
                isEnable: bloc.checkBlockValid(item),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: blocks.length,
          );
        },
      ),
    );
  }

  Widget _buildWaitingBlockItem({
    required WaitingChargeBlockModel block,
    required bool isSelected,
    required bool isEnable,
    required Function() onSelected,
  }) {
    return GestureDetector(
      onTap: isEnable ? onSelected : null,
      child: Container(
        width: 130,
        padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
        alignment: Alignment.topLeft,
        decoration: isEnable
            ? isSelected
                ? BoxDecoration(
                    color: AppColors.primaryMainBlur,
                    border: Border.all(color: AppColors.primaryMain),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 7,
                            spreadRadius: -2,
                            color: AppColors.primaryLight.withOpacity(0.05)),
                        BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 15,
                            spreadRadius: -3,
                            color: const Color(0xFFCACACA).withOpacity(0.1)),
                      ])
                : BoxDecoration(
                    color: AppColors.primaryLight,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.gray20,
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],
                  )
            : BoxDecoration(
                color: AppColors.gray20,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.gray10, blurRadius: 1, spreadRadius: 1)
                ],
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              block.blockName!,
              style: AppStyles.s14w6.withColor(
                isSelected ? AppColors.primaryMain : AppColors.gray60x9d,
              ),
              maxLines: 2,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                block.priceUnit!.ceil().currencyFormat,
                style: AppStyles.s14w5.withColor(AppColors.gray70x76),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
