import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../../utils/export/ui_export.dart';

class NetworkZoomableImage extends StatelessWidget {
  const NetworkZoomableImage({
    Key? key,
    required this.url,
    required this.size,
    this.ratio = 1,
    this.fit = BoxFit.fitWidth,
  }) : super(key: key);
  final String? url;
  final double size;
  final double ratio;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return ImagePage(
                url: url,
                fit: fit,
              );
            },
          ),
        );
      },
      child: CustomNetworkImage(
        host: Apis.baseUrl,
        url: url,
        height: (size * ratio).toDouble(),
        width: size.toDouble(),
        fit: BoxFit.fitWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  const ImagePage({super.key, this.url, this.fit});
  final String? url;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Center(
            child: ZoomOverlay(
              modalBarrierColor: Colors.black12,
              minScale: 0.5,
              maxScale: 3.0,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: const Duration(milliseconds: 300),
              twoTouchOnly: true,
              child: CustomNetworkImage(
                host: Apis.baseUrl,
                url: url,
                fit: fit,
                decoration: const BoxDecoration(),
              ),
            ),
          ),
          const Positioned(
            left: 16,
            top: 16,
            child: SafeArea(
              child: IconArrowBackCircle(),
            ),
          ),
        ],
      ),
    );
  }
}
