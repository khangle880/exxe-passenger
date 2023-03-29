import '../../../../data/models/models.dart';
import '../../../../utils/export/ui_export.dart';
import 'pickup_image_item.dart';

class PickupImagePage extends StatelessWidget {
  const PickupImagePage({
    Key? key,
    this.title,
    required this.cameraDescription,
    this.initFrontImage,
    this.initBackImage,
    required this.onNext,
    required this.onPickedFront,
    required this.onPickedBack,
  }) : super(key: key);
  final String? title;
  final String cameraDescription;
  final Function() onNext;
  final ImageModel? initFrontImage;
  final ImageModel? initBackImage;
  final Function(ImageModel value) onPickedFront;
  final Function(ImageModel value) onPickedBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              title ??
                  "Vui lòng gửi hình ảnh giấy tờ còn hạn, hình gốc không scan hay photocopy.",
              textAlign: TextAlign.center,
              style: AppStyles.s14w6.withColor(AppColors.gray60x9d),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text("Mặt trước", style: AppStyles.s16w6),
            ),
            PickupImageItem(
              url: initFrontImage?.url,
              title: "Chụp mặt trước",
              cameraDescription: cameraDescription,
              onUploaded: onPickedFront,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text("Mặt sau", style: AppStyles.s16w6),
            ),
            PickupImageItem(
              url: initBackImage?.url,
              title: "Chụp mặt sau",
              cameraDescription: cameraDescription,
              onUploaded: onPickedBack,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ButtonWidget(
        onClick:
            (initFrontImage != null && initBackImage != null) ? onNext : null,
        radius: 12,
        child: Text("Tiếp tục",
            style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
      ).bottomSingle(),
    );
  }
}
