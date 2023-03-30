import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../app/common/common.dart';
import '../../config/config.dart';
import '../../core/chat_base_response.dart';
import '../../core/core.dart';
import '../../data_chat/data_chat.dart';
import '../../storage/models/user_chat.dart';
import '../export/logic_export.dart';

class ChatSocketHelper {
  static ChatSocketHelper instance = ChatSocketHelper();

  static ChatSocketHelper get I => instance;

  late PaginationHelper<ChatRoomModel> controller;
  late IO.Socket socket;
  final BehaviorSubject<bool> connectSocket = BehaviorSubject.seeded(false);

  ChatUserModel? get user => GetIt.I<AppState>().currentState.chatUser;

  loadSocket() async {
    var token = await BoxesChatUser.instance.getDataTokenUser();

    socket = IO.io(
      ChatApis.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'access_token': token})
          .enableForceNewConnection()
          .build(),
    );
    socket.connect();
    socket.onConnect((data) {
      log('Connect established');
      socket.emit("login");
      connectSocket.add(true);
    });
    socket.onConnectError((data) => log('Connect error: $data'));
    socket.onDisconnect((data) {
      log('Disconnect');
      connectSocket.add(false);
    });
    socket.onReconnect((data) {
      log('reconnect');
      connectSocket.add(true);
    });
    socket.on("login", (data) {
      log(data.toString());
    });

    initController();

    socket = ChatSocketHelper.I.socket;

    socket.on("delete_room", onDeleteRoom);

    socket.on("delete_room_by_depend_id", onDeleteRoomByDependId);

    socket.on("create_room", onCreateRoom);

    socket.on("friend_login", onFriendLogin);

    socket.on("friend_logout", onFriendLogout);

    socket.on("receive_unread_message", onReceiveUnreadMessage);
  }

  onDeleteRoom(roomId) {
    log(roomId.toString());
    controller.items.removeWhere((element) => element.roomId == roomId);
    controller.callListeners();
  }

  onDeleteRoomByDependId(dependId) {
    log(dependId.toString());
    controller.items.removeWhere((element) => element.dependId == dependId);
    controller.callListeners();
  }

  onCreateRoom(data) async {
    ChatRoomModel roomDetail = ChatRoomModel.fromJson(data);
    ChatSocketHelper.I.addRoom(roomDetail);
  }

  onFriendLogin(data) {
    ///  user_id, room_ids
    log(data.toString());
    final roomIds = (data['room_ids'] as List).cast<String>();
    for (var roomId in roomIds) {
      final index =
          controller.items.indexWhere((element) => element.roomId == roomId);
      if (index != -1) {
        var room = controller.items[index];
        var otherMembers = room.getOtherMembers(user!.userId);
        final userId = data['user_id'];
        var memberIndex =
            otherMembers.indexWhere((element) => element.userId == userId);
        if (memberIndex != -1) {
          otherMembers[memberIndex] =
              otherMembers[memberIndex].copyWith(isOnline: true);
        }
        room.members?.data = [user!, ...otherMembers];

        final isRoomOnline = otherMembers
            .where((element) => element.isOnline ?? false)
            .isNotEmpty;
        room.isOnline = isRoomOnline;
      }
    }
    controller.callListeners();
  }

  onFriendLogout(data) {
    ///  user_id, room_ids
    log(data.toString());
    final roomIds = (data['room_ids'] as List).cast<String>();
    for (var roomId in roomIds) {
      final index =
          controller.items.indexWhere((element) => element.roomId == roomId);
      if (index != -1) {
        var room = controller.items[index];
        var otherMembers = room.getOtherMembers(user!);
        final userId = data['user_id'];
        var memberIndex =
            otherMembers.indexWhere((element) => element.userId == userId);
        if (memberIndex != -1) {
          otherMembers[memberIndex] =
              otherMembers[memberIndex].copyWith(isOnline: false);
        }
        room.members?.data = [user!, ...otherMembers];

        final isRoomOnline = otherMembers
            .where((element) => element.isOnline ?? false)
            .isNotEmpty;
        room.isOnline = isRoomOnline;
      }
    }
    controller.callListeners();
  }

  onReceiveUnreadMessage(data) {
    log(data.toString());
    final mess = ChatMessageModel.fromJson(data);
    final index =
        controller.items.indexWhere((element) => element.roomId == mess.roomId);
    if (index != -1) {
      final room = controller.items[index];
      room.lastMessage = mess.toLastMessageModel;
      room.messageUnreadCount = (room.messageUnreadCount ?? 0) + 1;
      final messageController = room.messageController;
      if (messageController != null) {
        messageController.items.insert(0, mess);
        messageController.config.offset++;
      }
    }

    // update unread count
    if (user?.userId != null) {
      GetIt.I<IChatUserRepo>().getMessageUnreadCount(user!.userId!);
    }
    controller.callListeners();
  }

  Future<ChatRoomModel> getRoomChat(
      num partnerId, String compoundingCarCustomerCode) async {
    final index = controller.items.indexWhere((element) {
      final user = GetIt.I<AppState>().currentState.chatUser!;
      final partner = element.getOtherMembers(user.userId!);
      return (partner.isNotEmpty &&
          element.dependId == compoundingCarCustomerCode);
    });

    if (index != -1) {
      return Future.value(controller.items[index]);
    } else {
      AppDialog.I.showLoading();
      final result = await ChatRoomRepo()
          .createSingleRoom(partnerId, compoundingCarCustomerCode);
      AppDialog.I.closeDialog();

      return result.fold((l) {
        return Future.error(l);
      }, (data) {
        return data;
      });
    }
  }

  void initController() {
    // loadAdminRoom();
    controller = PaginationHelper<ChatRoomModel>(
      limit: 30,
      asyncTask: (config) {
        return getRooms(config).then((data) {
          config.canLoadMore = data.pagination.canLoadMore;
          return data.items;
        }).catchError((e) {
          log(e.toString());
          config.canLoadMore = false;
          throw e;
        });
      },
    );
    controller.run();
  }

  addRoom(ChatRoomModel room) {
    final index =
        controller.items.indexWhere((element) => element.roomId == room.roomId);
    if (index == -1) {
      controller.updateList(controller.items..insert(0, room));
      controller.addOffset(1);
    } else {
      controller.items[index] = room;
      controller.callListeners();
    }
  }

  // loadAdminRoom() {
  //   adminRoom.add(null);
  //   getRooms(PaginationConfig(offset: 0), roomType: RoomType.admin)
  //       .then((data) {
  //     if (data.items.isNotEmpty) {
  //       adminRoom.add(data.items.first);
  //     }
  //   });
  // }

  Future<ChatPagingResponse<ChatRoomModel>> getRooms(PaginationConfig config,
      {RoomType? roomType}) async {
    var result = await GetIt.I<IChatRoomRepo>().getListRoom(
      limit: 30,
      offset: config.offset,
      roomType: roomType,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        final user = GetIt.I<AppState>().currentState.chatUser;
        // update unread count
        if (user?.userId != null) {
          GetIt.I<IChatUserRepo>().getMessageUnreadCount(user!.userId!);

          for (final room in data.items) {
            var otherMembers = room.getOtherMembers(user.userId);
            final isRoomOnline = otherMembers
                .where((element) => element.isOnline ?? false)
                .isNotEmpty;
            room.isOnline = isRoomOnline;
          }
        }
        return data;
      },
    );
  }

  Future<ChatRoomModel?> getAdminRoomChat() async {
    final index = controller.items.indexWhere((element) {
      return element.roomType == RoomType.admin;
    });

    if (index != -1) {
      return Future.value(controller.items[index]);
    } else {
      AppDialog.I.showLoading();
      final result = await GetIt.I<IChatRoomRepo>().getListRoom(
        roomType: RoomType.admin,
      );
      AppDialog.I.closeDialog();

      return result.fold((l) {
        return Future.error(l);
      }, (data) {
        return data.items.firstOrNull;
      });
    }
  }

  openAdminRoomChat(BuildContext context) {
    Future<ChatRoomModel> room =
        ChatSocketHelper.I.getAdminRoomChat().then<ChatRoomModel>((value) {
      if (value == null) {
        return Future.error(
            ServerFailure("Hiện tại không thể liên hệ trung tâm hỗ trợ Exxe"));
      }
      return value;
    }).catchError((error) {
      return error;
    });
    ChatSocketHelper.I.openRoomChat(room, context);
  }

  openRoomChat(Future<ChatRoomModel> getRoom, BuildContext context) {
    getRoom.then((value) {
      Navigator.pushNamed(
        context,
        Routes.chatRoom,
        arguments: value,
      );
    }).catchError((error) {
      AppDialog.I.showWarning(
          message: "Người dùng này chưa được kích hoạt tài khoản chat");
      log(error.toString());
    });
  }

  void dispose() {
    controller.dispose();
    socket.disconnect();
    socket.dispose();
    socket.destroy();
  }
}
