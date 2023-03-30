import 'package:equatable/equatable.dart';

import '../../../../utils/export/logic_export.dart';

part 'withdraw_money_state.dart';

class WithdrawMoneyCubit extends BaseCubit<WithdrawMoneyState> {
  final IWalletRepo walletRepo;

  WithdrawMoneyCubit(this.walletRepo) : super(const WithdrawMoneyState());

  getAvailableMoney() async {
    JournalModel? cashJournal;

    await walletRepo.getWalletJournal().then((either) {
      either.fold((failure) {
        log(failure.toString());
      }, (data) {
        cashJournal = data.journal
            ?.where((element) => element.journalType == JournalType.cash)
            .first;
      });
    });

    emit(state.copyWith(cashJournal: cashJournal));
  }

  changeAmount(int amount) {
    emit(state.copyWith(amount: amount));
  }

  Future<PaymentModel> createPaymentRequest() async {
    emitWaiting(true);
    var result = await walletRepo.createWithdrawingRequest(
      amount: state.amount!,
      journalId: state.cashJournal!.journalId,
    );
    emitWaiting(false);
    return result.fold((failure) {
      log(failure.toString());
      return Future.error(failure);
    }, (data) {
      log(data.toString());
      GetIt.I<AppState>().createAction(ActionStateEnum.withdraw);
      return data;
    });
  }
}
