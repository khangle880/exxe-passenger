
import '../../utils/constants/constants.dart';
import '../../utils/parser_utils.dart';

class ChatAttachmentModel {
  ChatAttachmentModel({
    this.filePath,
    this.attachmentId,
    this.thumbnailUrl,
    this.url,
    this.attachmentType,
  });

  ChatAttachmentModel.fromJson(dynamic json) {
    attachmentId = json['attachment_id'];
    thumbnailUrl = json['thumbnail_url'];
    url = json['url'];
    attachmentType =
        safeParse(json['attachment_type'], payload: MediaType.values);
  }

  String? filePath;
  String? attachmentId;
  String? thumbnailUrl;
  String? url;
  MediaType? attachmentType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attachment_id'] = attachmentId;
    map['thumbnail_url'] = thumbnailUrl;
    map['url'] = url;
    map['attachment_type'] = attachmentType;
    return map;
  }

  ChatAttachmentModel copyWith({
    String? filePath,
    String? attachmentId,
    String? thumbnailUrl,
    String? url,
    MediaType? attachmentType,
  }) {
    return ChatAttachmentModel(
      filePath: filePath ?? this.filePath,
      attachmentId: attachmentId ?? this.attachmentId,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      url: url ?? this.url,
      attachmentType: attachmentType ?? this.attachmentType,
    );
  }
}
