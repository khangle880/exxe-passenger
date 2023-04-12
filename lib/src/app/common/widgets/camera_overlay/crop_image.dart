import 'package:image_crop/image_crop.dart';

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
  final cropKey = GlobalKey<CropState>();
  late final File file;

  @override
  void initState() {
    file = File.fromRawPath(widget.imageData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          AppDialog.I.showLoading();
          final scale = cropKey.currentState?.scale;
          final area = cropKey.currentState?.area;
          if (area == null) {
            return;
          }

          final sample = await ImageCrop.sampleImage(
            file: file,
            preferredSize: (2048 / (scale ?? 1)).round(),
          );

          final croppedFile = await ImageCrop.cropImage(
            file: sample,
            area: area,
          );

          sample.delete();
          if (mounted) {
            Navigator.pop<Uint8List>(context, croppedFile.readAsBytesSync());
          }
        },
        child: const Icon(Icons.cut, color: AppColors.primaryLight),
      ),
      backgroundColor: Colors.black.withAlpha(100),
      body: Crop.file(
        File.fromRawPath(widget.imageData),
        key: cropKey,
      ),
    );
  }
}
