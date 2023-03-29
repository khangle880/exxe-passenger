import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../../utils/utils.dart';
import '../data.dart';

class WalletRepo extends IWalletRepo {
  late final INetworkUtility _networkUtility;

  WalletRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, WalletModel>> getWalletJournal({
    int? limit,
    int? offset,
    DateTime? startDate,
    DateTime? endDate,
    List<PaymentPurpose>? paymentPurpose,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "limit": limit,
      "offset": offset ?? 0,
      "start_date": startDate?.serverFormatOnlyDate,
      "end_date": endDate?.serverFormatOnlyDate,
      "payment_purpose": paymentPurpose?.map((e) => e.serverString).toList(),
    }.getCleanNull;

    final request = _networkUtility.request(
        Apis.getWalletJournalRequest, Method.POST,
        data: {"params": params});

    return ParserHelper.singleParseDefault(
        request, (json) => WalletModel.fromJson(json));
  }

  @override
  Future<Either<Failure, AvailableMoneyModel>>
      getAvailableMoneyInCashWallet() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getAvailableMoneyInCashWalletRequest, Method.POST, data: {
      "params": {"token": token}
    });

    return ParserHelper.singleParseDefault(
        request, (json) => AvailableMoneyModel.fromJson(json));
  }

  @override
  Future<Either<Failure, List<FilteredTransactionsModel>>>
      getTransactionsByJournal({
    /// Id of wallet
    int? paymentId,
    String? startDate,
    String? endDate,
    int? limit,
    int? offset,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "payment_id": paymentId,
      "start_date": startDate,
      "end_date": endDate,
      "limit": 20,
      "offset": 0
    }.getCleanNull;

    final request = _networkUtility.request(
        Apis.getListTransactionByJournalRequest, Method.POST,
        data: {"params": params});

    return ParserHelper.listParseDefault(
        request, (json) => FilteredTransactionsModel.fromJson(json));
  }

  @override
  Future<Either<Failure, TransactionDetailModel>> getTransactionDetail(
      num paymentId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getTransactionDetailRequest, Method.POST, data: {
      "params": {"token": token, "payment_id": paymentId}
    });
    return ParserHelper.singleParseDefault(
        request, TransactionDetailModel.fromJson);
  }

  @override
  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentMethods() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getPaymentRechargeMethods, Method.POST, data: {
      "params": {"token": token}
    });

    return ParserHelper.listParseDefault(request, PaymentMethodModel.fromJson);
  }

  @override
  Future<Either<Failure, PaymentRequestModel>> createWalletRechargeRequest({
    required num amount,
    required num acquirerId,
    required String returnedUrl,
    num? journalId,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "amount": amount,
      "returned_url": returnedUrl,
      "acquirer_id": acquirerId,
      "journal_id": journalId
    }.getCleanNull;

    final request = _networkUtility.request(
        Apis.createWalletRechargeRequest, Method.POST,
        data: {"params": params});

    return ParserHelper.singleParseDefault(
        request, PaymentRequestModel.fromJson);
  }

  @override
  Future<Either<Failure, PaymentModel>> confirmWalletRechargeRequest(
      num paymentId) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.confirmWalletRechargeRequest, Method.POST, data: {
      "params": {"token": token, "payment_id": paymentId}
    });

    return ParserHelper.singleParseDefault(request, PaymentModel.fromJson);
  }

  @override
  Future<Either<Failure, num>> getAvailableMoneyCanWithdrawing() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility
        .request(Apis.getAvailableMoneyCanWithdrawing, Method.POST, data: {
      "params": {"token": token}
    });

    return ParserHelper.singleParseDefault(
        request, (json) => json['available_money_can_withdraw']);
  }

  @override
  Future<Either<Failure, PaymentModel>> createWithdrawingRequest(
      {required num amount, num? journalId}) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {"token": token, "journal_id": journalId, "amount": amount}
        .getCleanNull;
    final request = _networkUtility.request(
        Apis.createWithdrawingRequest, Method.POST,
        data: {"params": params});
    return ParserHelper.singleParseDefault(request, PaymentModel.fromJson);
  }

  @override
  Future<Either<Failure, VnpayResponseModel>> getTransactionState(
      String vnPayCode) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request =
        _networkUtility.request(Apis.getTransactionState, Method.POST, data: {
      "params": {
        "token": token,
        "vnpay_code": vnPayCode,
      }
    });
    return ParserHelper.singleParseDefault(
        request, VnpayResponseModel.fromJson);
  }

  @override
  Future<Either<Failure, BankAccountModel>> getAccountBank() async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final request = _networkUtility.request(
      Apis.getAccountBank,
      Method.POST,
      data: {
        "params": {
          "token": token,
        }
      },
    );
    return ParserHelper.singleParseDefault(request, BankAccountModel.fromJson);
  }

  @override
  Future<Either<Failure, List<BankModel>>> getListBank() async {
    final request = _networkUtility.request(
      Apis.getListBank,
      Method.POST,
      data: {
        "params": {},
      },
    );
    return ParserHelper.listParseDefault(request, BankModel.fromJson);
  }

  @override
  Future<Either<Failure, dynamic>> updateAccountBank({
    required int bankId,
    required String accountNumber,
    required String bankOwner,
    required DateTime bankExpireDate,
  }) async {
    final token = await BoxesUser.instance.getDataTokenUser();
    final params = {
      "token": token,
      "bank_id": bankId,
      "account_number": accountNumber,
      "bank_owner": bankOwner,
      "bank_expire_date": bankExpireDate.serverFormatOnlyDate,
    };
    final request = _networkUtility.request(
      Apis.updateAccountBank,
      Method.POST,
      data: {
        "params": params,
      },
    );
    return ParserHelper.listParseDefault(request, (value) => null);
  }
}
