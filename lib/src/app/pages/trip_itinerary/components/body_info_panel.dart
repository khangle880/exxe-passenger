import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import 'driver_info.dart';
import 'final_payment_method.dart';
import 'payment_button.dart';
import 'trip_status.dart';

class BodyInfoPanel extends StatefulWidget {
  const BodyInfoPanel({Key? key, required this.carCustomer, this.onRefresh})
      : super(key: key);
  final CompoundingCarCustomerModel carCustomer;
  final Future<void> Function()? onRefresh;

  @override
  State<BodyInfoPanel> createState() => _BodyInfoPanelState();
}

class _BodyInfoPanelState extends State<BodyInfoPanel> {
  late final ValueNotifier<PaymentMethodModel> paymentMethod;
  int tip = 0;

  CompoundingCarCustomerModel get carCustomer => widget.carCustomer;

  @override
  void initState() {
    super.initState();
    final cashMethod = PaymentMethodModel(
        acquirerId: -1,
        provider: "cash",
        name: "Tiền mặt",
        brief: "Thanh toán với tài xế");
    paymentMethod = ValueNotifier<PaymentMethodModel>(cashMethod);
  }

  @override
  void dispose() {
    paymentMethod.dispose();
    super.dispose();
  }

  onPayment(num compoundingCarCustomerId) async {
    final method = paymentMethod.value;
    if (method.moneyInCashWallet != null &&
        (widget.carCustomer.amountDue ?? 0) >= method.moneyInCashWallet!) {
      AppDialog.I.showWarning(
        message: "Số tiền trong tài khoản của bạn không đủ để thanh toán",
        onConfirm: () {
          AppDialog.I.closeDialog();
          Navigator.pushNamed(context, Routes.rechargePage);
        },
        confirmTitle: "Nạp thêm",
        hasCancel: true,
      );
    } else {
      AppDialog.I.showLoading();
      var result = await CompoundingCarControllerRepo()
          .paymentRemainingOfCustomer(
              compoundingCarCustomerId, method.provider!, tip);
      AppDialog.I.closeDialog();
      result.fold(
        (failure) {
          log(failure.toString());
          failure.showDefaultDialog();
        },
        (data) {
          log('car state ${data.state} car id ${data.compoundingCarCustomerId}');
          widget.onRefresh?.call();
          log(data.toString());
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TripStatus(carCustomer.state!),
        const SizedBox(height: 8),
        carCustomer.carDriverId == null ||
                carCustomer.carDriverId?.partnerId == null ||
                carCustomer.state!.index <
                    CompoundingCarCustomerState.assign.index
            ? const SizedBox()
            : DriverInfo(
                carDriver: carCustomer.carDriverId,
                createChat: () {
                  return ChatSocketHelper.I.getRoomChat(
                      carCustomer.carDriverId!.partnerId!,
                      carCustomer.compoundingCarCustomerCode!);
                },
                customerModel: carCustomer,
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: DashedLineHorizontal(
            color: AppColors.gray70x76.withAlpha(50),
            height: 2,
          ),
        ),
        ItemPickUpDestinationPointTripWidget(
          dateTime: carCustomer.expectedGoingOnDate!,
          type: carCustomer.compoundingType!,
          locationStartName: carCustomer.fromProvince!.provinceName!,
          locationStartStation: carCustomer.fromAddressShow!,
          locationEndName: carCustomer.toProvince!.provinceName!,
          locationEndStation: carCustomer.toAddressShow!,
          distance: (carCustomer.distance!).toInt(),
          isReverse: carCustomer.state!.index >=
                  CompoundingCarCustomerState.startReturn.index &&
              carCustomer.compoundingType == CompoundingType.twoWay,
        ),
        const SizedBox(height: 12),
        _buildInfoTrip(carCustomer),
        const SizedBox(height: 8.0),
        ValueListenableBuilder<PaymentMethodModel>(
          valueListenable: paymentMethod,
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: FinalPaymentMethods(
                carCustomer,
                onChanged: (method) {
                  paymentMethod.value = method;
                },
                currentMethod: value,
              ),
            );
          },
        ),
        RidePaymentInfo(
          carCustomer,
          onChangedTip: (value) {
            tip = value;
          },
        ),
        const SizedBox(height: 8.0),
        PaymentButton(
          carCustomer: carCustomer,
          onRefresh: widget.onRefresh,
          onPayment: onPayment,
        ),
      ],
    );
  }

  Widget _buildInfoTrip(CompoundingCarCustomerModel customer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin chuyến đi',
          style: AppStyles.s18w7,
        ),
        const SizedBox(height: 8.0),
        RideInfoRow(
          "Mã chuyến đi",
          value: customer.compoundingCarCustomerCode,
        ),
        RideInfoRow(
          'Ngày đi',
          value: customer.expectedGoingOnDate?.getDateTimeString,
        ),
        if (customer.expectedPickingUpDate != null)
          RideInfoRow(
            'Ngày về',
            value: customer.expectedPickingUpDate!.getDateTimeString,
          ),
        RideInfoRow(
          'Loại xe',
          value: customer.car?.name,
        ),
      ],
    );
  }
}
