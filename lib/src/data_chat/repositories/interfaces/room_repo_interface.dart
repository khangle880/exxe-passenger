import 'package:dartz/dartz.dart';

import '../../../core/chat_base_response.dart';
import '../../../core/core.dart';
import '../../chat_enum.dart';
import '../../models/models.dart';

abstract class IChatRoomRepo {
  Future<Either<Failure, ChatRoomModel>> createSingleRoom(
    num partnerId,
    String dependId,
  );

  Future<Either<Failure, ChatRoomModel>> createGroupRoom({
    required List<num> memberIds,
    required String roomName,
    String? roomAvatar,
    num? dependId,
  });

  Future<Either<Failure, ChatRoomModel>> getRoom(String roomId);

  Future<Either<Failure, String>> deleteRoom(String roomId);

  Future<Either<Failure, String>> deleteByDependId(
      String compoundingCustomerCode);

  Future<Either<Failure, String>> restoreRoom(String roomId);

  Future<Either<Failure, dynamic>> deleteUnreadByRoom(String roomId);

  Future<Either<Failure, dynamic>> leaveGroupRoom(num dependId);

  Future<Either<Failure, dynamic>> joinGroupRoom(num dependId);

  Future<Either<Failure, ChatPagingResponse<ChatRoomModel>>> getListRoom(
      {num? offset, num? limit, String? searchTerm, RoomType? roomType});

  Future<Either<Failure, ChatPagingResponse<ChatMessageModel>>>
      getPinnedMessages({required String roomId, num? offset, num? limit});

  Future<Either<Failure, ChatMessageModel>> pinnedMessage(String messageId);

  Future<Either<Failure, num>> deletePinnedMessage(String messageId);

  Future<Either<Failure, ChatPagingResponse<ChatUserModel>>> getMembers(
      {required String roomId, num? offset, num? limit});

  Future<Either<Failure, ChatPagingResponse<ChatMessageModel>>> getMessages(
      {required String roomId, num? offset, num? limit});
}
