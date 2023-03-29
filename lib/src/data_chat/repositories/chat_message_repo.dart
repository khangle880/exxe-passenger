import 'package:dartz/dartz.dart';
import 'package:exxe/src/utils/export/logic_export.dart';
import '../../core/chat_base_response.dart';

import '../../core/core.dart';
import 'package:sprintf/sprintf.dart';

import '../data_chat.dart';

class ChatMessageRepo extends IChatMessageRepo {
  late final INetworkUtility _networkUtility;

  ChatMessageRepo()
      : _networkUtility = GetIt.I
            .get<INetworkUtility>(instanceName: NetworkConstant.chatDomain);

  @override
  Future<Either<Failure, ChatPagingResponse<ChatUserModel>>> getReadUsers(
      {required String messageId, num? offset, num? limit}) {
    final request = _networkUtility.request(
      sprintf(ChatApis.getReadUsers, [messageId]),
      Method.GET,
      queryParameters: {
        "offset": offset ?? 0,
        "limit": limit ?? 20,
      },
    );

    return ChatParserHelper.pagingParseDefault(request, ChatUserModel.fromJson);
  }

  @override
  Future<Either<Failure, num>> markReadMessage(String messageId) {
    final request = _networkUtility.request(
      ChatApis.markReadMessage,
      Method.PATCH,
      data: {"message_id": messageId},
    );

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['message_id']);
  }

  @override
  Future<Either<Failure, num>> markReadAllMessage(String roomId) {
    final request = _networkUtility.request(
      ChatApis.markReadAllInRoom,
      Method.PATCH,
      data: {"room_id": roomId},
    );

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['room_id']);
  }

  @override
  Future<Either<Failure, ChatMessageModel>> createMessage(
      {String? text,
      required String roomId,
      List<String>? attachmentIds,
      ChatLocationModel? location,
      ReplyToModel? replyTo}) {
    final body = {
      "text": text,
      "room_id": roomId,
      "attachment_ids": attachmentIds,
      "location": location == null
          ? null
          : {
              "lng": location.lng!,
              "lat": location.lat!,
            },
      "reply_to": replyTo?.messageId == null
          ? null
          : {
              "message_id": replyTo?.messageId,
            }
    }.getCleanNull;
    final request = _networkUtility.request(
      ChatApis.createMessage,
      Method.POST,
      data: body,
    );

    return ChatParserHelper.singleParseDefault(
        request, ChatMessageModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatMessageModel>> getMessage(String messageId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.getMessage, [messageId]), Method.GET);

    return ChatParserHelper.singleParseDefault(
        request, ChatMessageModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatMessageModel>> reactMessage(
      String messageId, EmotionType emotion) {
    final request = _networkUtility.request(
      ChatApis.reactMessage,
      Method.POST,
      data: {"message_id": messageId, "emotion": emotion.serverString},
    );

    return ChatParserHelper.singleParseDefault(
        request, ChatMessageModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatMessageModel>> deleteReactMessage(
      String messageId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.deleteReactMessage, [messageId]), Method.DELETE);

    return ChatParserHelper.singleParseDefault(
        request, ChatMessageModel.fromJson);
  }

  @override
  Future<Either<Failure, List<ChatUserModel>>> getReactUsers(String messageId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.getReactUsers, [messageId]), Method.GET);

    return ChatParserHelper.listParseDefault(request, ChatUserModel.fromJson);
  }
}
