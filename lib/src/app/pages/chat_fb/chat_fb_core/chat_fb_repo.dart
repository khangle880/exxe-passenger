import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../../config/routes.dart';
import '../../../../utils/export/logic_export.dart';
import '../../../common/dialog/dialog_control.dart';
import 'firebase_chat_core.dart';

class ChatFbRepo {
  ChatFbRepo();

  Future<bool> register({
    required String userName,
    required String avatar,
    required num partnerId,
    required String phone,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "user$partnerId${phone.substring(5, 10)}@gmail.com",
        password: phone.substring(5, 10) +
            partnerId.toString() +
            phone.substring(0, 5),
      );
      await FirebaseChatCore.instance.createUserInFirestore(
        types.User(
          firstName: userName,
          id: credential.user!.uid,
          imageUrl: avatar,
          lastName: "",
          metadata: {
            "partnerId": partnerId,
            "phone": phone,
          },
        ),
      );

      return true;
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return false;
    }
  }

  Future<bool> updateProfile({
    String? userName,
    String? avatar,
  }) async {
    try {
      final me = await FirebaseChatCore.instance.getMe();
      final defaultUser = types.User(
        id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
      );
      var newUser = me ?? defaultUser;
      if ((userName ?? "").isNotEmpty) {
        newUser = newUser.copyWith(firstName: userName);
      }
      if ((avatar ?? "").isNotEmpty) {
        newUser = newUser.copyWith(imageUrl: avatar);
      }

      await FirebaseChatCore.instance.createUserInFirestore(newUser);

      return true;
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return false;
    }
  }

  Future<bool> login(String partnerId, String phone) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "user$partnerId${phone.substring(5, 10)}@gmail.com",
        password: phone.substring(5, 10) +
            partnerId.toString() +
            phone.substring(0, 5),
      );
      return true;
    } catch (e, stackTrace) {
      log(e.toString() + stackTrace.toString());
      return false;
    }
  }

  Future<dynamic> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future deleteRoomByDependId(String dependId) async {
    await FirebaseChatCore.instance
        .getFirebaseFirestore()
        .collection(FirebaseChatCore.instance.config.roomsCollectionName)
        .where('metadata.dependId', isEqualTo: dependId)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.update({'metadata.status': 'inactive'});
      }
    });
  }

  openAdminRoomChat(BuildContext context) {
    Future<types.Room> room = getAdminRoomChat().catchError((error) {
      return error;
    });
    openRoomChat(room, context);
  }

  Future<types.Room> getAdminRoomChat() async {
    try {
      final room = await FirebaseChatCore.instance.getRoomAdmin();
      if (room != null) {
        return room;
      } else {
        final admin = await FirebaseChatCore.instance.getUserAdmin();
        if (admin != null) {
          final room = await FirebaseChatCore.instance.createRoom(admin);
          return FirebaseChatCore.instance.room(room.id).first;
        }
        return Future.error("Không tồn tại");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<types.Room> getRoomChat(
      String dependId, String rideId, num partnerId) async {
    try {
      final room = await FirebaseChatCore.instance.getRoomByDependId(dependId);
      if (room != null) {
        return room;
      } else {
        final user = await FirebaseChatCore.instance.getUser(partnerId);
        if (user != null) {
          final room = await FirebaseChatCore.instance.createRoom(
            user,
            metadata: {"dependId": dependId, "rideId": rideId},
          );
          return FirebaseChatCore.instance.room(room.id).first;
        }
        return Future.error("Không tồn tại");
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  openRoomChat(Future<types.Room?> getRoom, BuildContext context) async {
    AppDialog.I.showLoading();
    getRoom.then((value) {
      AppDialog.I.closeDialog();
      Navigator.pushNamed(
        context,
        Routes.chatRoom,
        arguments: value,
      );
    }).catchError((error) {
      AppDialog.I.closeDialog();
      AppDialog.I.showWarning(message: "Cuộc hội thoại chưa tồn tại");
      log(error.toString());
    });
  }
}
