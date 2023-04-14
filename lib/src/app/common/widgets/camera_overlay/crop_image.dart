// import 'package:image_crop/image_crop.dart';
//
// import '../../../../utils/export/ui_export.dart';
//
// class CropImagePage extends StatefulWidget {
//   const CropImagePage(
//       {super.key,
//       required this.filePath,
//       required this.ratio,
//       required this.initialSize});
//
//   final String filePath;
//   final double ratio;
//   final double initialSize;
//
//   @override
//   State<CropImagePage> createState() => _CropImagePageState();
// }
//
// class _CropImagePageState extends State<CropImagePage> {
//   final cropKey = GlobalKey<CropState>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           AppDialog.I.showLoading();
//           final scale = cropKey.currentState?.scale;
//           final area = cropKey.currentState?.area;
//           if (area == null) {
//             return;
//           }
//
//           final sample = await ImageCrop.sampleImage(
//             file: File(widget.filePath),
//             preferredSize: (2048 / (scale ?? 1)).round(),
//           );
//
//           final croppedFile = await ImageCrop.cropImage(
//             file: sample,
//             area: area,
//           );
//
//           sample.delete();
//           AppDialog.I.closeDialog();
//           if (mounted) {
//             Navigator.pop<Uint8List>(context, croppedFile.readAsBytesSync());
//           }
//         },
//         child: const Icon(Icons.cut, color: AppColors.primaryLight),
//       ),
//       // backgroundColor: Colors.black.withAlpha(100),
//       // body: Image.file(File(widget.filePath)),
//       body: Column(
//         children: [
//           Expanded(
//             child: Crop(
//               key: cropKey,
//               image: FileImage(File(widget.filePath)),
//               aspectRatio: 4.0 / 3.0,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
