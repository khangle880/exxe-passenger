import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import 'transaction_list.dart';

class BodyWallet extends StatelessWidget {
  const BodyWallet(
      {Key? key, required this.wallet, this.range, this.paymentPurposeGroup})
      : super(key: key);
  final WalletModel wallet;
  final PickerDateRange? range;
  final List<PaymentPurposeGroup>? paymentPurposeGroup;

  int? calculateTotalMoney() {
    return wallet.journal
        ?.map((e) => e.remainsAmount)
        .reduce((value, element) => (value ?? 0) + (element ?? 0))
        ?.ceil();
  }

  int? getRemainAmountOfCash() {
    return wallet.journal
        ?.where((element) => element.journalType == JournalType.cash)
        .first
        .remainsAmount
        ?.ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          width: double.maxFinite,
          height: 175,
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Tổng số dư tài khoản", style: AppStyles.s14w5),
              Text(calculateTotalMoney()?.currencyFormat ?? "",
                  style: AppStyles.s28w7.withColor(AppColors.primaryMain)),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      "Khả dụng: ",
                      style: AppStyles.s14w7.withColor(AppColors.gray60x9d),
                    ),
                    Text(getRemainAmountOfCash()?.currencyFormat ?? "",
                        style: AppStyles.s14w4)
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildWalletCashButtons(context),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TransactionListWidget(
              range: range,
              paymentPurposeGroup: paymentPurposeGroup,
            ),
          ),
        ),
      ],
    );
  }

  _buildWalletCashButtons(BuildContext context) {
    return Row(children: [
      ButtonWidget(
        isExpand: true,
        backgroundColor: AppColors.primaryMain,
        onClick: () {
          Navigator.pushNamed(context, Routes.rechargePage);
        },
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const SizedBox(width: 4),
            Text(
              "Nạp tiền",
              style: AppStyles.s14w6.withColor(AppColors.primaryLight),
            ),
            const Spacer(),
            SvgPicture.asset(AppIcons.walletAdd,
                height: 20, width: 20, color: AppColors.primaryLight),
          ],
        ),
      ),
      const SizedBox(width: 16),
      ButtonWidget(
        isExpand: true,
        backgroundColor:
            AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.95),
        padding: const EdgeInsets.all(12),
        onClick: () {
          Navigator.pushNamed(context, Routes.withdrawPage);
        },
        child: Row(
          children: [
            const SizedBox(width: 4),
            Text(
              "Rút tiền",
              style: AppStyles.s14w6.withColor(AppColors.primaryMain),
            ),
            const Spacer(),
            SvgPicture.asset(AppIcons.withdraw,
                height: 20, width: 20, color: AppColors.primaryMain),
          ],
        ),
      ),
    ]);
  }
}
