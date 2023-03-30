import 'package:dio/dio.dart';
import 'package:exxe/src/storage/models/user_chat.dart';

class ChatAuthorizationInterceptor extends Interceptor {
  ChatAuthorizationInterceptor();

  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    var token = await BoxesChatUser.instance.getDataTokenUser();
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
