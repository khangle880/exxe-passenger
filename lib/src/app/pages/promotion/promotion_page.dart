import 'package:exxe/src/app/pages/promotion/controllers/promotion_cubit.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../core/base_state.dart';
import '../../../data/models/models.dart';
import 'components/promo_item.dart';

class PromotionPage extends StatefulWidget {
  final int carCustomerId;
  final PromotionModel? currentPromo;

  const PromotionPage({
    Key? key,
    required this.carCustomerId,
    this.currentPromo,
  }) : super(key: key);

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends BaseState<PromotionPage, PromotionCubit> {
  @override
  late final PromotionCubit bloc;

  @override
  void initState() {
    bloc = context.read<PromotionCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        backgroundColor: AppColors.greyLight,
        title: 'Mã Giảm Giá',
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            BlocConsumer<PromotionCubit, PromotionState>(
              listenWhen: (previous, current) =>
                  previous.carCustomer != current.carCustomer,
              listener: (context, state) {
                if (state.carCustomer != null) {
                  Navigator.pop(context, state.carCustomer);
                }
              },
              builder: (context, state) {
                return state.promotions == null
                    ? _buildShimmer()
                    : state.promotions!.isEmpty
                        ? const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Hiện tại bạn chưa có mã giảm giá nào!',
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemBuilder: (BuildContext context, int index) {
                                final item = state.promotions![index];
                                return PromoItem(
                                  onTap: () {
                                    bloc.applyPromotion(
                                      carCustomerId: widget.carCustomerId,
                                      promotionId: item.promotionId!,
                                      currentPromoId:
                                          widget.currentPromo?.promotionId!,
                                    );
                                  },
                                  promo: state.promotions![index],
                                  carCustomerId: widget.carCustomerId,
                                  currentPromo: widget.currentPromo,
                                ).inkWell(
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    Routes.promotionDetailPage,
                                    arguments: {
                                      'promotionId':
                                          state.promotions![index].promotionId,
                                      'canApply':
                                          item.isPromotionApplied ?? false,
                                      'currentPromoId':
                                          widget.currentPromo?.promotionId!,
                                      'apply': () {
                                        Navigator.pop(context);
                                        bloc.applyPromotion(
                                          carCustomerId: widget.carCustomerId,
                                          promotionId: item.promotionId!,
                                          currentPromoId:
                                              widget.currentPromo?.promotionId,
                                        );
                                      },
                                    },
                                  ),
                                );
                              },
                              itemCount: state.promotions!.length,
                            ),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildShimmer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 500.0,
      child: ListView.builder(
        itemBuilder: (_, __) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(10),
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
                        Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 20,
                              color: Colors.grey,
                            )),
                        const SizedBox(
                          height: 4,
                        ),
                        Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 150,
                              height: 20,
                              color: Colors.grey,
                            )),
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
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.grey,
                        )),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: 7,
      ),
    );
  }
}
