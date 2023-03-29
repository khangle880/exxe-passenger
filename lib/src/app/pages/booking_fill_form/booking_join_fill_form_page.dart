import 'package:exxe/src/app/common/components/note/note_widget.dart';

import '../../../core/base_state.dart';
import '../../../data/models/models.dart';
import '../../../utils/export/ui_export.dart';
import '../pages.dart';
import 'components/components.dart';

class BookingJoinFillFormPage extends StatefulWidget {
  const BookingJoinFillFormPage({
    Key? key,
    required this.carCustomModel,
    this.carModel,
  }) : super(key: key);

  final CompoundingCarCustomerModel carCustomModel;
  final CompoundingCarModel? carModel;

  @override
  State<BookingJoinFillFormPage> createState() =>
      _BookingJoinFillFormPageState();
}

class _BookingJoinFillFormPageState
    extends BaseState<BookingJoinFillFormPage, BookingFillFormCubit> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController controller;

  @override
  late final BookingFillFormCubit bloc;

  @override
  void initData() {
    bloc = context.read<BookingFillFormCubit>();
    controller = TextEditingController(
      text: bloc.state.note,
    );
    super.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        backgroundColor: AppColors.gray05,
        appBar: CustomAppBarWidget(
          backgroundColor: AppColors.greyLight,
          title: "Điền thông tin",
          context: context,
        ),
        bottomNavigationBar:
            BlocConsumer<BookingFillFormCubit, BookingFillFormState>(
          listenWhen: (previous, current) =>
              previous.carCustomerModel != current.carCustomerModel,
          listener: (context, state) {
            if (state.carCustomerModel != null) {
              Navigator.pushNamed(
                context,
                Routes.confirmBooking,
                arguments: state.carCustomerModel,
              );
            }
          },
          builder: (context, state) {
            return Container(
              color: AppColors.gray05,
              padding: const EdgeInsets.only(
                  bottom: 24, left: 24, right: 24, top: 16),
              child: ButtonWidgetOld(
                onClick: () {
                  if (formKey.currentState!.validate()) {
                    if (state.carCustomerModelId != null &&
                        state.compoundingCarId != null) {
                      bloc.updateCompoundingCar();
                    } else if (state.compoundingCarId != null) {
                      bloc.joinCompoundingCar();
                    } else {
                      bloc.createCompoundingCar();
                    }
                  }
                },
                radius: 12,
                child: Text(
                  "Tiếp Tục",
                  style: AppStyles.s16w6.withColor(AppColors.primaryLight),
                ),
              ),
            );
          },
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<BookingFillFormCubit, BookingFillFormState>(
              builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                  child: CustomFormField(
                      validator: (value) {
                        if (state.pickupPoint?.province == null) {
                          return 'Vui lòng chọn tỉnh đi';
                        }
                        if (state.pickupPoint?.station == null) {
                          return 'Vui lòng chọn trạm đi';
                        }
                        if (state.destinationPoint?.province == null) {
                          return 'Vui lòng chọn tỉnh đến';
                        }
                        if (state.destinationPoint?.station == null) {
                          return 'Vui lòng chọn trạm đến';
                        }
                        return null;
                      },
                      child: _buildInfoTimeTripDetail(state)),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      _buildDateTime(state),
                      const SizedBox(
                        height: 12,
                      ),
                      state.carType == CompoundingType.convenient
                          ? const SelectPickupAddress()
                          : const SizedBox(),
                      CarFareTable(widget.carModel),
                      const SizedBox(
                        height: 12,
                      ),
                      const NumberPassenger(),
                      const SizedBox(
                        height: 12,
                      ),
                      _buildOtherNotes(widget.carModel?.note),
                      _buildNote(state),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    ).gestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  Widget _buildInfoTimeTripDetail(BookingFillFormState state) {
    final customer = CompoundingCarCustomerModel(
      compoundingType: state.carType,
      fromPickUpStation: state.pickupPoint?.station,
      toPickUpStation: state.destinationPoint?.station,
      fromProvince: state.pickupPoint?.province,
      toProvince: state.destinationPoint?.province,
      distance: state.distance,
      duration: state.duration,
      fromAddress: state.pickupPoint?.address,
      toAddress: state.destinationPoint?.address,
      isPickingUpFromStart: state.isPickingUpFromStart,
    );
    switch (state.carType!) {
      case CompoundingType.oneWay:
      case CompoundingType.twoWay:
      case CompoundingType.convenient:
        return BookingInfoWidget.topCollapsed(
          customer,
        );
      case CompoundingType.compounding:
        return BookingInfoWidget.topCollapsedPickStation(
          customer,
          onTapFromProvinceName: state.pickupPoint?.province == null
              ? () {
                  Navigator.pushNamed(
                    context,
                    Routes.selectProvinceStationPage,
                    arguments: {
                      'callback': (provinceModel, stationModel) {
                        bloc.getPickUpPoint(stationModel, provinceModel);
                      },
                      'type': SearchType.pickUpProvince,
                      'currentProvinceId':
                          state.destinationPoint?.province?.provinceId
                    },
                  );
                }
              : () {
                  Navigator.pushNamed(
                    context,
                    Routes.selectStationPage,
                    arguments: {
                      'onSelectStation': (station, address, isPickUp) {
                        bloc.getPickUpPoint(
                          station,
                          state.pickupPoint!.province!,
                          address: address,
                          isPickingUpFromStart: isPickUp,
                        );
                      },
                      'provinceModel': state.pickupPoint!.province!,
                      'searchType': SearchType.pickUpStation,
                      'initStation': state.pickupPoint?.station,
                      'isPickingUpFromStart': state.isPickingUpFromStart,
                      'initAddress': state.pickupPoint?.address,
                    },
                  );
                },
          onTapToProvinceName: state.destinationPoint?.province == null
              ? () {
                  Navigator.pushNamed(
                    context,
                    Routes.selectProvinceStationPage,
                    arguments: {
                      'callback': (provinceModel, stationModel) {
                        bloc.getDestinationPoint(stationModel, provinceModel);
                      },
                      'type': SearchType.destinationProvince,
                      'currentProvinceId':
                          state.pickupPoint?.province?.provinceId
                    },
                  );
                }
              : () {
                  Navigator.pushNamed(
                    context,
                    Routes.selectStationPage,
                    arguments: {
                      'onSelectStation': (station, address, isPickUp) {
                        bloc.getDestinationPoint(
                            station, state.destinationPoint!.province!);
                      },
                      'provinceModel': state.destinationPoint!.province!,
                      'searchType': SearchType.destinationStation,
                      'initStation': state.destinationPoint?.station,
                    },
                  );
                },
        );
    }
  }

  Widget _buildDateTime(BookingFillFormState state) {
    return InfoTimeTripDetail(
      onTapTime: () {
        if (widget.carModel == null) {
          CustomCalendar.showCalendar(
            context,
            initDate: state.expectedGoingOnDate,
            (date) {
              bloc.getExpectedGoingOnDate(date);
            },
          );
        } else {
          CustomCalendar.showCalendar(
            context,
            initDate: state.expectedGoingOnDate!,
            (date) {
              bloc.getExpectedGoingOnDate(date);
            },
            type: CalendarViewType.inTwoHour,
            maxDate: state.expectedGoingOnDate!,
          );
        }
      },
      validator: () {
        if (state.expectedGoingOnDate == null ||
            state.expectedGoingOnDate!.isBefore(DateTime.now())) {
          return "Thời gian đi không phù hợp";
        }
        return null;
      },
      flex: 5,
      onTapCalendar: widget.carModel == null
          ? () {
              CustomCalendar.showCalendar(
                context,
                (date) {
                  bloc.getExpectedGoingOnDate(date);
                },
                initDate: state.expectedGoingOnDate,
              );
            }
          : null,
      isDisableDate: widget.carModel != null,
      textDate: 'Ngày đi',
      selectedDate: state.expectedGoingOnDate != null
          ? state.expectedGoingOnDate!.toFormat('dd.MM.yyyy')
          : "Chọn ngày đi",
      selectedTime: state.expectedGoingOnDate != null
          ? state.expectedGoingOnDate!.toFormat("HH:mm")
          : 'Giờ : Phút',
      style: state.expectedGoingOnDate == null
          ? AppStyles.s14w4.withColor(AppColors.gray50)
          : AppStyles.s14w4.withColor(AppColors.gray95),
    );
  }

  Widget _buildNote(BookingFillFormState state) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Ghi chú của chuyến đi",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: AppDimens.text14),
          ),
        ),
        const SizedBox(height: 4),
        NoteWidget(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          height: 120,
          controller: controller,
          hintText: 'Ghi chú của bạn.',
          decoration: BoxDecoration(
              color: AppColors.textLight,
              borderRadius: BorderRadius.circular(12)),
          onTapClearText: () {
            controller.clear();
            bloc.getNotes('');
          },
          onChanged: (value) {
            bloc.getNotes(value);
          },
        ),
      ],
    );
  }

  Widget _buildOtherNotes(String? note) {
    if (note == null || note.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "Ghi chú ",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: AppDimens.text14),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Text(
            note,
            style: AppStyles.s14w4.withColor(AppColors.gray95x14),
          ),
        ),
      ],
    );
  }
}
