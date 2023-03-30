import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../models/chat_attachment_model.dart';

abstract class IChatAttachmentRepo {
  Future<Either<Failure, ChatAttachmentModel>> uploadImageSingle(
      String name, String filePath);

  Future<Either<Failure, List<ChatAttachmentModel>>> uploadImageMulti(
      String name, List<String> filePath);

  Future<Either<Failure, ChatAttachmentModel>> uploadVideoSingle(
      String name, String filePath);

  Future<Either<Failure, List<ChatAttachmentModel>>> uploadVideoMulti(
      String name, List<String> filePath);
}
