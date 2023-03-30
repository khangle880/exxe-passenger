part of 'register_bank_account_cubit.dart';

class RegisterBankAccountState extends Equatable {
  final String? accountNumber;
  final String? bankOwner;
  final DateTime? bankExpireDate;
  final BankModel? selectedBank;
  final List<BankModel>? banks;
  final BankAccountModel? account;

  const RegisterBankAccountState({
    this.accountNumber,
    this.bankOwner,
    this.bankExpireDate,
    this.selectedBank,
    this.banks,
    this.account,
  });

  RegisterBankAccountState copyWith({
    String? accountNumber,
    String? bankOwner,
    DateTime? bankExpireDate,
    BankModel? selectedBank,
    List<BankModel>? banks,
    BankAccountModel? account,
  }) {
    return RegisterBankAccountState(
      accountNumber: accountNumber ?? this.accountNumber,
      bankOwner: bankOwner ?? this.bankOwner,
      bankExpireDate: bankExpireDate ?? this.bankExpireDate,
      selectedBank: selectedBank ?? this.selectedBank,
      banks: banks ?? this.banks,
      account: account ?? this.account,
    );
  }

  @override
  List<Object?> get props => [
        accountNumber,
        bankOwner,
        bankExpireDate,
        selectedBank,
        banks,
        account,
      ];
}
