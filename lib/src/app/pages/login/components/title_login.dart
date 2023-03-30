import '../../../../utils/export/ui_export.dart';

class TitleLogin extends StatelessWidget {
  const TitleLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          child: TextWidget(
            text: 'Xin chào!',
            fontSize: 28.0,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4.0),
        TextWidget(
          text: 'Vui lòng nhập số điện thoại để đăng nhập\nhoặc đăng ký ',
          maxLine: 2,
          fontSize: AppDimens.text14,
          colorText: AppColors.gray70x76,
          weight: FontWeight.w400,
        ),
      ],
    );
  }
}
