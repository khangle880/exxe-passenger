import 'package:exxe/src/controllers/token/token_cubit.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<TokenCubit, TokenState>(
        listener: (context, state) async {
          if (state is TokenHas) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.home,
              (_) => false,
            );
          } else if (state is TokenNeedPassword) {
            handle(BuildContext context) async {
              AppDialog.I.showLoading();
              await context.read<TokenCubit>().checkToken().then((_) {
                AppDialog.I.showLoading();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.formRegister, (_) => false,
                    arguments: {
                      'title': "Điền thông tin",
                      'description':
                          "Tạo tài khoản EXXE để nhận tất cả các tính năng",
                    });
              });
            }

            Navigator.pushReplacementNamed(context, Routes.changePassword,
                arguments: {
                  'onChanged': handle,
                });
          } else if (state is TokenNeedRegister) {
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.formRegister, (_) => false,
                arguments: {
                  'title': "Điền thông tin",
                  'description':
                      "Tạo tài khoản EXXE để nhận tất cả các tính năng",
                });
          } else if (state is TokenNeedVerifyAccount) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.verifyIdentityCard,
              (_) => false,
            );
          } else if (state is TokenInvalid) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (_) => false,
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Image.asset(
              AppIcons.logoBig,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
