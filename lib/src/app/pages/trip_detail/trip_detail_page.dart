import 'package:exxe/src/app/pages/trip_detail/components/body_detail.dart';
import 'package:exxe/src/app/pages/trip_detail/components/bottom_button.dart';
import 'package:exxe/src/app/pages/trip_detail/components/header_detail_trip.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../data/data.dart';

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({
    super.key,
    required this.customer,
    required this.onRefresh,
  });

  final CompoundingCarCustomerModel customer;
  final Future<void> Function() onRefresh;

  String getTitle(CompoundingCarCustomerState state) {
    if (state.index >= CompoundingCarCustomerState.inProcess.index) {
      return 'Hoàn thành chuyến đi';
    } else {
      return 'Chi tiết chuyến đi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: CustomAppBarWidget(
        centerTitle: true,
        title: getTitle(customer.state!),
        backgroundColor: Colors.transparent,
        context: context,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 8),
              customer.state == CompoundingCarCustomerState.draft
                  ? const SizedBox()
                  : _buildHeaderDetail(
                      customer.state!, customer.compoundingCarCustomerCode!),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 8),
                child: BookingInfoWidget.topCollapsed(customer),
              ),
              customer.state == CompoundingCarCustomerState.cancel
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildCancelInvoice(),
                    )
                  : BodyTripDetail(
                      customer: customer,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButton(
        context,
        customer,
      ),
    );
  }

  _buildCancelInvoice() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Hoá đơn", style: AppStyles.s18w7),
        ),
        const SizedBox(height: 8),
        RideInfoRow("Tổng tiền",
            value: customer.amountTotal?.ceil().currencyFormat),
        RideInfoRow(
            "Số tiền đã đặt cọc (${((customer.downPayment?.percent ?? 0.2) * 100).ceil()}%)",
            value: "${customer.downPayment?.total?.ceil().currencyFormat}"),
        if (customer.amountReturn != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Số tiền được hoàn lại", style: AppStyles.s16w6),
              Text(
                customer.amountReturn!.ceil().currencyFormat,
                style: AppStyles.s16w6.withColor(
                    AppColors.primaryMain + AppColors.black.withOpacity(.4)),
              ),
            ],
          )
      ],
    );
  }

  Widget _buildHeaderDetail(CompoundingCarCustomerState state, String code) {
    if (state == CompoundingCarCustomerState.draft) {
      return HeaderDetailTrip(
        code: 'Mã đơn #$code',
        status: true,
        title: 'Đơn nháp',
      );
    }
    if (state == CompoundingCarCustomerState.inProcess ||
        state == CompoundingCarCustomerState.deposit ||
        state == CompoundingCarCustomerState.assign ||
        state == CompoundingCarCustomerState.waiting) {
      return HeaderDetailTrip(
        code: 'Mã đơn #$code',
        status: true,
        title: 'Đã đặt cọc',
      );
    }

    if (state == CompoundingCarCustomerState.done) {
      return HeaderDetailTrip(
        code: 'Mã đơn #$code',
        status: true,
        title: 'Đã hoàn thành',
      );
    }
    if (state == CompoundingCarCustomerState.cancel) {
      return HeaderDetailTrip(
        code: 'Mã đơn #$code',
        status: false,
        title: 'Đã hủy',
      );
    }
    return const SizedBox();
  }

  Widget _buildBottomButton(
      BuildContext context, CompoundingCarCustomerModel carCustomer) {
    final state = carCustomer.state;
    final id = carCustomer.compoundingCarCustomerId!.ceil();
    if (state == CompoundingCarCustomerState.draft) {
      return BottomButton(
        firstTitle: 'Hủy chuyến',
        secondTitle: 'Cập nhật',
        onTap: () {
          AppDialog.I.showWarning(
            confirmTitle: 'Xác nhận',
            message: 'Bạn có chắc chắn muốn hủy chuyến ?',
            hasCancel: true,
            onConfirm: () async {
              final result = await GetIt.I<ICompoundingCarCtrlRepo>()
                  .deleteCompoundingCar(id);

              AppDialog.I.closeDialog();
              result.fold((failure) {
                log(failure.toString());
                failure.showDefaultDialog();
              },
                  (data) => Navigator.popUntil(
                      context, ModalRoute.withName(Routes.home)));
            },
          );
        },
        onTapTwo: () {
          if (carCustomer.compoundingType == CompoundingType.oneWay ||
              carCustomer.compoundingType == CompoundingType.twoWay) {
            GetIt.I<LocationHelper>().handleLocation(context,
                routeName: Routes.noCompoundingBook,
                args: {
                  "compounding_car_customer": carCustomer,
                  "type": carCustomer.compoundingType,
                });
          } else {
            Navigator.pushNamed(
              context,
              Routes.bookingJoinFillForm,
              arguments: {
                'carModel': carCustomer.compoundingCarData,
                'carCustomModel': carCustomer,
              },
            );
          }
        },
      );
    }

    if (state == CompoundingCarCustomerState.confirm) {
      return BottomButton(
        firstTitle: 'Hủy chuyến',
        secondTitle: 'Đặt cọc',
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.cancelReason,
            arguments: carCustomer,
          ).then((value) {
            if (value is bool && value) {
              onRefresh.call();
            }
          });
        },
        onTapTwo: () {
          Navigator.pushNamed(context, Routes.deposit, arguments: carCustomer);
        },
      );
    }
    if (state == CompoundingCarCustomerState.confirmPaid ||
        state == CompoundingCarCustomerState.confirmPay) {
      return BottomButton(
        firstTitle: 'Trở lại',
        secondTitle:
            carCustomer.ratingState == CompoundingCarRatingState.noRating
                ? 'Đánh giá chuyến'
                : carCustomer.ratingState == CompoundingCarRatingState.rated
                    ? 'Xem đánh giá'
                    : null,
        onTap: () {
          Navigator.pop(context);
        },
        onTapTwo: carCustomer.ratingState == CompoundingCarRatingState.noRating
            ? () {
                Navigator.pushNamed(
                  context,
                  Routes.tripRating,
                  arguments: carCustomer,
                );
              }
            : carCustomer.ratingState == CompoundingCarRatingState.rated
                ? () {
                    Navigator.pushNamed(
                      context,
                      Routes.viewTripRating,
                      arguments: carCustomer,
                    );
                  }
                : null,
      );
    }
    return BottomButton(
      secondTitle: 'Trở lại',
      onTapTwo: () {
        Navigator.pop(context);
      },
    );
  }
}
