import 'package:exxe/src/utils/export/ui_export.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// ignore: must_be_immutable
class ListStarRatingWidget extends StatelessWidget {
  const ListStarRatingWidget({
    Key? key,
    this.onRatingUpdate,
    required this.currentStar,
    required this.size,
    required this.itemPadding,
    this.ignoreGestures,
    this.allowHalfRating,
  }) : super(key: key);
  final double currentStar;
  final Function(double)? onRatingUpdate;
  final EdgeInsets itemPadding;
  final double size;
  final bool? ignoreGestures;
  final bool? allowHalfRating;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      itemBuilder: (context, _) => SvgPicture.asset(
        AppIcons.star,
        color: AppColors.marigoldd40,
      ),
      onRatingUpdate: onRatingUpdate ??
          (rating) {
            return;
          },
      itemCount: 5,
      minRating: 1,
      itemSize: size,
      itemPadding: itemPadding,
      initialRating: currentStar,
      unratedColor: Colors.amber.withAlpha(50),
      direction: Axis.horizontal,
      allowHalfRating: allowHalfRating ?? true,
      ignoreGestures: ignoreGestures ?? true,
    );
  }
}
