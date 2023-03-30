import 'package:exxe/src/app/common/widgets/booking/ride_payment_info.dart';

import '../../../data/data.dart';
import '../../../storage/models/transaction.dart';
import '../../../utils/export/ui_export.dart';
import '../../common/widgets/count_down_text.dart';
import '../deposit_methods/payment_methods_page.dart';

class DepositPage extends StatefulWidget {
  const DepositPage(this.customer, {Key? key}) : super(key: key);
  final CompoundingCarCustomerModel customer;

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  List<PaymentMethodModel>? paymentMethods;
  PaymentMethodModel? currentPaymentMethod;

  CompoundingCarCustomerModel? customer;

  late RemoveListener removeListener;

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    customer = widget.customer.copyWith(secondRemains: -1);
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.action == ActionStateEnum.updateWallet && state.isNewAction) {
        getPaymentMethods();
      }
    });
    getPaymentMethods();
    loadCustomer();
  }

  loadCustomer() async {
    await CompoundingCarControllerRepo()
        .getDetailCompoundingCarCustomer(
            widget.customer.compoundingCarCustomerId!)
        .then((either) {
      either.fold((l) => log(l.toString()), (data) {
        customer = data;
        setState(() {});
      });
    });
  }

  void getPaymentMethods() async {
    var result = await CompoundingCarControllerRepo().getPaymentInAppMethods();
    result.fold((failure) {
      log(failure.toString());
    }, (data) {
      paymentMethods = data;
      currentPaymentMethod = data.firstWhereOrNull(
          (e) => e.acquirerId == currentPaymentMethod?.acquirerId);
      if (mounted) {
        setState(() {});
      }
      log(data.toString());
    });
  }

  void openSelectMethodPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodsPage(
            paymentMethods: paymentMethods,
            selectedPaymentMethod: currentPaymentMethod,
            onSelect: (method) {
              currentPaymentMethod = method;
              setState(() {});
            }),
      ),
    );
  }

  createPaymentRequest() async {
    if (currentPaymentMethod == null) {
      AppDialog.I.showNotification(
        message: "Chọn phương thức thanh toán trước khi đặt cọc",
        barrierDismissible: false,
      );
    } else {
      if (currentPaymentMethod!.moneyInCashWallet != null &&
          (customer?.downPayment?.total ?? 0) >=
              currentPaymentMethod!.moneyInCashWallet!) {
        AppDialog.I.showWarning(
          message: "Số tiền trong tài khoản của bạn không đủ để thanh toán",
          onConfirm: () {
            AppDialog.I.closeDialog();
            Navigator.pushNamed(context, Routes.rechargePage);
          },
          confirmTitle: "Nạp thêm",
          hasCancel: true,
        );
      } else {
        AppDialog.I.showLoading();
        var result = await CompoundingCarControllerRepo().createVNPayPayment(
          customerId: customer!.compoundingCarCustomerId!,
          methodId: currentPaymentMethod!.acquirerId!,
          returnUrl:
              "https://blog-client-alpha.vercel.app/checking-checkout-status",
        );
        AppDialog.I.closeDialog();

        result.fold((failure) {
          log(failure.toString());
          failure.showDefaultDialog();
        }, (data) async {
          if (data.provider == "vnpay") {
            log('save to local storgae');
            TransactionHiveBox.instance.saveTransaction(
              TransactionHiveModel(
                vnPayCode: data.vnpayCode!,
                compoundingCarCustomerId:
                    customer!.compoundingCarCustomerId.toString(),
              ),
            );
            AppMethodChannel.I.openVnpaySdk(data.vnpayPaymentUrl!);
          } else {
            GetIt.I<AppState>().createAction(ActionStateEnum.withdraw);
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.depositDetail,
            ModalRoute.withName(Routes.home),
            arguments: {
              "customer": data.customer ?? customer,
              "vnpCode": data.vnpayCode,
            },
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (customer == null) {
      return Scaffold(body: const SizedBox().appCenterProgressLoading);
    }
    return Scaffold(
      backgroundColor: AppColors.gray05,
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.greyLight,
        title: "Đặt cọc",
        context: context,
      ),
      bottomNavigationBar: Container(
        color: AppColors.gray05,
        width: MediaQuery.of(context).size.width,
        padding:
            const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: ButtonWidgetOld(
            onClick: createPaymentRequest,
            radius: 12.0,
            child: Text("Đặt cọc",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: BookingInfoWidget.topCollapsed(widget.customer),
            ),
            Container(
              color: AppColors.greyLight,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Phương thức thanh toán",
                          style: AppStyles.s18w7.withColor(AppColors.gray95),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          AppIcons.directionRight,
                          width: 30,
                          height: 30,
                        ).inkWell(onTap: openSelectMethodPage),
                      )
                    ],
                  ),
                  _buildPaymentMethods(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Hoá đơn",
                              style: AppStyles.s18w7
                                  .withColor(AppColors.gray95x06),
                            )),
                      ),
                      _buildCowntDown()
                    ],
                  ),
                  const SizedBox(height: 8),
                  RidePaymentInfo(customer!),
                  const SizedBox(height: 8),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "(*) Số tiền này chưa bao gồm chi phí cầu đường, bãi bến",
                      style: AppStyles.s14w4.withColor(AppColors.gray70x76),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCowntDown() {
    if (customer?.secondRemains == null || customer!.secondRemains! < 0) {
      return const SizedBox();
    }
    return CountDownText(
      textStyle: (waiting) => AppStyles.s14w7.withColor(AppColors.utilRed),
      endTime: DateTime.now()
          .add(Duration(seconds: customer!.secondRemains?.ceil() ?? 0))
          .millisecondsSinceEpoch,
      onEnd: () {
        AppDialog.I.showWarning(
            message: "Đã hết thời gian đặt cọc",
            barrierDismissible: false,
            onConfirm: () {
              CompoundingCarControllerRepo().depositTimeOutCarCustomer(
                  compoundingCarCustomerId:
                      customer!.compoundingCarCustomerId!);
              AppDialog.I.closeDialog();
              Navigator.popUntil(context, ModalRoute.withName(Routes.home));
            });
      },
    );
  }

  Widget _buildPaymentMethods() {
    if (paymentMethods == null) {
      return SizedBox(
        height: 80,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (_, __) {
              return PaymentMethodsWidget.shimmer();
            }),
      );
    }
    if (paymentMethods!.isEmpty) return const Text('Empty');
    return PaymentMethodsWidget(
        paymentMethods: paymentMethods,
        currentPaymentMethod: currentPaymentMethod,
        onChanged: (value) {
          currentPaymentMethod = value;
          setState(() {});
        });
  }
}
