import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../../../../storage/models/photo.dart';
import '../../../../utils/export/ui_export.dart';

class PickupImageSheet extends StatefulWidget {
  static showBottomSheet(
    BuildContext context, {
    required String title,
    String? description,
    required Function(Uint8List) onPicked,
    Function(List<Uint8List> images)? onMultiPicked,
    int limit = 1,
    bool? hasOverlay = true,
  }) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      backgroundColor: AppColors.primaryLight,
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
          child: PickupImageSheet(
            cameraTitle: title,
            cameraDescription: description,
            limit: limit,
            hasOverlay: hasOverlay,
            onMultiPicked: onMultiPicked,
            onPicked: onPicked,
          ),
        );
      },
    );
  }

  const PickupImageSheet(
      {Key? key,
      required this.onPicked,
      this.hasOverlay = true,
      required this.cameraTitle,
      this.cameraDescription,
      this.onMultiPicked,
      this.limit = 1})
      : assert(!(limit > 1 && onMultiPicked == null)),
        super(key: key);
  final Function(Uint8List bytes) onPicked;
  final bool? hasOverlay;
  final String cameraTitle;
  final String? cameraDescription;
  final int limit;
  final Function(List<Uint8List> images)? onMultiPicked;

  @override
  State<PickupImageSheet> createState() => _PickupImageSheetState();
}

class _PickupImageSheetState extends State<PickupImageSheet> {
  void onPickImage(Uint8List bytes, MediaType type) async {
    widget.onPicked(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            child: Text("Chọn ảnh", style: AppStyles.s21w7)),
        GalleryPreview(
          onPickAsset: onPickImage,
          requestType: RequestType.image,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  if (widget.limit == 1) {
                    final asset = await MediaPicker.singleImagePick(context);
                    if (asset == null) return;
                    final file = await asset.file;
                    if (file == null) {
                      if (mounted) {
                        AppDialog.I.showWarning(
                            message: "Không thể truy cập tài nguyên này");
                      }
                    } else {
                      var bytes =
                          await ImageHelper.compressAndStoreImage(asset, file);

                      onPickImage(bytes, MediaType.image);
                    }
                  } else {
                    final assets =
                        await MediaPicker.multiImagePick(context, widget.limit);
                    if (assets.isEmpty) return;
                    final files = await Future.wait(assets.map(
                        (e) => e.file.then((value) => MapEntry(e, value))));
                    final availableFiles =
                        files.where((e) => e.value != null).toList();
                    if (availableFiles.isEmpty) {
                      if (mounted) {
                        AppDialog.I.showWarning(
                            message: "Không thể truy cập tài nguyên này");
                      }
                    } else {
                      var list = await Future.wait(availableFiles.map((e) =>
                          ImageHelper.compressAndStoreImage(e.key, e.value!)));

                      widget.onMultiPicked!(list);
                    }
                  }
                },
                child: Container(
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.gray05 + AppColors.gray10,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            AppIcons.imagePicker,
                            height: 28,
                            width: 28,
                            color: AppColors.primaryMain,
                          )),
                      Text("Thư viện",
                          style: AppStyles.s16w5.withColor(AppColors.gray60x9d))
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraCardPage(
                        hasOverlay: widget.hasOverlay ?? true,
                        title: widget.cameraTitle,
                        description: widget.cameraDescription == null
                            ? null
                            : Text(widget.cameraDescription!,
                                textAlign: TextAlign.center,
                                style: AppStyles.s14w6
                                    .withColor(AppColors.primaryLight)),
                        onCapture: (value) async {
                          final bytes =
                              (await ImageHelper.compressImage(value)) ?? value;
                          var uuid = const Uuid();
                          PhotoHiveBox.instance.savePhoto(
                            PhotoHiveModel(
                              id: uuid.v1(),
                              timeStamp: DateTime.now().millisecondsSinceEpoch,
                              file: bytes,
                            ),
                          );
                          onPickImage(bytes, MediaType.image);
                        },
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 88,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.gray05 + AppColors.gray10,
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          AppIcons.camera,
                          height: 32,
                          width: 32,
                          color: AppColors.primaryMain,
                        ),
                      ),
                      Text("Chụp ảnh",
                          style: AppStyles.s16w5.withColor(AppColors.gray60x9d))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
