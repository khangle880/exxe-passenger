import 'package:equatable/equatable.dart';
import 'package:exxe/src/utils/export/logic_export.dart';

part 'register_bank_account_state.dart';

class RegisterBankAccountCubit extends BaseCubit<RegisterBankAccountState> {
  final IWalletRepo repo;

  RegisterBankAccountCubit(this.repo) : super(const RegisterBankAccountState());

  getListBanks() async {
    emitWaiting(true);
    final result = await repo.getListBank();
    emitWaiting(false);
    result.fold(
      (failure) => log('ko lay dc bank $failure'),
      (data) => emit(state.copyWith(banks: data)),
    );
  }

  getBankAccountInformation() async {
    final result = await repo.getAccountBank();
    result.fold(
      (failure) => log('ko lay dc bank $failure'),
      (data) {
        emit(
          state.copyWith(
            selectedBank: data.bankId?.bankId == null ? null : data.bankId,
            accountNumber: data.accountNumber,
            bankOwner: data.bankOwner,
            bankExpireDate: data.bankExpireDate,
            account: data,
          ),
        );
      },
    );
  }

  getSelectedBankBank(BankModel bank) async {
    emit(state.copyWith(selectedBank: bank));
  }

  getBankOwner(String bankOwner) async {
    emit(state.copyWith(bankOwner: bankOwner));
  }

  getBankExpireDate(DateTime bankExpireDate) async {
    emit(state.copyWith(bankExpireDate: bankExpireDate));
  }

  getAccountNumber(String accountNumber) async {
    emit(state.copyWith(accountNumber: accountNumber));
  }

  Future<bool> updateBankAccount() async {
    final result = await repo.updateAccountBank(
      bankId: state.selectedBank!.bankId!,
      accountNumber: state.accountNumber!,
      bankOwner: state.bankOwner!,
      bankExpireDate: state.bankExpireDate!,
    );
    return result.fold((failure) {
      emitError(failure);
      return false;
    }, (r) {
      return true;
    });
  }
}
