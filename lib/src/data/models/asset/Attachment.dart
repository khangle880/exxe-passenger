import '../../../utils/constants/enum/data_enum.dart';
import '../../../utils/parser_utils.dart';
import 'image_model.dart';

class AttachmentModel {
  AttachmentModel({
    this.attachmentId,
    this.attachmentUrl,
  });

  AttachmentModel.fromJson(dynamic json) {
    attachmentId = safeParse(json['attachment_id']);
    attachmentUrl = safeParse(json['attachment_url']);
  }

  num? attachmentId;
  String? attachmentUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attachment_id'] = attachmentId;
    map['attachment_url'] = attachmentUrl;
    return map;
  }

  ImageModel toImageModel() {
    return ImageModel(id: attachmentId, url: attachmentUrl);
  }
}

class AttachmentParam {
  final String base64;
  final MediaType type;

  const AttachmentParam({
    required this.base64,
    required this.type,
  });
}
