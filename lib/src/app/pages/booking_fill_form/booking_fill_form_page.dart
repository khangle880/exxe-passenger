import 'package:exxe/src/app/pages/booking_fill_form/components/in_day_section.dart';

import '../../../core/base_state.dart';
import '../../../data/models/models.dart';
import '../../../utils/export/ui_export.dart';
import '../pages.dart';
import 'components/note_input.dart';

class BookingFillFormPage extends StatefulWidget {
  const BookingFillFormPage(
    this.carCustomModel, {
    Key? key,
  }) : super(key: key);

  final CompoundingCarCustomerModel carCustomModel;

  @override
  State<BookingFillFormPage> createState() => _BookingFillFormPageState();
}

class _BookingFillFormPageState
    extends BaseState<BookingFillFormPage, BookingFillFormCubit> {
  final formKey = GlobalKey<FormState>();

  @override
  late final BookingFillFormCubit bloc;

  @override
  void initData() {
    bloc = context.read<BookingFillFormCubit>();
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
              child: ButtonWidget(
                onClick: () {
                  if (formKey.currentState!.validate()) {
                    if (state.carCustomerModelId != null) {
                      bloc.updateCompoundingCar();
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
            final appState = GetIt.I<AppState>();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                  child: BookingInfoWidget.topCollapsed(
                    widget.carCustomModel,
                  ),
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
                      state.carType == CompoundingType.twoWay &&
                              state.expectedGoingOnDate != null
                          ? InDaySection(
                              goingDate: state.expectedGoingOnDate!,
                              distance: state.distance!,
                              duration: state.duration!,
                              numKmPerDay:
                                  appState.computePriceModel.numberKmPerDay!,
                              maxDistanceTravelingInDay: appState
                                  .computePriceModel.maxDistanceTravelingInDay!,
                            )
                          : const SizedBox(),
                      _buildCarFareTable(state),
                      const SizedBox(
                        height: 12,
                      ),
                      NoteInput(
                        note: state.note,
                        onChanged: (String value) {
                          bloc.getNotes(value);
                        },
                      ),
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

  Widget _buildDateTime(BookingFillFormState state) {
    return InfoTimeTripDetail(
      onTapCalendar: () {
        CustomCalendar.showCalendar(
          context,
          (date) {
            bloc.getExpectedGoingOnDate(date);
          },
          initDate: state.expectedGoingOnDate,
        );
      },
      validator: () {
        if (state.expectedGoingOnDate == null ||
            state.expectedGoingOnDate!.isBefore(DateTime.now())) {
          return "Thời gian đi không phù hợp";
        }
        return null;
      },
      flex: 5,
      textDate: "Ngày đi",
      selectedDate: state.expectedGoingOnDate != null
          ? state.expectedGoingOnDate!.toFormat('dd.MM.yyyy')
          : 'Chọn ngày đi',
      selectedTime: state.expectedGoingOnDate != null
          ? state.expectedGoingOnDate!.toFormat("HH:mm")
          : 'Giờ : Phút',
      style: state.expectedGoingOnDate == null
          ? AppStyles.s14w4.withColor(AppColors.gray50)
          : AppStyles.s14w4.withColor(AppColors.gray95),
      onTapTime: () {
        CustomCalendar.showCalendar(
          context,
          (date) {
            bloc.getExpectedGoingOnDate(date);
          },
          initDate: state.expectedGoingOnDate,
        );
      },
    );
  }

  Widget _buildCarFareTable(BookingFillFormState state) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: "Chọn loại xe ",
              style: AppStyles.s14w7.withColor(AppColors.black),
              children: const [
                TextSpan(
                  text: "*",
                  style: TextStyle(color: Colors.redAccent),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        TypeCarTrip(
          isDisable: false,
          onTapTypeCar: () {
            ModalBottomSheet.instance.show(
              context,
              PickupCarType(
                currentSelect: state.selectedCarPriceModel,
                carTypes: state.carPriceModels,
                onSelected: (carType) {
                  bloc.getSelectedCarPrice(carType);
                },
              ),
              backgroundColor: AppColors.greyLight,
            );
          },
          carType: state.selectedCarPriceModel!.carId!.name!,
          price: state.selectedCarPriceModel!.priceUnit!.ceil().currencyFormat,
        ),
      ],
    );
  }
}
