import 'package:exxe/src/utils/export/logic_export.dart';

import '../../utils/parser_utils.dart';
import '../data_chat.dart';

class ChatMessageModel {
  ChatMessageModel({
    this.messageId,
    this.roomId,
    this.createdAt,
    this.isAuthor,
    this.author,
    this.emotionType,
    this.attachments,
    this.reactionCount,
    this.reactions,
    this.yourReaction,
    this.messageText,
    this.replyTo,
    this.location,
    this.isRead,
    this.sendType,
    this.sendMessage,
  });

  ChatMessageModel.fromJson(dynamic json) {
    preJson = json;
    messageId = json['message_id'];
    roomId = json['room_id'];
    createdAt = safeParse(json['created_at']);
    isAuthor = json['is_author'];
    author =
        json['author'] != null ? AuthorModel.fromJson(json['author']) : null;
    emotionType = safeParse(json['emotion_type'], payload: EmotionType.values);
    attachments = List.from(
        (json['attachments'] ?? []).map((ChatAttachmentModel.fromJson)));
    reactionCount = json['reaction_count'];
    reactions = List.from((json['reactions'] ?? [])
        .map((e) => safeParse(e, payload: EmotionType.values)));
    yourReaction =
        safeParse(json['your_reaction'], payload: EmotionType.values);
    messageText = json['message_text'];
    replyTo = json['reply_to'] != null
        ? ReplyToModel.fromJson(json['reply_to'])
        : null;
    location = json['location'] != null
        ? ChatLocationModel.fromJson(json['location'])
        : null;
    isRead = json['is_read'];
    sendType = SendMessageType.sent;
  }

  Map<String, dynamic>? preJson;
  String? messageId;
  String? roomId;
  DateTime? createdAt;
  bool? isAuthor;
  AuthorModel? author;
  EmotionType? emotionType;
  List<ChatAttachmentModel>? attachments;
  num? reactionCount;
  List<EmotionType>? reactions;
  EmotionType? yourReaction;
  String? messageText;
  ReplyToModel? replyTo;
  ChatLocationModel? location;
  bool? isRead;
  SendMessageType? sendType;
  Function()? sendMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message_id'] = messageId;
    map['room_id'] = roomId;
    map['created_at'] = createdAt.toString();
    map['is_author'] = isAuthor;
    if (author != null) {
      map['author'] = author?.toJson();
    }
    map['emotion_type'] = emotionType;
    if (attachments != null && attachments!.isNotEmpty) {
      map['attachments'] = attachments?.map((v) => v.toJson()).toList();
    }
    map['reaction_count'] = reactionCount;
    if (reactions != null && reactions!.isNotEmpty) {
      map['reactions'] = reactions?.map((v) => v.serverString).toList();
    }
    map['your_reaction'] = yourReaction?.serverString;
    map['message_text'] = messageText;
    if (replyTo != null) {
      map['reply_to'] = replyTo?.toJson();
    }
    if (location != null) {
      map['location'] = location?.toJson();
    }
    map['is_read'] = isRead;
    return map;
  }

  String? get messageShowed => (messageText ?? "").isEmpty
      ? (location != null)
          ? "Vị trí"
          : ((attachments ?? []).isNotEmpty
              ? attachments!.first.attachmentType == MediaType.video
                  ? "Video"
                  : "Hình ảnh"
              : null)
      : messageText;

  LastMessageModel get toLastMessageModel => LastMessageModel(
        messageId: messageId,
        isAuthor: isAuthor,
        authorName: author?.authorName,
        messageText: messageShowed,
        createdAt: createdAt,
        sendType: sendType,
      );

  ReplyToModel get toReplyToModel => ReplyToModel(
        author: author,
        messageId: messageId,
        messageText: messageText,
        createdAt: createdAt,
      );

  ChatMessageModel copyWith({
    String? messageId,
    String? roomId,
    DateTime? createdAt,
    bool? isAuthor,
    AuthorModel? author,
    EmotionType? emotionType,
    List<ChatAttachmentModel>? attachments,
    num? reactionCount,
    List<EmotionType>? reactions,
    EmotionType? yourReaction,
    String? messageText,
    ReplyToModel? replyTo,
    ChatLocationModel? location,
    bool? isRead,
    SendMessageType? sendType,
    Function()? sendMessage,
  }) {
    return ChatMessageModel(
      messageId: messageId ?? this.messageId,
      roomId: roomId ?? this.roomId,
      createdAt: createdAt ?? this.createdAt,
      isAuthor: isAuthor ?? this.isAuthor,
      author: author ?? this.author,
      emotionType: emotionType ?? this.emotionType,
      attachments: attachments ?? this.attachments,
      reactionCount: reactionCount ?? this.reactionCount,
      reactions: reactions ?? this.reactions,
      yourReaction: yourReaction ?? this.yourReaction,
      messageText: messageText ?? this.messageText,
      replyTo: replyTo ?? this.replyTo,
      location: location ?? this.location,
      isRead: isRead ?? this.isRead,
      sendType: sendType ?? this.sendType,
      sendMessage: sendMessage ?? this.sendMessage,
    );
  }
}
