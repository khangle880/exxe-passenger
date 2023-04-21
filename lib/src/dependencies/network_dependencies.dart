import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../app/common/common.dart';
import '../core/network/network.dart';
import '../data/apis.dart';

class NetworkDependencies {
  static Future setup(GetIt injector) async {
    injector.registerLazySingleton<InternetConnectionCheckerPlus>(
        () => InternetConnectionCheckerPlus());

    injector.registerLazySingleton<INetworkInfo>(() => NetworkInfo(injector()));
    // network utility for request

    injector.registerLazySingleton<LoggerFbInterceptor>(
      () => LoggerFbInterceptor(
        chatId: -876266165,
        token: "6157545495:AAHg3r-z3TQY1fnffvKNxE0K2-f3fCfJhxk",
        projectId: 'exxe',
        willSendSuccess: true,
      ),
    );

    injector.registerLazySingleton<INetworkUtility>(
      () => NetworkUtility(
        Apis.baseUrl,
        // TODO: remove this
        interceptors: [
          injector<LoggerFbInterceptor>(),
        ],
      ),
    );
    injector.registerLazySingleton<INetworkUtility>(
      () => NetworkUtility(Apis.baseNewsUrl),
      instanceName: NetworkConstant.newsDomain,
    );

    injector.registerLazySingleton<INetworkUtility>(
      () => NetworkUtility("https://rsapi.goong.io"),
      instanceName: NetworkConstant.mapDomain,
    );
  }
}
