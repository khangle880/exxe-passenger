import 'package:hive/hive.dart';

import '../../data/models/models.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class UserHive {
  UserHive({
    required this.token,
    required this.refreshToken,
  });

  @HiveField(0)
  late String token;

  @HiveField(1)
  late String refreshToken;

  @override
  String toString() {
    return 'token: $token ,refreshToken : $refreshToken ';
  }

  TokenModel get tokenModel =>
      TokenModel(token: token, refreshToken: refreshToken);
}

class BoxesUser {
  static BoxesUser instance = BoxesUser();
  static String boxName = 'users';
  String key = 'user_storage';

  static Future<Box<UserHive>> openBoxUser() async =>
      await Hive.openBox<UserHive>(boxName);

  void setUser(UserHive hive) async {
    var box = await BoxesUser.openBoxUser();
    box.put(
        key,
        UserHive(
          token: hive.token,
          refreshToken: hive.refreshToken,
        ));
  }

  Future<TokenModel?> getUserData() async {
    var box = await BoxesUser.openBoxUser();

    var user = box.get(key);
    return user?.tokenModel;
  }

  Future<String> getDataTokenUser() async {
    var box = await BoxesUser.openBoxUser();

    var token = !box.keys.contains(key) ? '' : box.get(key)!.token;
    return token;
  }

  Future deleteDataUser() async {
    var box = await BoxesUser.openBoxUser();
    await box.delete(key);
  }
}
