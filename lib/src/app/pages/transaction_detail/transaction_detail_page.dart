import '../../../data/data.dart';
import '../../../storage/models/transaction.dart';
import '../../../utils/export/ui_export.dart';
import 'components/body_transaction_detail.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({
    Key? key,
    required this.paymentId,
    this.vnPayCode,
  }) : super(key: key);
  final num paymentId;
  final String? vnPayCode;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage>
    with WidgetsBindingObserver {
  TransactionDetailModel? transaction;
  String? responseCode;
  late final IWalletRepo repo;
  late DebounceHelper debounceHelper;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debounceHelper = DebounceHelper(milliseconds: 5 * 1000);
    repo = GetIt.I();
    if (widget.vnPayCode != null) {
      _handleVnpayReturn();
    } else {
      repo.getTransactionDetail(widget.paymentId.ceil()).then((either) {
        either.fold((failure) {
          log(failure.toString());
        }, (data) {
          _handlePaymentSuccess(data);
        });
      });
    }
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
      if (widget.vnPayCode != null) {
        _handleVnpayReturn();
      }
    } else {
      debounceHelper.timer?.cancel();
    }
  }

  _handleVnpayReturn() async {
    var result = await repo.getTransactionState(widget.vnPayCode!);
    result.fold((failure) {
      log('failed $failure');
    }, (data) {
      if (data.bankTransactionCode != null) {
        TransactionHiveBox.instance.deleteTransaction(widget.vnPayCode!);
        responseCode = data.bankTransactionCode;
        if (mounted) {
          setState(() {});
        }
      }
    });
    if (responseCode == null) {
      debounceHelper.run(_handleVnpayReturn);
    } else if (responseCode == "00") {
      confirmPayment(widget.paymentId);
    }
  }

  confirmPayment(num id) async {
    var result = await repo.confirmWalletRechargeRequest(id);
    await result.fold((failure) {
      log('failed $failure');
    }, (data) {
      log('success $data');
      GetIt.I<AppState>().createAction(ActionStateEnum.recharge);
      return repo.getTransactionDetail(id).then((either) {
        either.fold((failure) {
          log(failure.toString());
        }, (data) {
          _handlePaymentSuccess(data);
        });
      });
    });
  }

  _handlePaymentSuccess(TransactionDetailModel data) {
    if (mounted) {
      setState(() {
        transaction = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (transaction != null) {
          return true;
        }
        if (responseCode == null) {
          AppDialog.I.showWarning(
            message:
                'Giao dich chưa hoàn thành. Bạn có chắn muốn kết thúc giao dịch',
            confirmTitle: 'Xác nhận',
            onConfirm: () {
              AppDialog.I.closeDialog();
              TransactionHiveBox.instance.deleteTransaction(widget.vnPayCode);
              Navigator.pop(context);
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
          centerTitle: true,
          autoGeneraIconLeading: true,
          title: 'Chi tiết giao dịch',
          fontSizeTitle: 18,
          context: context,
          backgroundColor:
              AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.95),
          comeBack: () {
            Navigator.of(context).maybePop();
          },
        ),
        body: Stack(
          fit: StackFit.loose,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primaryMain +
                    AppColors.primaryLight.withOpacity(0.95),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: (responseCode != '00' && responseCode != null) ||
                      transaction == null
                  ? _buildDetailFail()
                  : BodyTransactionDetail(transaction: transaction!),
            ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            responseCode != null
                ? Container(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                    child: ButtonWidget(
                      onClick: () {
                        Navigator.pushReplacementNamed(
                            context, Routes.rechargePage);
                      },
                      backgroundColor: AppColors.primaryMain,
                      child: Text(
                        responseCode == "00" ? "Nạp thêm" : "Nạp lại",
                        style:
                            AppStyles.s16w6.withColor(AppColors.primaryLight),
                      ),
                    ),
                  )
                : const SizedBox(),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: ButtonWidget(
                onClick: () {
                  Navigator.of(context).maybePop();
                },
                backgroundColor: AppColors.primaryMain +
                    AppColors.primaryLight.withOpacity(0.95),
                child: Text(
                  "Đóng",
                  style: AppStyles.s16w6.withColor(AppColors.primaryMain),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDetailFail() {
    return Container(
      width: MediaQuery.of(context).size.width,
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: (responseCode != null && responseCode != "00")
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Nạp tiền vào tài khoản"),
                const SizedBox(height: 12),
                SvgPicture.asset(
                  AppIcons.warning,
                  color: AppColors.accRedMain,
                  width: 87,
                  height: 87,
                ),
                const SizedBox(height: 24),
                Text(
                  "Nạp tiền vào tài khoản thất bại !",
                  style: AppStyles.s16w6.withColor(AppColors.black),
                ),
              ],
            )
          : SizedBox(
              height: 150,
              child: const SizedBox().appCenterProgressLoading,
            ),
    );
  }
}
