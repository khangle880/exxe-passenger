import 'dart:typed_data';

import 'package:hive/hive.dart';

import '../../utils/constants/constants.dart';

part 'photo.g.dart';

@HiveType(typeId: 3)
class PhotoHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int timeStamp;

  @HiveField(2)
  Uint8List file;

  PhotoHiveModel({
    required this.timeStamp,
    required this.id,
    required this.file,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoHiveModel &&
          runtimeType == other.runtimeType &&
          file == other.file;

  @override
  int get hashCode => file.hashCode;
}

class PhotoHiveBox {
  static PhotoHiveBox instance = PhotoHiveBox();
  static const String boxName = HiveBoxName.photoBox;
  late Future<Box<PhotoHiveModel>> _box;

  PhotoHiveBox() {
    _box = Hive.openBox(boxName);
  }

  void savePhoto(PhotoHiveModel photo) async {
    var box = await _box;
    box.put(photo.id, photo);
  }

  Future<List<PhotoHiveModel>> readPhotos() async {
    var box = await _box;
    return box.values.toList();
  }

  void updatePhoto(PhotoHiveModel photo) async {
    var box = await _box;
    box.put(photo.id, photo);
  }

  void deletePhoto(String id) async {
    var box = await _box;
    box.delete(id);
  }
}
