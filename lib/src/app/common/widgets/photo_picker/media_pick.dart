import 'package:flutter/cupertino.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MediaPicker {
  static Future<List<AssetEntity>> multiImagePick(
      BuildContext context, int limit) async {
    return mediaPick(
        context: context,
        requestType: RequestType.image,
        maxAssetsCount: limit);
  }

  static Future<List<AssetEntity>> multiVideoPick(BuildContext context) async {
    return mediaPick(context: context, requestType: RequestType.video);
  }

  static Future<AssetEntity?> singleImagePick(BuildContext context) async {
    return mediaPick(
      context: context,
      requestType: RequestType.image,
      maxAssetsCount: 1,
    ).then((value) => value.isEmpty ? null : value.first);
  }

  static Future<AssetEntity?> singleVideoPick(BuildContext context) async {
    return mediaPick(
      context: context,
      requestType: RequestType.video,
      maxAssetsCount: 1,
    ).then((value) => value.isEmpty ? null : value.first);
  }

  static Future<List<AssetEntity>> mediaPick({
    required BuildContext context,
    required RequestType requestType,
    int maxAssetsCount = 9,
  }) async {
    final List<AssetEntity> result = await AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            requestType: requestType,
            maxAssets: maxAssetsCount,
            textDelegate: const EnglishAssetPickerTextDelegate(),
          ),
        ) ??
        [];

    // return Future.wait(result.map((e) async {
    //   return (await e.originFile)?.path;
    // })).then((value) => List.from(value.where((element) => element != null)));
    return result;
  }
}
