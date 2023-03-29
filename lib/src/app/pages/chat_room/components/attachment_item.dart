import 'dart:ui' as ui;

import '../../../../data_chat/data_chat.dart';
import '../../../../utils/export/ui_export.dart';

class AttachmentItem extends StatefulWidget {
  const AttachmentItem(
      {Key? key, required this.attachment, required this.maxWidth})
      : super(key: key);
  final ChatAttachmentModel attachment;
  final double maxWidth;

  @override
  State<AttachmentItem> createState() => _AttachmentItemState();
}

class _AttachmentItemState extends State<AttachmentItem> {
  ui.Image? imageInfo;

  @override
  void initState() {
    super.initState();
    Image image =
        (widget.attachment.url == null && widget.attachment.filePath != null)
            ? Image.file(File(widget.attachment.filePath!))
            : Image.network(widget.attachment.url!);
    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      imageInfo = info.image;
      if (mounted) {
        setState(() {});
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final size = imageInfo != null
        ? imageInfo!.width < widget.maxWidth
            ? imageInfo!.width
            : widget.maxWidth
        : widget.maxWidth;
    final ratio =
        imageInfo != null ? (imageInfo!.height / imageInfo!.width) : 1;
    if (widget.attachment.url == null && widget.attachment.filePath != null) {
      return SizedBox(
        height: (size * ratio).toDouble(),
        width: size.toDouble(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            File(widget.attachment.filePath!),
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }
    return NetworkZoomableImage(
      url: widget.attachment.url,
      size: size.toDouble(),
      ratio: ratio.toDouble(),
    );
  }
}
