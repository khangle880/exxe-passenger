import 'dart:convert';

import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class VerifyScaffold extends StatelessWidget {
  const VerifyScaffold(
      {Key? key,
      required this.title,
      this.confirmTitle,
      this.onConfirm,
      required this.body})
      : super(key: key);
  final String title;
  final String? confirmTitle;
  final Function()? onConfirm;
  final Widget body;

  static Future<List<AttachmentModel>> uploadImage(List<Uint8List> list) async {
    final List<AttachmentParam> attachmentParams = list
        .map((e) =>
            AttachmentParam(base64: base64.encode(e), type: MediaType.image))
        .toList();
    final result =
        await GetIt.I<IUserInfoRepo>().createAttachmentData(attachmentParams);

    return result.fold((failure) => Future.error(failure), (data) {
      log(data.map((e) => e.attachmentUrl).toString());
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.primaryLight,
      appBar: CustomAppBarWidget(
        centerTitle: true,
        autoGeneraIconLeading: true,
        title: title,
        fontSizeTitle: 18,
        context: context,
        backgroundColor: AppColors.primaryLight,
      ),
      body: body,
      bottomNavigationBar: confirmTitle == null
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: SizedBox(
                width: double.maxFinite,
                child: ButtonWidget(
                  onClick: onConfirm,
                  radius: 12,
                  child: Text(confirmTitle!,
                      style: AppStyles.s16w6.withColor(AppColors.primaryLight)),
                ),
              ),
            ),
    );
  }
}
