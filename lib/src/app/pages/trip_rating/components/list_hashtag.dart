import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';

typedef HashtagOnClick = void Function(int);

class ListHashTag extends StatelessWidget {
  const ListHashTag(
      {Key? key,
      required this.onClick,
      required this.currentList,
      required this.hasTags})
      : super(key: key);
  final HashtagOnClick onClick;
  final List<int> currentList;
  final List<RatingHashtagModel> hasTags;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 10.0,
      runSpacing: 20.0,
      children: hasTags.map((item) => _buildHashTag(item)).toList(),
    );
    //   Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: HashtagModels.listHashtag1.map(
    //           (e) {
    //             return _buildHashTag(e);
    //           },
    //         ).toList()),
    //     const SizedBox(height: 10),
    //     Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: HashtagModels.listHashtag2.map(
    //           (e) {
    //             return _buildHashTag(e);
    //           },
    //         ).toList()),
    //     const SizedBox(height: 10),
    //     Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: HashtagModels.listHashtag3.map(
    //           (e) {
    //             return _buildHashTag(e);
    //           },
    //         ).toList()),
    //   ],
    // );
  }

  Widget _buildHashTag(RatingHashtagModel item) {
    final isActive = handelCheckItemHashTag(item.tagId!);
    return Container(
      key: ValueKey(item.tagId!.toString()),
      child: ChoiceChipWidget(
        backgroundColor: isActive ? AppColors.primaryButton : null,
        child: Text(
          item.tagContent!,
          style: AppStyles.s14w4.withColor(
              isActive ? AppColors.textLight : AppColors.primaryTextButton),
        ),
      ),
    ).inkWell(
      onTap: () => onClick(item.tagId!),
    );
  }

  bool handelCheckItemHashTag(int id) {
    for (int e in currentList) {
      if (e == id) {
        return true;
      }
    }
    return false;
  }
}
