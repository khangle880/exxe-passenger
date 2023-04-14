import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';

class BodyTransactionDetail extends StatelessWidget {
  const BodyTransactionDetail({Key? key, required this.transaction})
      : super(key: key);
  final TransactionDetailModel transaction;

  @override
  Widget build(BuildContext context) {
    final paymentInfo = transaction.paymentId!;
    final purpose = transaction.paymentPurpose!;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primaryLight,
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                    color: AppColors.shadowA3),
                BoxShadow(spreadRadius: 1, color: AppColors.shadow9b)
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  purpose.getTitle,
                  style: AppStyles.s12w4.withColor(AppColors.gray70x76),
                ),
                const SizedBox(height: 4),
                Text(
                  paymentInfo.amount!.ceil().currencyFormat,
                  style: AppStyles.s24w6.withColor(purpose.getStatusColor),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: DashedLineHorizontal(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Loại giao dịch",
                      style: AppStyles.s12w4.withColor(AppColors.gray70x76),
                    ),
                    TypeStatusWidget.paymentPurpose(purpose),
                  ],
                ),
                const SizedBox(height: 8),
                _buildPaymentInfoRow(
                    "Mã ID", paymentInfo.paymentCode.toString()),
                const SizedBox(height: 8),
                _buildPaymentInfoRow("Thời gian thanh toán",
                    paymentInfo.date!.getDateTimeString),
                const SizedBox(height: 8),
                _buildPaymentInfoRow("Nguồn tiền", "Tài khoản EXXE"),
                const SizedBox(height: 8),
                _buildPaymentInfoRow("Chi phí", "Miễn phí"),
                if (paymentInfo.ref != null) ...[
                  const SizedBox(height: 8),
                  _buildPaymentInfoRow("Nội dung", paymentInfo.ref!),
                ]
              ],
            ),
          ),
          if (transaction.compoundingCarCustomerId != null &&
              transaction.compoundingCarCustomerId!.shouldShow)
            _buildCompoundingCarInfo(),
        ],
      ),
    );
  }

  _buildCompoundingCarInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text("Thông tin chuyến đi", style: AppStyles.s18w7),
          ),
          const SizedBox(height: 8),
          TripDistanceDetail.transaction(transaction.compoundingCarCustomerId!),
        ],
      ),
    );
  }

  _buildPaymentInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppStyles.s12w4.withColor(AppColors.gray70x76)),
        Text(value, style: AppStyles.s12w6),
      ],
    );
  }
}
