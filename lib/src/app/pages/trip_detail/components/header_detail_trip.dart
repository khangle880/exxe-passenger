import 'package:exxe/src/utils/export/ui_export.dart';

class HeaderDetailTrip extends StatelessWidget {
  const HeaderDetailTrip(
      {super.key,
      required this.status,
      required this.title,
      required this.code});

  final bool status;
  final String title;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          status
              ? SvgPicture.asset(
                  AppIcons.checkCircle,
                  color: AppColors.accGreenMain,
                  width: 80,
                  height: 80,
                )
              : SvgPicture.asset(
                  AppIcons.warning,
                  color: AppColors.accRedMain,
                  width: 80,
                  height: 80,
                ),
          const SizedBox(
            height: 32,
          ),
          TextWidget(
            text: title,
            weight: AppStyles.fontWeightW700,
            colorText: AppColors.primaryDark,
            fontSize: AppDimens.text16,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            code,
            style: AppStyles.s16w6.withColor(AppColors.gray70x3b),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
