import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/chat_base_response.dart';
import '../../../../data_chat/data_chat.dart';
import '../../../../utils/export/logic_export.dart';
import '../../../../utils/export/ui_export.dart';

part 'chat_room_state.dart';

class TypingUser {
  final String userName;
  final bool typing;

  const TypingUser({
    required this.userName,
    required this.typing,
  });

  TypingUser copyWith({
    String? userName,
    bool? typing,
  }) {
    return TypingUser(
      userName: userName ?? this.userName,
      typing: typing ?? this.typing,
    );
  }
}

class ChatRoomCubit extends BaseCubit<ChatRoomState> {
  final IChatRoomRepo roomRepo;
  final IChatMessageRepo messageRepo;
  final IChatAttachmentRepo attachmentRepo;
  final IChatUserRepo userRepo;
  final ChatRoomModel room;
  final StreamController<TypingUser> typingStream = StreamController();
  final BehaviorSubject<String> textStream = BehaviorSubject();
  final BehaviorSubject<ReplyToModel?> replyStream = BehaviorSubject();

  late final ChatUserModel user;
  late final ChatUserModel? partner;
  late final IO.Socket socket;

  PaginationHelper<ChatMessageModel> get controller => room.messageController!;

  ChatRoomCubit(this.roomRepo, this.attachmentRepo, this.messageRepo,
      this.userRepo, this.room)
      : super(ChatRoomInitial()) {
    ChatSocketHelper.I.socket.emit("join_room", room.roomId!);

    final lastMessage = room.messages?.data?.firstOrNull;
    if (lastMessage != null && lastMessage.sendType == SendMessageType.typing) {
      textStream.add(lastMessage.messageText ?? "");
      room.messages?.data?.removeWhere((element) => element == lastMessage);
    }
    if (room.messageController == null) {
      room.messageController = PaginationHelper<ChatMessageModel>(
        initItems: room.messages?.data ?? [],
        startOffset: room.messages?.offset?.ceil() ?? 0,
        limit: 30,
        asyncTask: (config) {
          return getMessages(config).then((data) {
            config.canLoadMore = data.pagination.canLoadMore;
            return data.items.reversed.toList();
          }).catchError((e) {
            log(e.toString());
            config.canLoadMore = false;
            throw e;
          });
        },
      );

      controller.config.canLoadMore = room.messages?.hasMore ?? true;
      controller.run();
    } else if (controller.items.isEmpty) {
      controller.run();
    }

    user = GetIt.I<AppState>().currentState.chatUser!;
    roomRepo.getMembers(roomId: room.roomId!).then((either) {
      either.fold((l) => log(l.toString()), (data) {
        room.members = Members(
          data: data.items,
          hasMore: data.pagination.canLoadMore,
          limit: data.pagination.limit,
          offset: data.pagination.offset,
        );
      });
    });
    // this members and partner only single room case
    partner = room.getOtherMembers(user.userId).firstOrNull;
    socket = ChatSocketHelper.I.socket;
    socket.on("read_all_message", onReadAllMessage);
    socket.on("delete_room", onDeleteRoom);
    socket.on("partner_read_all_message", onPartnerReadAllMessage);
    socket.on("friend_login", onFriendLogin);
    socket.on("friend_logout", onFriendLogout);
    socket.on("receive_message", onReceiveMessage);
    socket.on("confirm_read_message", onConfirmReadMessage);
    socket.on("start_typing", onStartTyping);
    socket.on("stop_typing", onStopTyping);
  }

  @override
  dispose() {
    super.dispose();
    socket.off("read_all_message", onReadAllMessage);
    socket.off("delete_room", onDeleteRoom);
    socket.off("partner_read_all_message", onPartnerReadAllMessage);
    socket.off("friend_login", onFriendLogin);
    socket.off("friend_logout", onFriendLogout);
    socket.off("receive_message", onReceiveMessage);
    socket.off("confirm_read_message", onConfirmReadMessage);
    socket.off("start_typing", onStartTyping);
    socket.off("stop_typing", onStopTyping);
  }

  onReadAllMessage(roomId) {
    log(roomId.toString());
    if (room.roomId == roomId) {
      room.messageUnreadCount = 0;
      for (var element in controller.items) {
        if (!(element.isAuthor ?? false)) {
          if (element.isRead ?? false) {
            break;
          } else {
            element.isRead = true;
          }
        }
      }
    }
    // update unread count
    if (user.userId != null) {
      GetIt.I<IChatUserRepo>().getMessageUnreadCount(user.userId!);
    }
  }

  onDeleteRoom(roomId) {
    log(roomId.toString());
  }

  onPartnerReadAllMessage(roomId) {
    log(roomId.toString());

    if (room.roomId == roomId) {
      for (var element in controller.items) {
        if (element.isAuthor ?? false) {
          if (element.isRead ?? false) {
            break;
          } else {
            element.isRead = true;
          }
        }
      }
    }
  }

  onFriendLogin(data) {
    ///  user_id, room_ids
    log(data.toString());
    final roomIds = (data['room_ids'] as List).cast<String>();
    if (roomIds.contains(room.roomId)) {
      final members = (room.members?.data ?? []).isNotEmpty
          ? room.members?.data ?? []
          : room.topMembers ?? [];

      final userId = data['user_id'];
      var memberIndex =
          members.indexWhere((element) => element.userId == userId);
      if (memberIndex != -1) {
        members[memberIndex] = members[memberIndex].copyWith(isOnline: true);
      }
      final others =
          members.where((element) => element.userId != user.userId).toList();
      final isRoomOnline = others
              .map((e) => e.isOnline ?? false ? 1 : 0)
              .reduce((value, element) => value + element) >
          0;
      room.isOnline = isRoomOnline;
    }
  }

