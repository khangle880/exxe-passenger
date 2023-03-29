import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../../data/data.dart';

class PromotionHomePage extends StatefulWidget {
  const PromotionHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<PromotionHomePage> createState() => _PromotionHomePageState();
}

class _PromotionHomePageState extends State<PromotionHomePage> {
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
    return Scaffold(
      backgroundColor: AppColors.gray05,
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.gray05,
        title: 'Mã giảm giá',
        context: context,
      ),
      body: promotions == null
          ? _buildShimmer()
          : promotions!.isEmpty
              ? const Text("Hiện tại chưa có mã khuyến mãi")
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: promotions?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          left: 24, right: 24, top: 5.0, bottom: 5.0),
                      child: ItemVoucherWidget(
                        promotionModel: promotions![index],
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                        maxHeight: MediaQuery.of(context).size.width * .2,
                      ),
                    );
                  },
                ),
    );
  }

  _buildShimmer() {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ListView.builder(
        itemBuilder: (_, __) {
          return Container(
            width: size.width,
            height: size.width * .2,
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              border: Border.all(color: Colors.orange, width: 1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                Flexible(
                    flex: 29,
                    fit: FlexFit.tight,
                    child: ShimmerUtils.buildShimmer(
                      child: SvgPicture.asset(AppIcons.ticket),
                    )),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    AppIcons.voucherVerticalLine,
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 114,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerUtils.buildShimmerWithText(AppStyles.s14w6,
                          text: "khuyen mai 50k cho ban"),
                      const SizedBox(
                        height: 4,
                      ),
                      ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                          text: "don hang tren 100k duoc khuyen mai"),
                      ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                          text: "don hang tren 100k duoc khuyen mai"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: 7,
      ),
    );
  }
}
