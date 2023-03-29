import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../data.dart';

abstract class ISplashRepo {
  Future<Either<Failure, WalletModel>> example();
}
