part of 'chat_room_cubit.dart';

abstract class ChatRoomState extends Equatable {
  const ChatRoomState();

  @override
  List<Object> get props => [];
}

class ChatRoomInitial extends ChatRoomState {}

class RoomNotExist extends ChatRoomState {}
