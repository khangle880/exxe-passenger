import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import 'verify_scaffold.dart';

class PickupImageItem extends StatefulWidget {
  const PickupImageItem(
      {Key? key,
      this.imageData,
      this.url,
      required this.title,
      this.height,
      required this.onUploaded,
      required this.cameraDescription,
      this.padding,
      this.hasOverlay})
      : super(key: key);
  final Uint8List? imageData;
  final String? url;
  final String title;
  final String cameraDescription;
  final double? height;
  final bool? hasOverlay;
  final EdgeInsets? padding;
  final Function(ImageModel image) onUploaded;

  @override
  State<PickupImageItem> createState() => _PickupImageItemState();
}

class _PickupImageItemState extends State<PickupImageItem> {
  _uploadImage(Uint8List bytes, Function(ImageModel value) callback) async {
    AppDialog.I.showLoading();
    await VerifyScaffold.uploadImage([bytes]).then((value) {
      callback(value.first.toImageModel());
    }).catchError((e) {
      AppDialog.I
          .showWarning(message: "Xảy ra lỗi khi tải ảnh lên");
    });
    AppDialog.I.closeDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 160,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 42),
      child: GestureDetector(
        onTap: () {
          PickupImageSheet.showBottomSheet(
            context,
            title: widget.title,
            description: widget.cameraDescription,
            hasOverlay: widget.hasOverlay,
            onPicked: (Uint8List bytes) {
              Navigator.pop(context);
              _uploadImage(bytes, widget.onUploaded);
            },
          );
        },
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return widget.imageData != null
        ? Image.memory(widget.imageData!)
        : widget.url != null
            ? CachedNetworkImage(
                imageUrl: Apis.baseUrl + (widget.url ?? ""),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.fitWidth),
                  ),
                ),
                placeholder: (context, url) =>
                    const SizedBox().appCenterProgressLoading,
                errorWidget: (context, url, error) =>
                    SvgPicture.asset(AppIcons.warning),
              )
            : Column(
                children: [
                  Container(
                    height: 32,
                    width: double.maxFinite,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        color: AppColors.primaryMain),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                        color: AppColors.primaryMain +
                            AppColors.primaryLight.withOpacity(0.95),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(AppIcons.camera,
                                width: 24,
                                height: 24,
                                color: AppColors.primaryMain),
                            const SizedBox(height: 12),
                            Text(
                              widget.title,
                              style: AppStyles.s12w4
                                  .withColor(AppColors.primaryMain),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}
