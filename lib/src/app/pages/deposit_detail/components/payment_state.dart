import 'package:exxe/src/utils/export/ui_export.dart';

class PaymentState extends StatelessWidget {
  const PaymentState({
    super.key,
    required this.state,
    required this.paymentCode,
    this.message,
  });

  final String state;
  final String paymentCode;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          state == 'success'
              ? SvgPicture.asset(
                  AppIcons.checkCircle,
                  color: AppColors.accGreenMain,
                  width: 87,
                  height: 87,
                )
              : state == 'waiting'
                  ? const Center(
                      child: SizedBox(
                        height: 45,
                        width: 45,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SvgPicture.asset(
                      AppIcons.warning,
                      color: AppColors.accRedMain,
                      width: 87,
                      height: 87,
                    ),
          const SizedBox(
            height: 24,
          ),
          TextWidget(
            text: state == 'success'
                ? 'Chuyến đi đã được xác nhận'
                : state == "waiting"
                    ? "Đang xử lý"
                    : 'Lỗi',
            weight: AppStyles.fontWeightW700,
            colorText: AppColors.primaryDark,
            fontSize: AppDimens.text16,
          ),
          if (message != null && state == "error")
            Text(
              message!,
              style: AppStyles.s14w4.withColor(AppColors.gray70x76),
              textAlign: TextAlign.center,
            ),
          const SizedBox(
            height: 4,
          ),
          state == 'error' || paymentCode.isEmpty
              ? const SizedBox()
              : Text(
                  'Mã đơn $paymentCode',
                  style: AppStyles.s16w6.withColor(AppColors.gray70x76),
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }
}
