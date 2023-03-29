import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class FinalPaymentMethods extends StatefulWidget {
  const FinalPaymentMethods(this.customer,
      {Key? key, required this.onChanged, required this.currentMethod})
      : super(key: key);
  final CompoundingCarCustomerModel customer;
  final Function(PaymentMethodModel method) onChanged;
  final PaymentMethodModel? currentMethod;

  @override
  State<FinalPaymentMethods> createState() => _FinalPaymentMethodsState();
}

class _FinalPaymentMethodsState extends State<FinalPaymentMethods> {
  final PaymentMethodModel cashMethod = PaymentMethodModel(
      acquirerId: -1,
      provider: "cash",
      name: "Tiền mặt",
      brief: "Thanh toán với tài xế");
  late List<PaymentMethodModel> paymentMethods;

  late RemoveListener removeListener;

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.action == ActionStateEnum.updateWallet && state.isNewAction) {
        getPaymentMethods();
      }
    });
    getPaymentMethods();
  }

  void getPaymentMethods() async {
    paymentMethods = [cashMethod];
    var result = await CompoundingCarControllerRepo().getPaymentFinalMethods();
    result.fold((failure) {
      log(failure.toString());
    }, (data) {
      paymentMethods = [cashMethod, ...data];
      final currentPaymentMethod = data.firstWhereOrNull(
          (e) => e.acquirerId == widget.currentMethod?.acquirerId);
      widget.onChanged(currentPaymentMethod ?? cashMethod);
      if (mounted) {
        setState(() {});
      }
      log(data.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    if ((widget.customer.state == CompoundingCarCustomerState.done &&
            widget.customer.paymentMethod == null) ||
        widget.customer.state == CompoundingCarCustomerState.inProcess) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Phương thức thanh toán',
            fontSize: AppDimens.text18,
            weight: FontWeight.w700,
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: paymentMethods
                  .map((e) => PaymentMethodItem(
                        method: e,
                        onChanged: widget.onChanged,
                        isSelected: widget.currentMethod == e,
                        icon: e.provider == "cash"
                            ? SvgPicture.asset(
                                RemainingPaymentMethod.cash.iconPath,
                                color: AppColors.accBlueMain,
                              )
                            : null,
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
