
import '../../utils/parser_utils.dart';
import '../chat_enum.dart';
import 'author_model.dart';

class ReplyToModel {
  ReplyToModel({
    this.author,
    this.messageId,
    this.messageText,
    this.messageType,
    this.createdAt,
  });

  ReplyToModel.fromJson(dynamic json) {
    author =
        json['author'] != null ? AuthorModel.fromJson(json['author']) : null;
    messageId = json['message_id'];
    messageText = json['message_text'];
    messageType = safeParse(json['message_type'], payload: MessageType.values);
    createdAt = safeParse(json['created_at']);
  }

  AuthorModel? author;
  String? messageId;
  String? messageText;
  MessageType? messageType;
  DateTime? createdAt;

  ReplyToModel copyWith({
    AuthorModel? author,
    String? messageId,
    String? messageText,
    MessageType? messageType,
    DateTime? createdAt,
  }) =>
      ReplyToModel(
        author: author ?? this.author,
        messageId: messageId ?? this.messageId,
        messageText: messageText ?? this.messageText,
        messageType: messageType ?? this.messageType,
        createdAt: createdAt ?? this.createdAt,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (author != null) {
      map['author'] = author?.toJson();
    }
    map['message_id'] = messageId;
    map['message_text'] = messageText;
    map['message_type'] = messageType;
    map['created_at'] = createdAt;
    return map;
  }
}
