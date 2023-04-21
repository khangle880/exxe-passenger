import 'package:exxe/src/data/data.dart';

import '../../../../utils/export/ui_export.dart';
import '../../chat_fb/chat_fb_core/chat_fb_repo.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton(
      {Key? key,
      required this.carCustomer,
      this.onRefresh,
      required this.onPayment})
      : super(key: key);
  final CompoundingCarCustomerModel carCustomer;
  final Function()? onRefresh;
  final Function(num carCustomerId) onPayment;

  @override
  Widget build(BuildContext context) {
    if (carCustomer.state == CompoundingCarCustomerState.done ||
        carCustomer.state == CompoundingCarCustomerState.inProcess) {
      final isPaid = carCustomer.state == CompoundingCarCustomerState.done &&
          carCustomer.paymentMethod != null;
      final isCanPay = carCustomer.state == CompoundingCarCustomerState.done;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            maxLine: 2,
            text:
                'Vui lòng xác nhận thanh toán trực tiếp với tài xế sau khi kết thúc chuyến đi.',
            fontSize: AppDimens.text14,
            colorText: AppColors.primaryButton,
            weight: AppStyles.fontWeightW400,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: ButtonWidget(
              onClick: isCanPay && !isPaid
                  ? () {
                      onPayment(carCustomer.compoundingCarCustomerId!);
                    }
                  : null,
              radius: 12,
              child: Text(
                isPaid ? 'Chờ xác nhận' : "Thanh toán",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight),
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (carCustomer.state!.index <
                  CompoundingCarCustomerState.startRunning.index) ...[
                Expanded(
                  child: ButtonWidgetOld(
                    onClick: () {
                      Navigator.pushNamed(
                        context,
                        Routes.cancelReason,
                        arguments: carCustomer,
                      ).then((value) {
                        if (value is bool && value) {
                          onRefresh?.call();
                        }
                      });
                    },
                    backgroundColor: AppColors.gray70x76.withAlpha(50),
                    radius: 10,
                    child: Text("Huỷ chuyến", style: AppStyles.s16w6),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: ButtonWidgetOld(
                  onClick: () {
                    GetIt.I<ChatFbRepo>().openAdminRoomChat(context);
                  },
                  backgroundColor: AppColors.primaryButton,
                  radius: 12,
                  child: Text(
                    "Hỗ trợ",
                    style: AppStyles.s16w6.withColor(AppColors.primaryLight),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
