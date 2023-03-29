part of 'mywallet_bloc.dart';

class MyWalletState {
  final WalletModel? wallet;
  final PickerDateRange? filterRange;
  final List<PaymentPurposeGroup>? filterPaymentGroup;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MyWalletState &&
            runtimeType == other.runtimeType &&
            wallet == other.wallet &&
            filterRange == other.filterRange &&
            filterPaymentGroup?.map((e) => e.toString()) ==
                other.filterPaymentGroup?.map((e) => e.toString());
  }

  @override
  int get hashCode =>
      wallet.hashCode ^ filterRange.hashCode ^ filterPaymentGroup.hashCode;

  const MyWalletState({
    this.filterPaymentGroup,
    this.wallet,
    this.filterRange,
  });

  MyWalletState copyWith({
    WalletModel? wallet,
    Nullable<PickerDateRange>? filterRange,
    Nullable<List<PaymentPurposeGroup>>? filterPaymentGroup,
  }) {
    return MyWalletState(
      wallet: wallet ?? this.wallet,
      filterRange: filterRange == null ? this.filterRange : filterRange.value,
      filterPaymentGroup: filterPaymentGroup == null
          ? this.filterPaymentGroup
          : filterPaymentGroup.value,
    );
  }
}

extension EnumComparisonOperators on Enum {
  bool operator <(Enum other) {
    return index < other.index;
  }

  bool operator <=(Enum other) {
    return index <= other.index;
  }

  bool operator >(Enum other) {
    return index > other.index;
  }

  bool operator >=(Enum other) {
    return index >= other.index;
  }
}
