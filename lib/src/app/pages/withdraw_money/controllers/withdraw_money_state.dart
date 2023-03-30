part of 'withdraw_money_cubit.dart';

class WithdrawMoneyState extends Equatable {
  final int? amount;
  final JournalModel? cashJournal;

  @override
  List<Object?> get props => [
        amount,
        cashJournal,
      ];

  const WithdrawMoneyState({
    this.amount,
    this.cashJournal,
  });

  WithdrawMoneyState copyWith({
    int? amount,
    JournalModel? cashJournal,
  }) {
    return WithdrawMoneyState(
      amount: amount ?? this.amount,
      cashJournal: cashJournal ?? this.cashJournal,
    );
  }
}
