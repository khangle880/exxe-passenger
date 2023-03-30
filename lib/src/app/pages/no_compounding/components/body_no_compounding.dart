import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';
import '../controllers/no_compounding_bloc.dart';

class BodyNoCompounding extends StatelessWidget {
  final CompoundingCarCustomerModel? carCustomer;

  const BodyNoCompounding({Key? key, this.carCustomer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final bloc = context.read<NoCompoundingBloc>();
    Size size = MediaQuery.of(context).size;

    return Form(
      key: formKey,
      child: BlocBuilder<NoCompoundingBloc, NoCompoundingState>(
        builder: (context, state) {
          return Container(
            padding:
                const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
            decoration: BoxDecoration(
              borderRadius: AppStyles.borderTop20LeftRight,
              color: AppColors.greyLight,
            ),
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.35),
                  child: const Divider(
                    height: 5.0,
                    thickness: 5.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Tạo chuyến ${bloc.compoundingType.name.toLowerCase()}',
                    style: AppStyles.s21w7,
                  ),
                ),
                CustomFormField(
                  validator: (value) {
                    if (state.pickupPoint != null &&
                        state.destinationPoint != null &&
                        state.directionsModel == null) {
                      return "Không thể tìm thấy tuyến đường phù hợp. Vui lòng chọn lại địa điểm khác.";
                    }

                    final miss = [
                      state.pickupPoint == null ? "điểm đón" : null,
                      state.destinationPoint == null ? "điểm đến" : null,
                      state.currentCarPrice == null ||
                              state.carPriceModels == null
                          ? "loại xe"
                          : null
                    ].whereNotNull().join(', ').replaceLast(",", " và");
                    if (miss.isNotEmpty) {
                      return "Vui lòng điền thông tin $miss";
                    }
                    return null;
                  },
                  child: CardPickupDestination(
                    selectedDate: state.expectedGoingOnDate,
                    pickupPoint: state.pickupPoint,
                    destinationPoint: state.destinationPoint,
                    onSelectDate: () {
                      CustomCalendar.showCalendar(
                        context,
                        initDate: state.expectedGoingOnDate,
                        (date) {
                          bloc.add(GetScheduleEvent(date));
                        },
                        minDate: DateTime.now(),
                      );
                    },
                    handleSearchPickup: (location) {
                      bloc.add(GetPickUpPointEvent(location));
                    },
                    handleSearchDestination: (location) {
                      bloc.add(GetDestinationPointEvent(location));
                    },
                  ),
                ),
                const SizedBox(height: 15),
                BlocBuilder<NoCompoundingBloc, NoCompoundingState>(
                    builder: (context, state) {
                  return state.pickupPoint != null &&
                          state.destinationPoint != null
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: OptionCarType(
                            currentSelect: state.currentCarPrice,
                            carTypes: state.carPriceModels,
                            onSelected: (carType) {
                              bloc.add(GetCarTypeEvent(carType));
                            },
                          ),
                        )
                      : const SizedBox();
                }),
                SizedBox(
                  width: size.width,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ButtonWidget(
                      onClick: () {
                        if (formKey.currentState!.validate()) {
                          final newData =
                              CompoundingCarCustomerModel.withLocation(
                            compoundingType: bloc.compoundingType,
                            from: state.pickupPoint,
                            to: state.destinationPoint,
                            directionsModel: state.directionsModel,
                            expectedGoingOnDate: state.expectedGoingOnDate,
                            priceUnit: state.currentCarPrice,
                            carPriceModels: state.carPriceModels,
                            compoundingCarCustomerId:
                                carCustomer?.compoundingCarCustomerId,
                            note: carCustomer?.note,
                          );
                          Navigator.pushNamed(
                            context,
                            Routes.bookingFillForm,
                            arguments: {
                              'carCustomModel':
                                  carCustomer?.copyWithModel(newData) ??
                                      newData,
                            },
                          );
                        }
                      },
                      radius: 12.0,
                      child: Text(
                        'Xác nhận',
                        style:
                            AppStyles.s16w6.withColor(AppColors.primaryLight),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
