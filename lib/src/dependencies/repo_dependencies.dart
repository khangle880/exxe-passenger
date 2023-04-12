import 'package:exxe/src/utils/export/logic_export.dart';

class RepoDependencies {
  static Future setup(GetIt injector) async {
    injector.registerFactory<UserInfoRepo>(() => UserInfoRepo());
    injector.registerFactory<IUserInfoRepo>(() => UserInfoRepo());
    injector.registerFactory<CompoundingCarControllerRepo>(
        () => CompoundingCarControllerRepo());
    injector.registerFactory<ICompoundingCarCtrlRepo>(
        () => CompoundingCarControllerRepo());
    injector.registerFactory<WalletRepo>(() => WalletRepo());
    injector.registerFactory<IWalletRepo>(() => WalletRepo());
    injector.registerFactory<IDataControllerRepo>(() => DataControllerRepo());
    injector.registerFactory<UserRepo>(() => UserRepo());
    injector.registerFactory<IUserRepo>(() => UserRepo());
    injector.registerFactory<PlaceRepository>(() => PlaceRepository());
    injector.registerFactory<IRatingRepo>(() => RatingRepo());
    injector.registerFactory<IPlacesRepository>(() => PlaceRepository());
    injector.registerFactory<IPromotionRepo>(() => PromotionRepo());
    injector.registerFactory<INotificationRepo>(() => NotificationRepo());
    injector.registerFactory<INewsControllerRepo>(() => NewsControllerRepo());
    injector
        .registerFactory<IPushNotificationRepo>(() => PushNotificationRepo());

    //google map helper
    injector
        .registerSingleton<LocationHelper>(LocationHelper()..getListProvince());
    injector
        .registerSingleton<OneSignalNotificationHelper>(OneSignalNotificationHelper());
  }
}
