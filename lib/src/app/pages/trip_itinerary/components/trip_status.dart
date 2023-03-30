import '../../../../utils/export/ui_export.dart';

class TripStatus extends StatelessWidget {
  const TripStatus(this.state, {Key? key}) : super(key: key);
  final CompoundingCarCustomerState state;

  @override
  Widget build(BuildContext context) {
    String title = '';
    switch (state) {
      case CompoundingCarCustomerState.draft:
      case CompoundingCarCustomerState.confirm:
      case CompoundingCarCustomerState.deposit:
      case CompoundingCarCustomerState.waiting:
        title = 'Đang tìm tài xế cho chuyến đi của bạn!';
        break;
      case CompoundingCarCustomerState.assign:
        title = 'Đã có tài xế nhận chuyến';
        break;
      case CompoundingCarCustomerState.startRunning:
        title = 'Tài xế đã bắt đầu di chuyển';
        break;
      case CompoundingCarCustomerState.waitingCustomer:
        title = 'Tài xế đang chờ bạn';
        break;
      case CompoundingCarCustomerState.inProcess:
        title = 'Xe đang di chuyển...';
        break;
      case CompoundingCarCustomerState.stopProcess:
        title = 'Đã kết thúc chiều đi';
        break;
      case CompoundingCarCustomerState.startReturn:
        title = 'Tài xế đang đến đón bạn trở về';
        break;
      case CompoundingCarCustomerState.inReturnProcess:
        title = 'Xe đang di chuyển về...';
        break;
      case CompoundingCarCustomerState.done:
        title = 'Đã kết thúc hành trình di chuyển';
        break;
      case CompoundingCarCustomerState.customerPay:
        title = "Đã thanh toán số tiền còn lại";
        break;
      case CompoundingCarCustomerState.confirmPay:
      case CompoundingCarCustomerState.confirmPaid:
        title = "Đã thanh toán số tiền còn lại";
        break;
      case CompoundingCarCustomerState.cancel:
        title = 'Chuyến đi của bạn đã bị hủy!';
        break;
    }
    return Text(
      title,
      style: AppStyles.s16w6.withColor(AppColors.primaryDark),
    );
  }
}
