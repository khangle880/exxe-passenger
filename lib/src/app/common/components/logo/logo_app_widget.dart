import 'package:exxe/src/utils/export/ui_export.dart';

class LogoAppEXXE extends StatelessWidget {
  const LogoAppEXXE({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: AppStyles.border15,
            boxShadow: [
              BoxShadow(
                color: AppColors.gray70x76.withAlpha(50),
                blurRadius: 3.0,
              )
            ],
          ),
          child: const Image(
            image: AssetImage('assets/logo.png'),
            width: 25.0,
            height: 25.0,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 15.0),
        FittedBox(
          child: TextWidget(
            text: 'ExxeVN',
            fontSize: 24,
            weight: FontWeight.w600,
            colorText: AppColors.primaryTextButton,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
