import '../../../../data/models/models.dart';
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

  static shimmer() {
    return const PaymentMethodsWidgetShimmer();
  }

  @override
  Widget build(BuildContext context) {
    if (paymentMethods == null) {
      return SizedBox(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            5,
            (index) => const PaymentMethodsWidgetShimmer(),
          ),
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
            .map((e) => PaymentMethodItem(
                  method: e,
                  onChanged: onChanged,
                  isSelected: e == currentPaymentMethod,
                ))
            .toList(),
      ),
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem(
      {Key? key,
      required this.method,
      required this.onChanged,
      required this.isSelected,
      this.icon})
      : super(key: key);
  final PaymentMethodModel method;
  final Function(PaymentMethodModel method) onChanged;
  final bool isSelected;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(method);
      },
      child: Container(
        width: 150,
        height: 80,
        margin: const EdgeInsets.only(right: 10, left: 2),
        padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
        alignment: Alignment.topLeft,
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.primaryMainBlur,
                border: Border.all(color: AppColors.primaryMain),
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 1),
                        blurRadius: 7,
                        spreadRadius: -2,
                        color: AppColors.primaryLight.withOpacity(0.05)),
                    BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 15,
                        spreadRadius: -3,
                        color: const Color(0xFFCACACA).withOpacity(0.1)),
                  ])
            : BoxDecoration(
                color: AppColors.primaryLight,
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.gray10, blurRadius: 1, spreadRadius: 1)
                ],
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon ??
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CachedNetworkImage(
                        imageUrl: Apis.baseUrl + (method.imageUrl?.url ?? ""),
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height: 24,
                            width: 24,
                            color: Colors.grey,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                const SizedBox(width: 4),
                Text(method.name!,
                    style: AppStyles.s14w6.withColor(
                      isSelected ? AppColors.primaryMain : AppColors.gray60x9d,
                    )),
              ],
            ),
            const Spacer(),
            Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Text(
                    method.brief != null ? method.brief! : "Chọn để thêm thẻ",
                    style: method.moneyInCashWallet != null
                        ? AppStyles.s14w7.withColor(AppColors.primaryMain)
                        : AppStyles.s12w5.withColor(AppColors.gray70x76))),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodsWidgetShimmer extends StatelessWidget {
  const PaymentMethodsWidgetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 80,
      margin: const EdgeInsets.only(right: 10, left: 2),
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
      alignment: Alignment.topLeft,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        boxShadow: [
          BoxShadow(color: AppColors.gray10, blurRadius: 1, spreadRadius: 1)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerUtils.buildShimmer(
                  child: SvgPicture.asset(
                AppIcons.imagePicker,
                width: 20,
                height: 20,
              )),
              const SizedBox(width: 8),
              ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                  text: "tai khoan exxe"),
            ],
          ),
          const Spacer(),
          ShimmerUtils.buildShimmerWithText(AppStyles.s10w4,
              text: "chon de them the"),
          const SizedBox(
            height: 8,
          )
        ],
      ),
    );
  }
}
