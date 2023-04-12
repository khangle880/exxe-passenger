import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class TransactionListWidget extends StatefulWidget {
  const TransactionListWidget({
    Key? key,
    this.padding = const EdgeInsets.all(0),
    this.range,
    this.paymentPurposeGroup,
  }) : super(key: key);
  final EdgeInsets padding;
  final PickerDateRange? range;
  final List<PaymentPurposeGroup>? paymentPurposeGroup;

  @override
  State<TransactionListWidget> createState() => _TransactionListWidgetState();
}

class _TransactionListWidgetState extends State<TransactionListWidget> {
  late final IWalletRepo repo;
  late PaginationHelper<PaymentModel> controller;

  @override
  void initState() {
    super.initState();
    repo = GetIt.I();
    initController();
  }

  @override
  void didUpdateWidget(covariant TransactionListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    initController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void initController() {
    controller = PaginationHelper<PaymentModel>(
      limit: 20,
      asyncTask: (config) {
        return getTransactions(config).then((data) {
          config.canLoadMore = data.length == 20;
          return (data);
        }).catchError((e) {
          log(e.toString());
          config.canLoadMore = false;
          throw e;
        });
      },
    );
    controller.run();
  }

  Future<List<PaymentModel>> getTransactions(PaginationConfig config) async {
    var result = await repo.getWalletJournal(
      offset: config.offset,
      startDate: widget.range?.startDate,
      endDate: widget.range?.endDate,
      paymentPurpose: widget.paymentPurposeGroup == null
          ? null
          : [for (var value in widget.paymentPurposeGroup!) ...value.states],
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        final appState = GetIt.I<AppState>();
        if (checkMoneyChanged(
            data.journal, appState.currentState.wallet?.journal)) {
          appState.updateWallet(data);
        }
        return data.transaction ?? [];
      },
    );
  }

  bool checkMoneyChanged(
      List<JournalModel>? journals, List<JournalModel>? afterJournals) {
    return journals?.map<bool>((a) {
          final hasChanged = afterJournals?.firstWhereOrNull((b) =>
                  a.journalId == b.journalId &&
                  a.remainsAmount != b.remainsAmount) !=
              null;
          return hasChanged;
        }).reduce((value, element) => value || element) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: widget.padding,
          height: 32,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Lịch sử giao dịch", style: AppStyles.s18w7),
              const Spacer(),
              InkWell(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(AppIcons.filter06),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: PaginationListView(
            padding: widget.padding,
            emptyBuilder: (_) => Center(
              child: Text('Không có giao dịch gần đây', style: AppStyles.s16w6),
            ),
            loadingEffectItemBuilder: (_, index) => _buildShimmer(),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            length: () => controller.canShowItems.length,
            itemBuilder: (BuildContext context, int index) {
              final item = controller.canShowItems[index];
              return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.transactionDetail,
                      arguments: {
                        'paymentId': item.paymentId,
                      },
                    );
                  },
                  child: _buildTransactionItem(item));
            },
            paginationController: controller,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(PaymentModel item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.gray10,
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ID: ${item.paymentCode!.withEllipse}",
                  style: AppStyles.s16w6.withColor(
                      AppColors.primaryMain + AppColors.black.withOpacity(.4)),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(item.date!.getDateString.toString(),
                        style: AppStyles.s12w6.withColor(AppColors.gray70x76)),
                    Container(
                      margin: const EdgeInsets.all(8),
                      width: 3.0,
                      height: 3.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gray50,
                      ),
                    ),
                    Text(
                      item.paymentPurpose?.getStatusTitle ?? "",
                      style: AppStyles.s12w5
                          .withColor(item.paymentPurpose?.getStatusColor),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            (item.paymentPurpose?.getSign ?? "") +
                item.amount!.ceil().currencyFormat.toString(),
            style:
                AppStyles.s16w6.withColor(item.paymentPurpose?.getStatusColor),
          ),
        ],
      ),
    );
  }

  _buildShimmer() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 500.0,
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (_, __) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.gray10,
                      blurRadius: 1,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerUtils.buildShimmerWithText(AppStyles.s12w6,
                              text: "ID: 1123456789012342332"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ShimmerUtils.buildShimmerWithText(AppStyles.s12w5,
                                  text: "dd:mm:yyyy"),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              ShimmerUtils.buildShimmerWithText(AppStyles.s12w5,
                                  text: "da dat coc"),
                            ],
                          )
                        ],
                      ),
                    ),
                    ShimmerUtils.buildShimmerWithText(AppStyles.s12w5,
                        text: "2.000.000 d"),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
