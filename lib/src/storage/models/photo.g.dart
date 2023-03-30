// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoHiveModelAdapter extends TypeAdapter<PhotoHiveModel> {
  @override
  final int typeId = 3;

  @override
  PhotoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PhotoHiveModel(
      timeStamp: fields[1] as int,
      id: fields[0] as String,
      file: fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, PhotoHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timeStamp)
      ..writeByte(2)
      ..write(obj.file);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
