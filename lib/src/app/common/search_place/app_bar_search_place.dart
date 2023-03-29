import 'package:exxe/src/utils/export/ui_export.dart';

class AppbarSearchPlace extends StatelessWidget {
  const AppbarSearchPlace({
    Key? key,
    required this.searchType,
  }) : super(key: key);
  final SearchType searchType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      height: 90,
      decoration: BoxDecoration(
        color: AppColors.greyLight,
        borderRadius: AppStyles.borderBottom30LeftRight,
      ),
      alignment: Alignment.bottomCenter,
      child: ListTile(
        horizontalTitleGap: 30.0,
        leading: const IconArrowBackCircle(),
        title: TextWidget(
          text: searchType.name,
          fontSize: AppDimens.text18,
          weight: FontWeight.w700,
        ),
      ),
    );
  }
}
