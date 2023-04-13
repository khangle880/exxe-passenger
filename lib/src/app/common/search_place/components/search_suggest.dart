import '../../../../data/data.dart';
import '../../../../utils/export/ui_export.dart';

class SearchSuggest extends StatelessWidget {
  const SearchSuggest({
    Key? key,
    required this.index,
    required this.suggestivePlaces,
    required this.title,
    required this.subtitle,
    required this.callback,
  }) : super(key: key);
  final int index;
  final List<SuggestivePlaceModel> suggestivePlaces;
  final String title;
  final String subtitle;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppIcons.locationPurple,
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
    ).inkWell(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: index == suggestivePlaces.length - 1
                ? const Radius.circular(15)
                : Radius.zero,
            bottomRight: index == suggestivePlaces.length - 1
                ? const Radius.circular(15)
                : Radius.zero,
          )),
      onTap: callback,
    );
  }
}
