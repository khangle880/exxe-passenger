import 'package:exxe/src/app/pages/login/components/form_login.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

class BodyLogin extends StatelessWidget {
  const BodyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Image.asset(
                    AppIcons.loginBanner,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: FormPhoneLogin(),
                ),
                const Spacer(),
                Center(
                  child: Text("Exxe - Ứng dụng đặt xe ô tô liên tỉnh",
                      style: AppStyles.s14w4.withColor(AppColors.primaryMain)),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
