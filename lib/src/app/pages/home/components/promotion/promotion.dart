import 'package:exxe/src/app/pages/home/components/promotion/list_promotion.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../../data/data.dart';

class PromotionHome extends StatefulWidget {
  const PromotionHome({Key? key}) : super(key: key);

  @override
  State<PromotionHome> createState() => _PromotionHomeState();
}

class _PromotionHomeState extends State<PromotionHome> {
  late final IPromotionRepo repo;
  List<PromotionModel>? promotions;

  @override
  void initState() {
    super.initState();
    repo = GetIt.I();
    getListSpecialPromotion();
  }

  getListSpecialPromotion() async {
    var result = await repo.getListPromotionCanApply();
    result.fold((failure) => log('failed $failure'), (data) {
      promotions = data;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (promotions == null || promotions!.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: "Khuyến mãi",
                fontSize: 18.0,
                weight: FontWeight.w700,
              ),
              ButtonMore(
                onTap: () {
                  Navigator.pushNamed(context, Routes.promotionHomePage);
                },
              )
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: ListPromotionHome(
            promotions: promotions!,
          ),
        ),
      ],
    );
  }
}
