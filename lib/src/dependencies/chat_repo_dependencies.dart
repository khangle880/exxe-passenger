import 'package:get_it/get_it.dart';
import '../data_chat/data_chat.dart';

class ChatRepoDependencies {
  static Future setup(GetIt injector) async {
    injector.registerFactory<IChatUserRepo>(() => ChatUserRepo());
    injector.registerFactory<IChatRoomRepo>(() => ChatRoomRepo());
    injector.registerFactory<IChatMessageRepo>(() => ChatMessageRepo());
    injector.registerFactory<IChatAttachmentRepo>(() => ChatAttachmentRepo());
  }
}
