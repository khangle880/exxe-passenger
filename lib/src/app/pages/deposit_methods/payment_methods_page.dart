import '../../../data/models/models.dart';
import '../../../utils/export/ui_export.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({
    Key? key,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
    required this.onSelect,
  }) : super(key: key);

  final List<PaymentMethodModel>? paymentMethods;
  final PaymentMethodModel? selectedPaymentMethod;
  final Function(PaymentMethodModel method) onSelect;

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  late PaymentMethodModel? _paymentMethod;

  @override
  void initState() {
    super.initState();
    _paymentMethod = widget.selectedPaymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray05,
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.greyLight,
        title: "Phương thức thanh toán",
        context: context,
      ),
      bottomNavigationBar: Container(
        padding:
            const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
        child: ButtonWidgetOld(
          onClick: _paymentMethod == null
              ? null
              : () {
                  widget.onSelect(_paymentMethod!);
                  Navigator.pop(context);
                },
          radius: 12.0,
          child: Text(
            "Chọn",
            style: AppStyles.s16w6.withColor(AppColors.primaryLight),
          ),
        ),
      ),
      body: widget.paymentMethods == null
          ? _buildShimmer()
          : (widget.paymentMethods!.isEmpty)
              ? const Text('Empty')
              : SingleChildScrollView(
                  child: Container(
                    color: AppColors.gray05,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.topLeft,
                      color: AppColors.gray05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 9),
                          Text("Hãy chọn phương thức thanh toán",
                              style: AppStyles.s14w4
                                  .withColor(AppColors.gray70x76)),
                          const SizedBox(height: 16),
                          ...widget.paymentMethods!
                              .map((e) => GestureDetector(
                                    onTap: () {
                                      _paymentMethod = e;
                                      setState(() {});
                                    },
                                    child: _buildMethod(e),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  _buildMethod(PaymentMethodModel e) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: e == _paymentMethod
              ? AppColors.primaryMainBlur
              : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: e == _paymentMethod
                ? AppColors.primaryMain
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CachedNetworkImage(
                imageUrl: Apis.baseUrl + (e.imageUrl?.url ?? ""),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.name!,
                  style: AppStyles.s16w6,
                ),
                const SizedBox(height: 4),
                Text(
                  e.brief != null ? e.brief! : "Chọn để thêm thẻ",
                  style: e.moneyInCashWallet != null
                      ? AppStyles.s14w7.withColor(AppColors.primaryMain)
                      : AppStyles.s12w5.withColor(AppColors.gray70x76),
                ),
              ],
            ),
          ],
        ),
      ).inkWell(onTap: () {
        _paymentMethod = e;
        setState(() {});
      }),
    );
  }

  _buildShimmer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.topLeft,
      color: AppColors.gray05,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 9),
          Text("Hãy chọn phương thức thanh toán",
              style: AppStyles.s14w4.withColor(AppColors.gray70x76)),
          const SizedBox(height: 16),
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                padding: const EdgeInsets.only(top: 8, left: 8),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ShimmerUtils.buildShimmer(
                            child: SvgPicture.asset(
                          AppIcons.imagePicker,
                          width: 24,
                          height: 24,
                        )),
                        const SizedBox(width: 8),
                        ShimmerUtils.buildShimmerWithText(AppStyles.s16w6,
                            text: " Tai khona 3xxe dd"),
                        const Spacer(),
                        ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                            text: "20.0000.000 d")
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 4, left: 32),
                        child: ShimmerUtils.buildShimmerWithText(
                            AppStyles.s10w4,
                            text: "chon vis de them the")),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ],
      ),
    );
  }
}
