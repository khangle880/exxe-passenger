import 'package:hive/hive.dart';
part 'user_chat.g.dart';

@HiveType(typeId: 2)
class ChatUserHive {
  ChatUserHive({
    required this.token,
    required this.refreshToken,
  });

  @HiveField(0)
  late String token;

  @HiveField(1)
  late String refreshToken;

  @override
  String toString() {
    return 'token: $token ,refreshToken : $refreshToken';
  }
}

class BoxesChatUser {
  static BoxesChatUser instance = BoxesChatUser();
  static String boxName = 'users_chat';
  String key = 'user_storage';
  static Future<Box<ChatUserHive>> openBoxUser() async =>
      await Hive.openBox<ChatUserHive>(boxName);
  void setUser(ChatUserHive hive) async {
    var box = await BoxesChatUser.openBoxUser();
    box.put(
        key,
        ChatUserHive(
          token: hive.token,
          refreshToken: hive.refreshToken,
        ));
  }

  Future<String> getDataTokenUser() async {
    var box = await BoxesChatUser.openBoxUser();

    var token = !box.keys.contains(key) ? '' : box.get(key)!.token;
    return token;
  }

  Future deleteDataUser() async {
    var box = await BoxesChatUser.openBoxUser();
    await box.delete(key);
  }
}
