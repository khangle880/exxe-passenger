import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import '../../storage/models/user.dart';
import '../data.dart';

class SplashRepo extends ISplashRepo {
  late final INetworkUtility _networkUtility;

  SplashRepo() : _networkUtility = GetIt.I.get<INetworkUtility>();

  @override
  Future<Either<Failure, WalletModel>> example() async {
    try {
      final token = await BoxesUser.instance.getDataTokenUser();
      final response = await _networkUtility
          .request('/wallet_controller/get_list_journal', Method.POST, data: {
        "params": {"token": token}
      });

      SingleResponse<WalletModel> wallet = SingleResponse<WalletModel>(
          response, (data) => WalletModel.fromJson(data));

      if (wallet.error != null) {
        return Left(ServerFailure(wallet.error!));
      }
      return Right(wallet.item!);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
