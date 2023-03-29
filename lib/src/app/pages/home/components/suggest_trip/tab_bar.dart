import 'package:exxe/src/utils/export/ui_export.dart';

enum SuggestType {
  all,
  compounding,
  convenient,
}

extension SuggestTypeExt on SuggestType {
  String get name {
    switch (this) {
      case SuggestType.all:
        return "Tất cả";
      case SuggestType.compounding:
        return "Ghép chuyến";
      case SuggestType.convenient:
        return "Tiện chuyến";
    }
  }
}

class TabBarSuggestTrip extends StatelessWidget {
  const TabBarSuggestTrip(
      {Key? key, required this.currentType, required this.onClick})
      : super(key: key);
  final SuggestType currentType;
  final Function(SuggestType type) onClick;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: SuggestType.values.map((e) {
          return SuggestTripTab(
            type: e,
            isSelected: currentType == e,
            onClick: (type) {
              onClick(type);
            },
          );
        }).toList(),
      ),
    );
  }
}

class SuggestTripTab extends StatelessWidget {
  const SuggestTripTab(
      {Key? key,
      required this.type,
      required this.isSelected,
      required this.onClick})
      : super(key: key);
  final SuggestType type;
  final bool isSelected;
  final Function(SuggestType type) onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 24),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          TextWidget(
            text: type.name,
            fontSize: AppDimens.text14,
            colorText: isSelected ? AppColors.gray70x76 : AppColors.primaryDark,
          ),
          Positioned(
            bottom: -3.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: AppStyles.border15,
              ),
              width: MediaQuery.of(context).size.width * .05,
              height: isSelected ? 4.0 : 0.0,
            ),
          )
        ],
      )
          .padding(
            padding:
                const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 24.0),
          )
          .inkWell(onTap: () => onClick(type)),
    );
  }
}
