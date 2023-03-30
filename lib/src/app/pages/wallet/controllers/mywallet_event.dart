part of 'mywallet_bloc.dart';

abstract class MyWalletEvent {
  const MyWalletEvent();
}

class LoadWalletEvent extends MyWalletEvent {
  const LoadWalletEvent();
}

class UpdateWalletEvent extends MyWalletEvent {
  final WalletModel wallet;

  UpdateWalletEvent(this.wallet);

  List<Object> get props => [wallet];
}

class UpdateFilter extends MyWalletEvent {
  final PickerDateRange? range;
  final List<PaymentPurposeGroup>? paymentPurposeGroup;

  const UpdateFilter({
    this.range,
    this.paymentPurposeGroup,
  });

  List<Object?> get props => [range, paymentPurposeGroup];
}
