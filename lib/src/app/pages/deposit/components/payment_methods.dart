import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class PaymentMethodsWidget extends StatelessWidget {
  const PaymentMethodsWidget(
      {Key? key,
      required this.paymentMethods,
      required this.currentPaymentMethod,
      required this.onChanged})
      : super(key: key);
  final List<PaymentMethodModel>? paymentMethods;
  final PaymentMethodModel? currentPaymentMethod;
  final Function(PaymentMethodModel value) onChanged;

  @override
  Widget build(BuildContext context) {
    if (paymentMethods == null) {
      return SizedBox(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children:
              List.generate(5, (index) => const PaymentMethodsWidgetShimmer()),
        ),
      );
    }
    if (paymentMethods!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Chưa có phương thức thanh toán phù hợp',
          style: AppStyles.s16w6,
        ),
      );
    }
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: paymentMethods!
            .map((e) => GestureDetector(
                  onTap: () {
                    onChanged(e);
                  },
                  child: Container(
                    width: 150,
                    height: 80,
                    margin: const EdgeInsets.only(right: 10, left: 2),
                    padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
                    alignment: Alignment.topLeft,
                    decoration: e == currentPaymentMethod
                        ? BoxDecoration(
                            color: AppColors.primaryMain.withAlpha(15),
                            border: Border.all(color: AppColors.primaryMain),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 7,
                                    spreadRadius: -2,
                                    color: AppColors.primaryLight
                                        .withOpacity(0.05)),
                                BoxShadow(
                                    offset: const Offset(0, 10),
                                    blurRadius: 15,
                                    spreadRadius: -3,
                                    color: const Color(0xFFCACACA)
                                        .withOpacity(0.1)),
                              ])
                        : BoxDecoration(
                            color: AppColors.primaryLight,
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: const [
                              BoxShadow(
                                  color: AppColors.gray10,
                                  blurRadius: 1,
                                  spreadRadius: 1)
                            ],
                          ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CachedNetworkImage(
                                imageUrl:
                                    Apis.baseUrl + (e.imageUrl?.url ?? ""),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(e.name!,
                                style: AppStyles.s10w4.withColor(
                                  e == currentPaymentMethod
                                      ? AppColors.primaryMain
                                      : AppColors.gray60x9d,
                                )),
                          ],
                        ),
                        const Spacer(),
                        if (e.provider ==
                            RemainingPaymentMethod.exxeWallet.serverString)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Text(
                                (GetIt.I<AppState>()
                                            .currentState
                                            .wallet
                                            ?.availableMoney
                                            ?.ceil() ??
                                        0)
                                    .currencyFormat,
                                style: AppStyles.s12w6
                                    .withColor(AppColors.primaryMain)),
                          ),
                        Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Text(
                                e.brief != null
                                    ? e.brief!
                                    : e.provider ==
                                            RemainingPaymentMethod
                                                .exxeWallet.serverString
                                        ? "Chọn Tài khoản EXXE"
                                        : "Chọn để thêm thẻ",
                                style: AppStyles.s10w4
                                    .withColor(AppColors.gray70x76))),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
