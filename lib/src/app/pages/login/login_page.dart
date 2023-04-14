import 'package:exxe/src/app/pages/login/components/body_login.dart';
import 'package:exxe/src/app/pages/login/controller/auth_login_bloc.dart';
import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocListener<AuthLoginBloc, AuthLoginState>(
          listenWhen: (old, current) => old.formState != current.formState,
          listener: (context, state) {
            switch (state.formState) {
              case FormLoginStatus.none:
                break;
              case FormLoginStatus.submitting:
                AppDialog.I.showLoading();
                break;
              case FormLoginStatus.failed:
                AppDialog.I.showWarning(message: state.message);
                break;
              case FormLoginStatus.success:
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.home, (_) => false);
                break;
              case FormLoginStatus.notCompatible:
                AppDialog.I.showWarning(
                  message:
                      'Đây là ứng dụng dành cho khách hàng. Tài khoản của bạn đã đăng ký với vai trò khác. Vui lòng đăng nhập tài khoản khác hoặc đăng ký tài khoản mới.',
                  onConfirm: () async {
                    AppDialog.I.closeDialog();
                    const bundleId = 'com.exxe.driver';
                    const appId = '6446149125';
                    final url = Uri.parse(
                        'https://play.google.com/store/apps/details?id=$bundleId');
                    final iosUrl =
                        Uri.parse('itms-apps://itunes.apple.com/app/id$appId');
                    if (Platform.isAndroid && await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    } else if (Platform.isIOS && await canLaunchUrl(iosUrl)) {
                      await launchUrl(iosUrl,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                );
                Future.delayed(const Duration(milliseconds: 100), () {
                  context
                      .read<AuthLoginBloc>()
                      .add(const UpdateStatusEvent(FormLoginStatus.none));
                });
                break;
              case FormLoginStatus.needPassword:
                Navigator.pushNamed(context, Routes.changePassword).then(
                  (value) {
                    if (value != null) {
                      context.read<AuthLoginBloc>().add(LoginEvent());
                    }
                  },
                );
                break;
              case FormLoginStatus.needRegister:
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.formRegister, (_) => false,
                    arguments: {
                      'title': "Điền thông tin",
                      'description':
                          "Tạo tài khoản EXXE để nhận tất cả các tính năng",
                      'onConfirm': () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, Routes.home, (_) => false);
                      },
                    });
                break;
              case FormLoginStatus.needVerify:
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.verifyIdentityCard,
                  (_) => false,
                );
                break;
            }
          },
          child: const BodyLogin(),
        ),
      ),
    );
  }
}
