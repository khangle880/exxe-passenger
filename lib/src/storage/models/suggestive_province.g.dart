// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestive_province.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SuggestiveProvinceAdapter extends TypeAdapter<SuggestiveProvince> {
  @override
  final int typeId = 4;

  @override
  SuggestiveProvince read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SuggestiveProvince(
      provinceId: fields[0] as int,
      provinceName: fields[1] as String,
      distance: fields[2] == null ? 0 : fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, SuggestiveProvince obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.provinceId)
      ..writeByte(1)
      ..write(obj.provinceName)
      ..writeByte(2)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestiveProvinceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
