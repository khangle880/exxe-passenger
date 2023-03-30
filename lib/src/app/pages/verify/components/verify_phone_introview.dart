import 'package:introduction_screen/introduction_screen.dart';

import '../../../../utils/export/ui_export.dart';

class VerifyPhoneIntroView extends StatefulWidget {
  const VerifyPhoneIntroView({Key? key}) : super(key: key);

  @override
  State<VerifyPhoneIntroView> createState() => _VerifyPhoneIntroViewState();
}

class _VerifyPhoneIntroViewState extends State<VerifyPhoneIntroView> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Xác minh SĐT chính chủ",
        context: context,
        autoGeneraIconLeading: false,
      ),
      body: IntroductionScreen(
        globalHeader: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Text(
            "Hướng dẫn xác minh số điện thoại chính chủ qua tin nhắn, thông tin của bạn sẽ được bảo đảm an toàn theo qui định của pháp luật.",
            textAlign: TextAlign.center,
            style: AppStyles.s14w6.withColor(AppColors.gray60),
          ),
        ),
        globalBackgroundColor: AppColors.white,
        key: _introKey,
        pages: [
          _buildPage(AppIcons.phoneStep1),
          _buildPage(AppIcons.phoneStep2),
          _buildPage(AppIcons.phoneStep3),
        ],
        showSkipButton: false,
        showNextButton: true,
        showDoneButton: true,
        globalFooter: ButtonWidget(
          onClick: () {
            Navigator.pop(context);
          },
          child: Text(
            "Đóng",
            style: AppStyles.s16w6.withColor(AppColors.primaryLight),
          ),
        ).bottomSingle(),
        done: Text("Xong",
            style: AppStyles.s16w6.withColor(AppColors.primaryMain)),
        next: Text(
          "Tiếp theo",
          style: AppStyles.s16w6.withColor(AppColors.primaryMain),
        ),
        onDone: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _buildPage(String image) {
    return PageViewModel(
      titleWidget: const SizedBox(),
      bodyWidget: const SizedBox(),
      decoration: const PageDecoration(fullScreen: true),
      image: Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, top: 100, bottom: 130),
        child: Image.asset(
          image,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
