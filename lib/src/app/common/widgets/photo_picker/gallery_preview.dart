import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../storage/models/photo.dart';
import '../../../../utils/export/ui_export.dart';

class GalleryPreview extends StatefulWidget {
  const GalleryPreview({Key? key, this.onPickAsset, required this.requestType})
      : super(key: key);
  final Function(Uint8List bytes, MediaType type)? onPickAsset;
  final RequestType requestType;

  @override
  State<GalleryPreview> createState() => _GalleryPreviewState();
}

class _GalleryPreviewState extends State<GalleryPreview> {
  late final PickerAssetHelper pickerAssetHelper;
  bool isLoading = true;
  Box<PhotoHiveModel>? box;

  @override
  void initState() {
    pickerAssetHelper = PickerAssetHelper(
      requestType: widget.requestType,
      onRefresh: () {
        setState(() {});
      },
    );
    loadGallery();
    super.initState();
  }

  loadGallery() async {
    box = await Hive.openBox(PhotoHiveBox.boxName);
    final permission = await pickerAssetHelper.init();
    log(permission.toString());
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: const SizedBox().appCenterProgressLoading,
      );
    }
    if (pickerAssetHelper.paginationHelper == null && box != null) {
      return ValueListenableBuilder(
          valueListenable: box!.listenable(),
          builder: (context, Box<PhotoHiveModel> box, _) {
            final items = box.values.toList()
              ..sort((first, second) =>
                  second.timeStamp.compareTo(first.timeStamp));
            if (items.isEmpty) return Container(height: 24);
            return Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    final bytes = items.toList()[index].file;
                    return InkWell(
                      onTap: () {
                        widget.onPickAsset?.call(bytes, MediaType.image);
                      },
                      child: ThumbnailWidget(
                        bytes: bytes,
                      ),
                    );
                  },
                  itemCount: items.length,
                ),
              ),
            );
          });
    }
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: SizedBox(
        height: 100,
        child: PaginationListView(
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          loadingIndicatorBuilder: (_) => Center(
            child: Container(
                padding: const EdgeInsets.all(35),
                height: 100,
                width: 100,
                child: const CircularProgressIndicator()),
          ),
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            final asset = pickerAssetHelper.paginationHelper!.items[index];
            return InkWell(
              onTap: () async {
                AppDialog.I.showLoading();
                final file = await asset.file;
                if (file == null) {
                  if (mounted) {
                    AppDialog.I.closeDialog();
                    AppDialog.I.showWarning(
                        message: "Không thể truy cập tài nguyên này");
                  }
                } else {
                  if (asset.type == AssetType.image) {
                    var bytes =
                        await ImageHelper.compressAndStoreImage(asset, file);
                    if (mounted) {
                      AppDialog.I.closeDialog();

                      widget.onPickAsset?.call(bytes, MediaType.image);
                    }
                  } else {
                    Uint8List bytes = await file.readAsBytes();
                    if (mounted) {
                      AppDialog.I.closeDialog();
                      widget.onPickAsset?.call(bytes, MediaType.image);
                    }
                  }
                }
                // widget.onTap?.call(asset);
              },
              child: AssetThumbnail(asset: asset),
            );
          },
          paginationController: pickerAssetHelper.paginationHelper!,
        ),
      ),
    );
  }
}
