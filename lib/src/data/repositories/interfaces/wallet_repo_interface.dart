import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../../utils/constants/constants.dart';
import '../../models/models.dart';

abstract class IWalletRepo {
  Future<Either<Failure, WalletModel>> getWalletJournal({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    List<PaymentPurpose>? paymentPurpose,
  });

  Future<Either<Failure, AvailableMoneyModel>> getAvailableMoneyInCashWallet();

  Future<Either<Failure, List<FilteredTransactionsModel>>>
      getTransactionsByJournal(
          {int paymentId,
          String startDate,
          String endDate,
          int limit,
          int offset});

  Future<Either<Failure, TransactionDetailModel>> getTransactionDetail(
      num paymentId);

  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentMethods();

  Future<Either<Failure, PaymentRequestModel>> createWalletRechargeRequest({
    required num amount,
    required num acquirerId,
    required String returnedUrl,
    num? journalId,
  });

  Future<Either<Failure, num>> getAvailableMoneyCanWithdrawing();

  Future<Either<Failure, PaymentModel>> confirmWalletRechargeRequest(
      num paymentId);

  Future<Either<Failure, PaymentModel>> createWithdrawingRequest({
    required num amount,
    num? journalId,
  });

  Future<Either<Failure, VnpayResponseModel>> getTransactionState(
    String vnPayCode,
  );

  Future<Either<Failure, BankAccountModel>> getAccountBank();

  Future<Either<Failure, List<BankModel>>> getListBank();

  Future<Either<Failure, dynamic>> updateAccountBank({
    required int bankId,
    required String accountNumber,
    required String bankOwner,
    required DateTime bankExpireDate,
  });
}
