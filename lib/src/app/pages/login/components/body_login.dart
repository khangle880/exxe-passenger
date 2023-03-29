import 'package:exxe/src/app/pages/login/components/form_login.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

// ignore: must_be_immutable
class BodyLogin extends StatelessWidget {
  const BodyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: SvgPicture.asset(
                  AppIcons.loginBannerSvg,
                  fit: BoxFit.fill,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
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
    );
  }
}
