import 'package:equatable/equatable.dart';

import '../../../../storage/models/transaction.dart';
import '../../../../utils/export/logic_export.dart';

part 'recharge_money_state.dart';

class RechargeMoneyCubit extends BaseCubit<RechargeMoneyState> {
  final IWalletRepo walletRepo;
  List<PaymentMethodModel> methods = [];

  RechargeMoneyCubit(this.walletRepo) : super(const RechargeMoneyState());

  getListRechargeMethod() async {
    List<PaymentMethodModel>? methods;
    JournalModel? cashJournal;
    await walletRepo.getPaymentMethods().then((either) {
      either.fold((failure) {
        log(failure.toString());
        emitError(failure);
      }, (data) {
        methods = data;
      });
    });

    await walletRepo.getWalletJournal().then((either) {
      either.fold((failure) {
        log(failure.toString());
        emitError(failure);
      }, (data) {
        cashJournal = data.journal
            ?.where((element) => element.journalType == JournalType.cash)
            .first;
      });
    });

    emit(state.copyWith(paymentMethods: methods, cashJournal: cashJournal));
  }

  changeCurrentMethod(PaymentMethodModel method) {
    emit(state.copyWith(currentMethod: method));
  }

  changeAmount(int amount) {
    emit(state.copyWith(amount: amount));
  }

  createPaymentRequest() async {
    emitWaiting(true);
    var result = await walletRepo.createWalletRechargeRequest(
      amount: state.amount!,
      acquirerId: state.currentMethod!.acquirerId!,
      journalId: state.cashJournal!.journalId,
      returnedUrl: 'https://blog-client-alpha.vercel.app/checking-checkout-status',
    );
    emitWaiting(false);
    result.fold((failure) {
      log(failure.toString());
      emitError(failure);
    }, (data) async {
      log(data.toString());
      await TransactionHiveBox.instance.saveTransaction(
        TransactionHiveModel(
          vnPayCode: data.vnpayCode!,
          paymentId: data.paymentId!.toString(),
        ),
      );
      emit(state.copyWith(paymentRequest: data));
    });
  }
}
