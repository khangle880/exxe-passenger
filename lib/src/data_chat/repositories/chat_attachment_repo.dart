import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../utils/helpers/chat_parser_helper.dart';
import 'package:get_it/get_it.dart';

import '../../core/core.dart';
import '../data_chat.dart';

class ChatAttachmentRepo extends IChatAttachmentRepo {
  late final INetworkUtility _networkUtility;

  ChatAttachmentRepo()
      : _networkUtility = GetIt.I
            .get<INetworkUtility>(instanceName: NetworkConstant.chatDomain);

  @override
  Future<Either<Failure, List<ChatAttachmentModel>>> uploadImageMulti(
      String name, List<String> filePath) async {
    final multipartFile =
        await Future.wait(filePath.map(MultipartFile.fromFile).toList());
    FormData formData = FormData.fromMap({"images": multipartFile});

    final request = _networkUtility.request(
      ChatApis.uploadMultiImage,
      Method.POST,
      data: formData,
    );

    return ChatParserHelper.listParseDefault(
        request, ChatAttachmentModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatAttachmentModel>> uploadImageSingle(
      String name, String filePath) async {
    final multipartFile = await MultipartFile.fromFile(filePath);
    FormData formData =
        FormData.fromMap({"name": "image", "filename": multipartFile});

    final request = _networkUtility.request(
      ChatApis.uploadImageSingle,
      Method.POST,
      data: formData,
    );

    return ChatParserHelper.singleParseDefault(
        request, ChatAttachmentModel.fromJson);
  }

  @override
  Future<Either<Failure, List<ChatAttachmentModel>>> uploadVideoMulti(
      String name, List<String> filePath) async {
    final multipartFile =
        await Future.wait(filePath.map(MultipartFile.fromFile).toList());
    FormData formData =
        FormData.fromMap({"name": "video", "filename": multipartFile});

    final request = _networkUtility.request(
      ChatApis.uploadVideoMulti,
      Method.POST,
      data: formData,
    );

    return ChatParserHelper.listParseDefault(
        request, ChatAttachmentModel.fromJson);
  }

  @override
  Future<Either<Failure, ChatAttachmentModel>> uploadVideoSingle(
      String name, String filePath) async {
    final multipartFile = await MultipartFile.fromFile(filePath);
    FormData formData =
        FormData.fromMap({"name": "videos", "filename": multipartFile});

    final request = _networkUtility.request(
      ChatApis.uploadVideoSingle,
      Method.POST,
      data: formData,
    );

    return ChatParserHelper.singleParseDefault(
        request, ChatAttachmentModel.fromJson);
  }
}
