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

  _buildPaymentInfoRow(String title, String value, {bool hasPad = true}) {
    return Padding(
      padding: hasPad ? const EdgeInsets.only(bottom: 8.0) : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: AppStyles.s12w4.withColor(AppColors.gray70x76),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppStyles.s12w6,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
