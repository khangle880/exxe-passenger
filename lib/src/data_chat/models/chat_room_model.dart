import '../../app/common/pagination/pagination_helper.dart';
import '../../utils/parser_utils.dart';
import '../chat_enum.dart';
import 'models.dart';

class ChatRoomModel {
  ChatRoomModel.fromJson(dynamic json) {
    roomId = json['room_id'];
    dependId = json['depend_id'];
    roomName = json['room_name'];
    roomAvatar = json['room_avatar'];
    roomType = safeParse(json['room_type'], payload: RoomType.values);
    isOnline = json['is_online'];
    offlineAt = safeParse(json['offline_at']);
    memberCount = json['member_count'];
    messageUnreadCount = json['message_unread_count'];
    lastMessage = json['last_message'] != null
        ? LastMessageModel.fromJson(json['last_message'])
        : null;
    topMembers =
        List.from((json['top_members'] ?? []).map(ChatUserModel.fromJson));
    messages =
        json['messages'] != null ? Messages.fromJson(json['messages']) : null;
    members =
        json['members'] != null ? Members.fromJson(json['members']) : null;
  }

  String? roomId;
  String? dependId;
  String? roomName;
  String? roomAvatar;
  RoomType? roomType;
  bool? isOnline;
  DateTime? offlineAt;
  num? memberCount;
  num? messageUnreadCount;
  LastMessageModel? lastMessage;
  List<ChatUserModel>? topMembers;
  Messages? messages;
  Members? members;
  PaginationHelper<ChatMessageModel>? messageController;

  List<ChatUserModel> getOtherMembers(userId) {
    final members = (this.members?.data ?? []).isNotEmpty
        ? (this.members?.data ?? [])
        : topMembers ?? [];
    return members.where((element) => element.userId != userId).toList();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['room_id'] = roomId;
    map['room_name'] = roomName;
    map['room_avatar'] = roomAvatar;
    map['room_type'] = roomType;
    map['is_online'] = isOnline;
    map['offline_at'] = offlineAt;
    map['member_count'] = memberCount;
    if (messages != null) {
      map['messages'] = messages?.toJson();
    }
    if (members != null) {
      map['members'] = members?.toJson();
    }
    return map;
  }

  ChatRoomModel copyWith({
    String? roomId,
    String? dependId,
    String? roomName,
    String? roomAvatar,
    RoomType? roomType,
    bool? isOnline,
    DateTime? offlineAt,
    num? memberCount,
    num? messageUnreadCount,
    LastMessageModel? lastMessage,
    List<ChatUserModel>? topMembers,
    Messages? messages,
    Members? members,
    PaginationHelper<ChatMessageModel>? messageController,
  }) {
    return ChatRoomModel(
      roomId: roomId ?? this.roomId,
      dependId: dependId ?? this.dependId,
      roomName: roomName ?? this.roomName,
      roomAvatar: roomAvatar ?? this.roomAvatar,
      roomType: roomType ?? this.roomType,
      isOnline: isOnline ?? this.isOnline,
      offlineAt: offlineAt ?? this.offlineAt,
      memberCount: memberCount ?? this.memberCount,
      messageUnreadCount: messageUnreadCount ?? this.messageUnreadCount,
      lastMessage: lastMessage ?? this.lastMessage,
      topMembers: topMembers ?? this.topMembers,
      messages: messages ?? this.messages,
      members: members ?? this.members,
      messageController: messageController ?? this.messageController,
    );
  }

  ChatRoomModel({
    this.roomId,
    this.dependId,
    this.roomName,
    this.roomAvatar,
    this.roomType,
    this.isOnline,
    this.offlineAt,
    this.memberCount,
    this.messageUnreadCount,
    this.lastMessage,
    this.topMembers,
    this.messages,
    this.members,
    this.messageController,
  });
}

class Members {
  Members({
    this.hasMore,
    this.limit,
    this.offset,
    this.total,
    this.data,
  });

  Members.fromJson(dynamic json) {
    hasMore = json['has_more'];
    limit = json['limit'];
    offset = json['offset'];
    total = json['total'];
    data = List.from((json['data'] ?? []).map(ChatUserModel.fromJson));
  }

  bool? hasMore;
  num? limit;
  num? offset;
  num? total;
  List<ChatUserModel>? data;

  Members copyWith({
    bool? hasMore,
    num? limit,
    num? offset,
    num? total,
    List<ChatUserModel>? data,
  }) =>
      Members(
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        total: total ?? this.total,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['has_more'] = hasMore;
    map['limit'] = limit;
    map['offset'] = offset;
    map['total'] = total;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Messages {
  Messages({
    this.hasMore,
    this.limit,
    this.offset,
    this.total,
    this.data,
  });

  Messages.fromJson(dynamic json) {
    hasMore = json['has_more'];
    limit = json['limit'];
    offset = json['offset'];
    total = json['total'];
    data = List.from((json['data'] ?? []).map(ChatMessageModel.fromJson));
  }

  bool? hasMore;
  num? limit;
  num? offset;
  num? total;
  List<ChatMessageModel>? data;

  Messages copyWith({
    bool? hasMore,
    num? limit,
    num? offset,
    num? total,
    List<ChatMessageModel>? data,
  }) =>
      Messages(
        hasMore: hasMore ?? this.hasMore,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        total: total ?? this.total,
        data: data ?? this.data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['has_more'] = hasMore;
    map['limit'] = limit;
    map['offset'] = offset;
    map['total'] = total;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
