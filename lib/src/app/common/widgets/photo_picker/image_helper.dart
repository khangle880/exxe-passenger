import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../storage/models/photo.dart';

class ImageHelper {
  static Future<Uint8List?> compressImage(Uint8List image) async {
    return await FlutterImageCompress.compressWithList(
      image,
      minHeight: 1280,
      minWidth: 1980,
      quality: 40,
    );
  }

  static Future<Uint8List> compressAndStoreImage(
      AssetEntity asset, File file) async {
    final bytes = (await ImageHelper.compressImage(file.readAsBytesSync())) ??
        file.readAsBytesSync();
    PhotoHiveBox.instance.savePhoto(
      PhotoHiveModel(
        id: asset.id,
        timeStamp: asset.createDateTime.millisecondsSinceEpoch,
        file: bytes,
      ),
    );
    return bytes;
  }
}