  onFriendLogout(data) {
    ///  user_id, room_ids
    log(data.toString());
    final roomIds = (data['room_ids'] as List).cast<String>();
    if (roomIds.contains(room.roomId)) {
      final members = (room.members?.data ?? []).isNotEmpty
          ? room.members?.data ?? []
          : room.topMembers ?? [];

      final userId = data['user_id'];
      var memberIndex =
          members.indexWhere((element) => element.userId == userId);
      if (memberIndex != -1) {
        members[memberIndex] = members[memberIndex].copyWith(isOnline: false);
      }
      final others =
          members.where((element) => element.userId != user.userId).toList();
      final isRoomOnline = others
              .map((e) => e.isOnline ?? false ? 1 : 0)
              .reduce((value, element) => value + element) >
          0;
      room.isOnline = isRoomOnline;
      typingStream
          .add(TypingUser(userName: data['user_name'] ?? "", typing: false));
    }
  }

  onReceiveMessage(data) {
    log(data.toString());
    final message = ChatMessageModel.fromJson(data);
    addMessage(message);
  }

  onConfirmReadMessage(data) {
    log(data.toString());
    final message = ChatMessageModel.fromJson(data);
    controller.items
        .firstWhereOrNull((element) => element.messageId == message.messageId)
        ?.isRead = true;
  }

  onStartTyping(data) {
    log(data.toString());
    final roomId = data['room_id'];
    if (room.roomId == roomId) {
      typingStream
          .add(TypingUser(userName: data['user_name'] ?? "", typing: true));
    }
  }

  onStopTyping(data) {
    log(data.toString());
    final roomId = data['room_id'];
    if (room.roomId == roomId) {
      typingStream
          .add(TypingUser(userName: data['user_name'] ?? "", typing: false));
    }
  }

  startTyping() {
    socket.emit("start_typing", {
      "room_id": room.roomId,
      "user_name": user.userName,
      "user_id": user.userId,
    });
  }

  stopTyping() {
    socket.emit("stop_typing", {
      "room_id": room.roomId,
      "user_name": user.userName,
      "user_id": user.userId,
    });
  }

  leaveRoom() {
    log('leave room');
    socket.emit("leave_room", room.roomId!);
  }

  updateController() {
    controller.callListeners();
  }

  Future<ChatPagingResponse<ChatMessageModel>> getMessages(
      PaginationConfig config) async {
    var result = await roomRepo.getMessages(
      roomId: room.roomId!,
      limit: 30,
      offset: config.offset,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data;
      },
    );
  }

  createMessage({List<String>? filePaths, bool sendLocation = false}) async {
    ChatMessageModel message;
    final location = GetIt.I<AppState>().currentState.currentLocation;

    message = ChatMessageModel(
      location: (sendLocation && location?.coordinate != null)
          ? ChatLocationModel(
              lat: location!.coordinate!.latitude.toString(),
              lng: location.coordinate!.longitude.toString())
          : null,
      messageText: textStream.valueOrNull ?? "",
      attachments:
          filePaths?.map((e) => ChatAttachmentModel(filePath: e)).toList(),
      replyTo: replyStream.valueOrNull,
      isAuthor: true,
      roomId: room.roomId,
      author: user.toAuthorModel,
      sendType: SendMessageType.sending,
      createdAt: DateTime.now(),
    );

    // update list
    controller.items.insert(
      0,
      message,
    );
    updateController();

    // set send function
    message = message.copyWith(
      sendMessage: () async {
        bool success = true;

        // upload image
        if (filePaths != null) {
          final result = await attachmentRepo.uploadImageMulti(
              DateTime.now().toString(), filePaths);
          result.fold((l) {
            log(l.toString());
            success = false;
          }, (data) {
            message = message.copyWith(attachments: data);
          });
        }

        // create message
        if (success) {
          final result = await messageRepo.createMessage(
            roomId: message.roomId!,
            attachmentIds:
                message.attachments?.map((e) => e.attachmentId!).toList(),
            text: message.messageText,
            replyTo: message.replyTo,
            location: message.location,
          );
          result.fold(
            (l) {
              log(l.toString());
              success = false;
            },
            (data) {
              controller.items
                  .removeWhere((element) => element == controller.items[0]);
              addMessageSent(data);
            },
          );
        }

        // handle fail
        if (!success) {
          controller.items[0] =
              message.copyWith(sendType: SendMessageType.rejected);
          updateController();
          ChatSocketHelper.I.controller.callListeners();
        }
      },
    );

    controller.items[0] = message;
    message.sendMessage?.call();
  }

  addMessageSent(ChatMessageModel message) {
    socket.emit("send_message", message.preJson);
    addMessage(message);
  }

  addMessage(ChatMessageModel message) {
    int index = 0;
    for (var element in controller.items) {
      if (element.sendType != SendMessageType.sent ||
          element.createdAt!.millisecondsSinceEpoch >
              message.createdAt!.millisecondsSinceEpoch) {
        index++;
      } else {
        break;
      }
    }
    controller.items.insert(index, message);
    controller.config.offset++;
    updateController();
    ChatSocketHelper.I.controller.callListeners();
    textStream.add("");
    replyStream.add(null);
  }
}
