import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/token/token_cubit.dart';
import '../../../../data/data.dart';
import 'option_row.dart';

class ServicesOurProfile extends StatefulWidget {
  const ServicesOurProfile({Key? key}) : super(key: key);

  @override
  State<ServicesOurProfile> createState() => _ServicesOurProfileState();
}

class _ServicesOurProfileState extends State<ServicesOurProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Khác',
            style: AppStyles.s16w7,
          ),
        ),
        OptionRow(
          title: 'Về chúng tôi',
          onTap: () => launchUrl(Uri.parse("https://exxe.vn/about-us")),
        ),
        OptionRow(
          title: 'Hướng dẫn sử dụng',
          onTap: () =>
              launchUrl(Uri.parse("https://exxe.vn/guide?type=customer")),
        ),
        OptionRow(
          title: 'Đánh giá hệ thống',
          onTap: () async {
            const bundleId = 'com.exxe.passenger';
            const appId = '6446165618';
            final url = Uri.parse(
                'https://play.google.com/store/apps/details?id=$bundleId');
            final iosUrl = Uri.parse(
                'itms-apps://itunes.apple.com/app/id$appId?action=write-review');
            if (Platform.isAndroid && await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else if (Platform.isIOS && await canLaunchUrl(iosUrl)) {
              await launchUrl(iosUrl, mode: LaunchMode.externalApplication);
            }
          },
        ),
        OptionRow(
          title: 'Chính sách bảo mật',
          onTap: () =>
              launchUrl(Uri.parse("https://exxe.vn/terms-&-conditions")),
        ),
        OptionRow(
          title: 'Hỗ trợ qua chat',
          onTap: () {
            ChatSocketHelper.I.openAdminRoomChat(context);
          },
        ),
        OptionRow(
            title: 'Hỗ trợ qua email',
            onTap: () async {
              await openEmail(context);
            }),
        _buildDeleteAccount(),
      ],
    );
  }

  Future<void> openEmail(BuildContext context) async {
    var apps = await OpenMailApp.getMailApps();
    if (apps.isEmpty && mounted) {
      AppDialog.I.showNoMailAppsDialog(context);
    } else {
      EmailContent email = EmailContent(
        to: [
          'cskh@exxe.vn',
        ],
        subject: 'Hỗ trợ tài xế Exxe',
      );
      showDialog(
          context: context,
          builder: (context) {
            return MailAppPickerDialog(mailApps: apps, emailContent: email);
          });
    }
  }

  _buildDeleteAccount() {
    final user = GetIt.I<AppState>().currentState.user;
    if (user?.phone == null) return const SizedBox();
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.otp,
          arguments: user!.phone!.convertToCountryPhoneCode(),
        ).then((value) {
          if (value is String) {
            AppDialog.I.showWarning(
              message: "Bạn xác nhận xóa tài khoản này ?",
              onConfirm: () async {
                AppDialog.I.closeDialog();
                final result = await GetIt.I<IUserRepo>().deleteAccount(value);
                result.fold((l) => log(l.toString()), (r) {
                  context.read<TokenCubit>().logOut();
                });
              },
            );
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.trash,
              color: AppColors.utilRed,
            ),
            const SizedBox(width: 8),
            Text(
              "Xóa Tài khoản",
              style: AppStyles.s16w5.withColor(AppColors.utilRed),
            ),
          ],
        ),
      ),
    );
  }
}
