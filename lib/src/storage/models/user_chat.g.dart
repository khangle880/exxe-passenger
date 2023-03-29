// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatUserHiveAdapter extends TypeAdapter<ChatUserHive> {
  @override
  final int typeId = 2;

  @override
  ChatUserHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatUserHive(
      token: fields[0] as String,
      refreshToken: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatUserHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.refreshToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatUserHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
