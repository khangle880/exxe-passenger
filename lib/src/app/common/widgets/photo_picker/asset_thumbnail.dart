import 'package:photo_manager/photo_manager.dart';

import '../../../../utils/export/ui_export.dart';

class AssetThumbnail extends StatelessWidget {
  const AssetThumbnail({
    Key? key,
    required this.asset,
  }) : super(key: key);

  final AssetEntity asset;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    final thumbnailWidget = FutureBuilder<Uint8List?>(
      future: asset.thumbnailData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;
        // If we have no data, display a spinner
        if (bytes == null) return const SizedBox().appCenterProgressLoading;
        // If there's data, display it as an image
        return ThumbnailWidget(bytes: bytes);
      },
    );
    return thumbnailWidget;
    // return InkWell(
    //   onTap: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (_) {
    //           if (asset.type == AssetType.image) {
    //             // If this is an image, navigate to ImageScreen
    //             return ImageScreen(imageFile: asset.file);
    //           } else {
    //             // if it's not, navigate to VideoScreen
    //             return VideoScreen(videoFile: asset.file);
    //           }
    //         },
    //       ),
    //     );
    //   },
    //   child: ,
    // );
  }
}

class ThumbnailWidget extends StatelessWidget {
  const ThumbnailWidget({Key? key, required this.bytes}) : super(key: key);
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 106,
      height: 95,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray10),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.memory(bytes, fit: BoxFit.cover)),
    );
  }
}
