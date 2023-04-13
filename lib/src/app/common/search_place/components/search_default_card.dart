import '../../../../utils/export/ui_export.dart';

class SearchDefaultCard extends StatelessWidget {
  const SearchDefaultCard({
    Key? key,
    required this.title,
    required this.iconUrl,
    required this.subtitle,
    required this.callback,
  }) : super(key: key);

  final String title;
  final String iconUrl;
  final String subtitle;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconUrl,
          color: AppColors.primaryButton,
          width: 20,
          height: 20,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 16.0,
                  weight: FontWeight.w700,
                ),
                const SizedBox(height: 5),
                TextWidget(
                  text: subtitle,
                  fontSize: 14.0,
                  colorText: AppColors.gray70x76,
                  maxLine: 3,
                )
              ],
            ),
          ),
        )
      ],
    )
        .inkWell(
          onTap: callback,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: AppStyles.border15,
          ),
        )
        .margin(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
        );
  }
}
