import 'package:dartz/dartz.dart';

import '../../../core/chat_base_response.dart';
import '../../../core/core.dart';
import '../../chat_enum.dart';
import '../../models/models.dart';

class ReplyToParam {
  final String? messageId;
  final String? attachmentId;

  const ReplyToParam({
    this.messageId,
    this.attachmentId,
  });
}

abstract class IChatMessageRepo {
  Future<Either<Failure, ChatPagingResponse<ChatUserModel>>> getReadUsers(
      {required String messageId, num? offset, num? limit});

  Future<Either<Failure, num>> markReadMessage(String messageId);

  Future<Either<Failure, num>> markReadAllMessage(String roomId);

  Future<Either<Failure, ChatMessageModel>> createMessage({
    String? text,
    required String roomId,
    List<String>? attachmentIds,
    ReplyToModel? replyTo,
    ChatLocationModel? location,
  });

  Future<Either<Failure, ChatMessageModel>> getMessage(String messageId);

  Future<Either<Failure, ChatMessageModel>> reactMessage(
      String messageId, EmotionType emotion);

  Future<Either<Failure, ChatMessageModel>> deleteReactMessage(
      String messageId);

  Future<Either<Failure, List<ChatUserModel>>> getReactUsers(
      String messageId);
}
