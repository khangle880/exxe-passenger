import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../../data/data.dart';

class ListPromotionHome extends StatelessWidget {
  final List<PromotionModel> promotions;

  const ListPromotionHome({
    Key? key,
    required this.promotions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(
              left: index != 0 ? 20 : 24,
              right: index == 4 ? 20.0 : 0.0,
              top: 5.0,
              bottom: 5.0),
          child: ItemVoucherWidget(
            promotionModel: promotions[index],
            maxWidth: 200,
            maxHeight: 80,
          ),
        );
      },
    );
  }
}
