part of 'recharge_money_cubit.dart';

class RechargeMoneyState extends Equatable {
  final List<PaymentMethodModel>? paymentMethods;
  final PaymentMethodModel? currentMethod;
  final int? amount;
  final JournalModel? cashJournal;
  final PaymentRequestModel? paymentRequest;

  @override
  List<Object?> get props =>
      [paymentMethods, currentMethod, amount, cashJournal, paymentRequest];

  const RechargeMoneyState({
    this.paymentMethods,
    this.currentMethod,
    this.amount,
    this.cashJournal,
    this.paymentRequest,
  });

  RechargeMoneyState copyWith({
    List<PaymentMethodModel>? paymentMethods,
    PaymentMethodModel? currentMethod,
    int? amount,
    JournalModel? cashJournal,
    PaymentRequestModel? paymentRequest,
  }) {
    return RechargeMoneyState(
      paymentMethods: paymentMethods ?? this.paymentMethods,
      currentMethod: currentMethod ?? this.currentMethod,
      amount: amount ?? this.amount,
      cashJournal: cashJournal ?? this.cashJournal,
      paymentRequest: paymentRequest ?? this.paymentRequest,
    );
  }
}
