import 'package:dartz/dartz.dart';
import 'package:exxe/src/utils/export/logic_export.dart';
import '../../core/chat_base_response.dart';

import '../../core/core.dart';
import 'package:sprintf/sprintf.dart';

import '../data_chat.dart';

class ChatRoomRepo extends IChatRoomRepo {
  late final INetworkUtility _networkUtility;

  ChatRoomRepo()
      : _networkUtility = GetIt.I
            .get<INetworkUtility>(instanceName: NetworkConstant.chatDomain);

  @override
  Future<Either<Failure, ChatRoomModel>> createSingleRoom(
    num partnerId,
    String dependId,
  ) {
    final request = _networkUtility.request(
      ChatApis.createSingleRoom,
      Method.POST,
      data: {
        "partner_id": partnerId,
        "depend_id": dependId,
      }.getCleanNull,
    );

    return ChatParserHelper.singleParseDefault(request, ChatRoomModel.fromJson,
        rightPreCall: (value) {
      ChatSocketHelper.I.addRoom(value);
    });
  }

  @override
  Future<Either<Failure, ChatRoomModel>> createGroupRoom(
      {required List<num> memberIds,
      required String roomName,
      String? roomAvatar,
      num? dependId}) {
    final request = _networkUtility.request(
      ChatApis.register,
      Method.POST,
      data: {
        "member_ids": memberIds,
        "room_avatar": roomAvatar,
        "room_name": roomName,
        "depend_id": dependId,
      }.getCleanNull,
    );

    return ChatParserHelper.singleParseDefault(request, ChatRoomModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatRoomModel>> getRoom(String roomId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.getRoom, [roomId]), Method.GET);

    return ChatParserHelper.singleParseDefault(request, ChatRoomModel.fromJson);
  }

  @override
  Future<Either<Failure, String>> deleteRoom(String roomId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.deleteRoom, [roomId]), Method.DELETE);

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['room_id']);
  }

  @override
  Future<Either<Failure, String>> deleteByDependId(
      String compoundingCustomerCode) {
    final request = _networkUtility.request(
        sprintf(ChatApis.deleteRoomDependId, [compoundingCustomerCode]),
        Method.DELETE);

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['depend_id']);
  }

  @override
  Future<Either<Failure, String>> restoreRoom(String roomId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.restoreRoom, [roomId]), Method.PATCH);

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['room_id']);
  }

  @override
  Future<Either<Failure, dynamic>> deleteUnreadByRoom(String roomId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.deleteUnreadByRoom, [roomId]), Method.DELETE);

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['message_unread_count']);
  }

  @override
  Future<Either<Failure, dynamic>> leaveGroupRoom(num dependId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.leaveGroupRoom, [dependId]), Method.DELETE);

    return ChatParserHelper.singleParseDefault(request, (value) => null);
  }

  @override
  Future<Either<Failure, dynamic>> joinGroupRoom(num dependId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.joinGroupRoom, [dependId]), Method.POST);

    return ChatParserHelper.singleParseDefault(request, (value) => null);
  }

  @override
  Future<Either<Failure, ChatMessageModel>> pinnedMessage(String messageId) {
    final request = _networkUtility.request(
      ChatApis.pinnedMessage,
      Method.POST,
      data: {"message_id": messageId},
    );

    return ChatParserHelper.singleParseDefault(
        request, ChatMessageModel.fromJson);
  }

  @override
  Future<Either<Failure, num>> deletePinnedMessage(String messageId) {
    final request = _networkUtility.request(
        sprintf(ChatApis.deletePinnedMessage, [messageId]), Method.DELETE);

    return ChatParserHelper.singleParseDefault(
        request, (value) => value['message_id']);
  }

  @override
  Future<Either<Failure, ChatPagingResponse<ChatMessageModel>>>
      getPinnedMessages({required String roomId, num? offset, num? limit}) {
    final request = _networkUtility.request(
      sprintf(ChatApis.getPinnedMessages, [roomId]),
      Method.GET,
      queryParameters: {
        "offset": offset ?? 0,
        "limit": limit ?? 20,
      },
    );

    return ChatParserHelper.pagingParseDefault(
        request, ChatMessageModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatPagingResponse<ChatRoomModel>>> getListRoom(
      {num? offset, num? limit, String? searchTerm, RoomType? roomType}) {
    final query = {
      "offset": offset ?? 0,
      "limit": limit ?? 20,
      "room_type": roomType?.serverString,
      'search_term': searchTerm,
    }.getCleanNull;
    final request = _networkUtility.request(
      ChatApis.getListRoom,
      Method.GET,
      queryParameters: query,
    );

    return ChatParserHelper.pagingParseDefault(request, ChatRoomModel.fromJson,
        rightPreCall: (value) {});
  }

  @override
  Future<Either<Failure, ChatPagingResponse<ChatUserModel>>> getMembers(
      {required String roomId, num? offset, num? limit}) {
    final request = _networkUtility.request(
      sprintf(ChatApis.getMembers, [roomId]),
      Method.GET,
      queryParameters: {
        "offset": offset ?? 0,
        "limit": limit ?? 20,
      },
    );

    return ChatParserHelper.pagingParseDefault(request, ChatUserModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatPagingResponse<ChatMessageModel>>> getMessages(
      {required String roomId, num? offset, num? limit}) {
    final request = _networkUtility.request(
      sprintf(ChatApis.getMessages, [roomId]),
      Method.GET,
      queryParameters: {
        "offset": offset ?? 0,
        "limit": limit ?? 20,
      },
    );

    return ChatParserHelper.pagingParseDefault(
        request, ChatMessageModel.fromJson);
  }
}
