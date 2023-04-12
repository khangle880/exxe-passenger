import '../../../data/data.dart';
import '../../../storage/models/transaction.dart';
import '../../../utils/export/ui_export.dart';
import 'components/bottom_buttons.dart';
import 'components/payment_state.dart';

class DepositDetailPage extends StatefulWidget {
  final CompoundingCarCustomerModel customer;
  final String? vnpCode;

  const DepositDetailPage({
    super.key,
    required this.customer,
    this.vnpCode,
  });

  @override
  State<DepositDetailPage> createState() => _DepositDetailPageState();
}

class _DepositDetailPageState extends State<DepositDetailPage>
    with WidgetsBindingObserver {
  late final CompoundingCarControllerRepo repo;
  String? responseCode;
  late CompoundingCarCustomerModel carCustomer;
  late DebounceHelper debounceHelper;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debounceHelper = DebounceHelper(milliseconds: 5 * 1000);
    repo = GetIt.I();
    carCustomer = widget.customer;
    if (widget.vnpCode != null) {
      _handleVnpayReturn();
    } else {
      responseCode = "00";
      setState(() {});
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    debounceHelper.timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (widget.vnpCode != null) {
        _handleVnpayReturn();
      }
    } else {
      debounceHelper.timer?.cancel();
    }
  }

  confirmPayment(num id) async {
    var result = await repo.confirmCompoundingPayment(id);
    result.fold((failure) {
      log('failed $failure');
    }, (data) async {
      log('success $data');
      GetIt.I<AppState>().createAction(ActionStateEnum.recharge);
      final result = await repo.getDetailCompoundingCarCustomer(
          carCustomer.compoundingCarCustomerId!);
      result.fold(
        (l) => log(l.toString()),
        (data) {
          if (mounted) {
            setState(() {
              carCustomer = data;
            });
          }
        },
      );
    });
  }

  _handleVnpayReturn() async {
    var result = await repo.getTransactionState(
        carCustomer.compoundingCarCustomerId!, widget.vnpCode!);
    result.fold((failure) {
      log('failed $failure');
    }, (data) {
      if (data.bankTransactionCode != null) {
        TransactionHiveBox.instance.deleteTransaction(widget.vnpCode);
        responseCode = data.bankTransactionCode;
        if (mounted) {
          setState(() {});
        }
      }
    });
    if (responseCode == null) {
      debounceHelper.run(_handleVnpayReturn);
    } else if (responseCode == "00") {
      confirmPayment(carCustomer.compoundingCarCustomerId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (responseCode == null) {
          AppDialog.I.showWarning(
            message:
                'Giao dich chưa hoàn thành. Bạn có chắn muốn kết thúc giao dịch',
            confirmTitle: 'Xác nhận',
            onConfirm: () {
              AppDialog.I.closeDialog();
              TransactionHiveBox.instance.deleteTransaction(widget.vnpCode);
              Navigator.popUntil(context, ModalRoute.withName(Routes.home));
            },
          );
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.greyLight,
        appBar: CustomAppBarWidget(
          title: 'Chi tiết chuyến đi',
          context: context,
          backgroundColor: AppColors.greyLight,
          comeBack: () {
            Navigator.of(context).maybePop();
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: Column(
              children: [
                PaymentState(
                  state: carCustomer.state!.index >=
                          CompoundingCarCustomerState.deposit.index
                      ? "success"
                      : responseCode == null || responseCode == "00"
                          ? "waiting"
                          : "error",
                  paymentCode: carCustomer.compoundingCarCustomerCode!,
                  message:
                      VnpayResponseModel.vnpayResponseMessage[responseCode],
                ),
                const SizedBox(height: 24),
                BookingInfoWidget.topCollapsed(carCustomer),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CarDetail(carCustomer),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Chi phí", style: AppStyles.s18w7)),
                      const SizedBox(height: 8),
                      RidePaymentInfo(carCustomer),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.fromLTRB(24, 12, 24, 20),
          child: BottomButtons(
            responseCode: responseCode,
            customer: carCustomer,
          ),
        ),
      ),
    );
  }
}
