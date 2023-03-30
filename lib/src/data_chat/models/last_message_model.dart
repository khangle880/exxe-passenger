import '../../utils/parser_utils.dart';
import '../chat_enum.dart';

class LastMessageModel {
  LastMessageModel({
    this.messageId,
    this.isAuthor,
    this.authorName,
    this.messageText,
    this.createdAt,
    this.sendType,
  });

  LastMessageModel.fromJson(dynamic json) {
    messageId = json['message_id'];
    isAuthor = json['is_author'];
    authorName = json['author_name'];
    messageText = json['message_text'];
    createdAt = safeParse(json['created_at']);
    sendType = SendMessageType.sent;
  }

  String? messageId;
  bool? isAuthor;
  String? authorName;
  String? messageText;
  DateTime? createdAt;
  SendMessageType? sendType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message_id'] = messageId;
    map['is_author'] = isAuthor;
    map['author_name'] = authorName;
    map['message_text'] = messageText;
    map['created_at'] = createdAt;
    return map;
  }

  LastMessageModel copyWith({
    String? messageId,
    bool? isAuthor,
    String? authorName,
    String? messageText,
    DateTime? createdAt,
    SendMessageType? sendType,
  }) {
    return LastMessageModel(
      messageId: messageId ?? this.messageId,
      isAuthor: isAuthor ?? this.isAuthor,
      authorName: authorName ?? this.authorName,
      messageText: messageText ?? this.messageText,
      createdAt: createdAt ?? this.createdAt,
      sendType: sendType ?? this.sendType,
    );
  }
}
