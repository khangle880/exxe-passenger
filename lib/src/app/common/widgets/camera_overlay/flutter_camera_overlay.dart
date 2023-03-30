import 'package:camera/camera.dart';
import '../../../../utils/export/ui_export.dart';

typedef XFileCallback = void Function(Uint8List bytes);

class CameraOverlay extends StatefulWidget {
  const CameraOverlay(
    this.camera,
    this.onCapture, {
    Key? key,
    this.enableCaptureButton = true,
    this.label,
    this.info,
    this.loadingWidget,
    this.infoMargin,
    this.cameraIcon,
    this.flashIcon,
    this.hasOverlay = true,
  }) : super(key: key);
  final CameraDescription camera;
  final bool enableCaptureButton;
  final XFileCallback onCapture;
  final String? label;
  final Widget? info;
  final Widget? loadingWidget;
  final Widget? cameraIcon;
  final Widget Function(bool isEnable)? flashIcon;
  final EdgeInsets? infoMargin;
  final bool hasOverlay;

  @override
  State<CameraOverlay> createState() => _FlutterCameraOverlayState();
}

class _FlutterCameraOverlayState extends State<CameraOverlay> {
  _FlutterCameraOverlayState();

  late CameraController controller;
  bool flashEnable = false;
  double bottomLeftWidth = 60;
  final ratio = 1.42;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingWidget = widget.loadingWidget ??
        Container(
          color: Colors.white,
          height: double.infinity,
          width: double.infinity,
          child: const Align(
            alignment: Alignment.center,
            child: Text('loading camera'),
          ),
        );

    if (!controller.value.isInitialized) {
      return loadingWidget;
    }

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          if (widget.label != null || widget.info != null)
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: widget.infoMargin ??
                      const EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.label != null)
                        Text(
                          widget.label!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                      if (widget.info != null)
                        Flexible(
                          child: widget.info!,
                        ),
                    ],
                  )),
            ),
          const SizedBox(height: 16),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
                if (widget.hasOverlay)
                  OverlayShape(ratio: ratio, width: constraints.maxWidth - 20),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          if (widget.enableCaptureButton)
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MeasureSize(
                    onChange: (size) {
                      bottomLeftWidth = size.width;
                      setState(() {});
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        enableFeedback: true,
                        onTap: () async {
                          flashEnable = !flashEnable;
                          controller.setFlashMode(
                              flashEnable ? FlashMode.always : FlashMode.off);
                          setState(() {});
                        },
                        child: widget.flashIcon?.call(flashEnable) ??
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: flashEnable
                                  ? const Icon(
                                      Icons.flash_on,
                                      size: 40,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.flash_off_outlined,
                                      size: 40,
                                      color: Colors.black,
                                    ),
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      enableFeedback: true,
                      onTap: () => takePhoto(constraints.maxWidth),
                      child: widget.cameraIcon ??
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: const Icon(
                              Icons.camera,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(width: bottomLeftWidth),
                ],
              ),
            ),
        ],
      );
    });
  }

  takePhoto(double width) async {
    for (int i = 10; i > 0; i--) {
      await HapticFeedback.vibrate();
    }
    XFile file = await controller.takePicture();

    if (!widget.hasOverlay) {
      final bytes = await file.readAsBytes();
      widget.onCapture(bytes);
      return;
    }
    // CroppedFile? croppedImage = await ImageCropper().cropImage(
    //   sourcePath: file.path,
    //   aspectRatio: CropAspectRatio(
    //     ratioX: 1,
    //     ratioY: 1 / ratio,
    //   ),
    //   aspectRatioPresets: [
    //     CropAspectRatioPreset.square,
    //     CropAspectRatioPreset.ratio3x2,
    //     CropAspectRatioPreset.original,
    //     CropAspectRatioPreset.ratio4x3,
    //     CropAspectRatioPreset.ratio16x9
    //   ],
    //   uiSettings: [
    //     AndroidUiSettings(
    //       toolbarTitle: 'Cropper',
    //       toolbarColor: Colors.deepOrange,
    //       toolbarWidgetColor: Colors.white,
    //       initAspectRatio: CropAspectRatioPreset.original,
    //       lockAspectRatio: false,
    //     ),
    //     IOSUiSettings(
    //       title: 'Cropper',
    //     ),
    //     WebUiSettings(
    //       context: context,
    //     ),
    //   ],
    // );
    final bytes = await file.readAsBytes();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CropImagePage(
            imageData: bytes,
            ratio: ratio,
            initialSize: (width - 20) / width,
          ),
        ),
      ).then((value) {
        if (value is Uint8List) {
          widget.onCapture(value);
        }
      });
    }
    // if (croppedImage != null) {
    //   widget.onCapture(File(croppedImage.path));
    // }
  }
}
