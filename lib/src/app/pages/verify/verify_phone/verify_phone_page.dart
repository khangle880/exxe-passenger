import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';
import '../components/pickup_image_item.dart';
import '../components/verify_phone_introview.dart';
import '../components/verify_scaffold.dart';

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({Key? key}) : super(key: key);

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  ImageModel? imageData;

  @override
  Widget build(BuildContext context) {
    return VerifyScaffold(
      title: "Xác minh số điện thoại",
      confirmTitle: "Hoàn tất",
      onConfirm: imageData == null
          ? null
          : () async {
              GetIt.I<IUserInfoRepo>()
                  .createVerifiedNumberPhone(imageData!.id!)
                  .then((value) {
                value.fold((failure) {
                  log(failure.toString());
                }, (data) {
                  Navigator.pop(context, true);
                });
              });
            },
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(
                "Vui lòng soạn tin nhắn theo cú pháp “TTTB” gửi đến 1414 để xác minh sim chính chủ",
                textAlign: TextAlign.center,
                style: AppStyles.s14w6.withColor(AppColors.gray60x9d),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text("Chụp tin nhắn", style: AppStyles.s16w6),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: PickupImageItem(
                hasOverlay: false,
                url: imageData?.url,
                onUploaded: (ImageModel image) {
                  imageData = image;
                  setState(() {});
                },
                title: "Chụp tin nhắn xác minh",
                cameraDescription:
                    "Vui lòng hướng camera vào nội dung tin nhắn để chụp ảnh",
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text(
                    "Hướng dẫn",
                    style:
                        AppStyles.s14w6.withColor(AppColors.primaryMain).copyWith(
                              decoration: TextDecoration.underline,
                            ),
                  ),
                ).inkWell(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const VerifyPhoneIntroView();
                      },
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
