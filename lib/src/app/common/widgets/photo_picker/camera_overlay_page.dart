import 'package:camera/camera.dart';

import '../../../../utils/export/ui_export.dart';

class CameraCardPage extends StatefulWidget {
  const CameraCardPage({
    Key? key,
    required this.title,
    this.description,
    required this.onCapture,
    this.hasOverlay = true,
  }) : super(key: key);
  final String title;
  final Widget? description;
  final Function(Uint8List bytes) onCapture;
  final bool hasOverlay;

  @override
  State<CameraCardPage> createState() => _CameraCardPageState();
}

class _CameraCardPageState extends State<CameraCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryMain,
      appBar: CustomAppBarWidget(
        centerTitle: true,
        autoGeneraIconLeading: true,
        title: widget.title,
        fontSizeTitle: 18,
        textColor: AppColors.primaryLight,
        iconColor: AppColors.primaryLight,
        context: context,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<CameraDescription>?>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Không thể truy cập camera',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                    }
                    return CameraOverlay(
                      snapshot.data!.first,
                      hasOverlay: widget.hasOverlay,
                      loadingWidget: Container(
                        color: AppColors.primaryMain,
                        child: const Center(
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryLight,
                            )),
                          ),
                        ),
                      ),
                      (Uint8List bytes) {
                        Navigator.pop(context);
                        widget.onCapture(bytes);
                      },
                      info: widget.description,
                      infoMargin: EdgeInsets.zero,
                      flashIcon: (enable) => Container(
                        padding: const EdgeInsets.all(16),
                        child: SvgPicture.asset(AppIcons.flash,
                            width: 44,
                            height: 44,
                            color: enable
                                ? AppColors.primaryLight
                                : AppColors.black),
                      ),
                      cameraIcon: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(100)),
                        padding: const EdgeInsets.all(18),
                        child: SvgPicture.asset(
                          AppIcons.camera,
                          height: 40,
                          width: 40,
                          color: AppColors.primaryMain,
                        ),
                      ),
                    );
                  } else {
                    return const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Đang lấy camera',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
