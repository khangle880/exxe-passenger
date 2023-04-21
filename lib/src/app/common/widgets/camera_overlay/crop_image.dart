import 'package:crop_your_image/crop_your_image.dart';
import '../../../../utils/export/ui_export.dart';

class CropImagePage extends StatefulWidget {
  const CropImagePage(
      {super.key,
      required this.imageData,
      required this.ratio,
      required this.initialSize});

  final Uint8List imageData;
  final double ratio;
  final double initialSize;

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final _controller = CropController();
  bool readyCrop = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: readyCrop
          ? FloatingActionButton(
              onPressed: () {
                AppDialog.I.showLoading();
                _controller.crop();
              },
              child: const Icon(Icons.cut, color: AppColors.primaryLight),
            )
          : null,
      backgroundColor: Colors.black.withAlpha(100),
      body: Crop(
        controller: _controller,
        image: widget.imageData,
        onCropped: (cropped) {
          AppDialog.I.closeDialog();
          Navigator.pop<Uint8List>(context, cropped);
        },
        onStatusChanged: (status) => setState(() {
          readyCrop = status == CropStatus.ready;
        }),
        aspectRatio: widget.ratio,
        initialSize: widget.initialSize,
        // initialAreaBuilder: (rect) => Rect.fromLTRB(rect.left + 24,
        //     rect.top + 32, rect.right - 24, rect.bottom - 32),
        // initialArea: initialArea,
        cornerDotBuilder: (size, cornerIndex) {
          return const DotControl();
        },
        interactive: true,
      ),
    );
  }
}
