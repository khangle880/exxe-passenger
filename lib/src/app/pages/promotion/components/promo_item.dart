import 'package:exxe/src/utils/export/logic_export.dart';

import '../../../../utils/export/ui_export.dart';

class PromoItem extends StatelessWidget {
  final PromotionModel promo;
  final PromotionModel? currentPromo;
  final int carCustomerId;
  final VoidCallback onTap;

  const PromoItem({
    Key? key,
    this.currentPromo,
    required this.promo,
    required this.carCustomerId,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCanApplied = (promo.isPromotionApplied ?? false);
    return ColorFiltered(
      colorFilter: isCanApplied
          ? const ColorFilter.mode(Colors.transparent, BlendMode.srcOver)
          : ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.srcOver),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(AppIcons.voucherBackground),
            ),
          ),
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight,
                flex: 114,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${promo.promotionName}',
                      style: AppStyles.s14w7.withColor(
                        AppColors.secondaryMain,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    promo.promotionBrief != null
                        ? Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: Text(
                              promo.promotionBrief!,
                              style: AppStyles.s12w4
                                  .withColor(AppColors.gray70x3b),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(AppIcons.voucherVerticalLine),
              ),
              Flexible(
                flex: 29,
                fit: FlexFit.tight,
                child: InkWell(
                  onTap: isCanApplied ? onTap : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Builder(builder: (context) {
                      final content =
                          (currentPromo?.promotionId == promo.promotionId)
                              ? "Bỏ chọn"
                              : "Áp dụng";
                      return Text(
                        content,
                        style: AppStyles.s14w7.withColor(
                          AppColors.secondaryMain,
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
