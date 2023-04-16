import 'package:exxe/src/data/data.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../utils/export/ui_export.dart';

class PromotionDetailPage extends StatefulWidget {
  const PromotionDetailPage({
    Key? key,
    required this.promotionId,
    this.apply,
    this.canApply,
    this.currentPromoId,
  }) : super(key: key);

  final int promotionId;
  final int? currentPromoId;
  final bool? canApply;
  final Function()? apply;

  @override
  State<PromotionDetailPage> createState() => _PromotionDetailPageState();
}

class _PromotionDetailPageState extends State<PromotionDetailPage> {
  PromotionModel? promotionModel;

  @override
  void initState() {
    getPromotionDetail();
    super.initState();
  }

  void getPromotionDetail() async {
    var result =
        await GetIt.I<IPromotionRepo>().getPromotionDetail(widget.promotionId);
    result.fold(
      (failure) => log(failure.toString()),
      (data) {
        setState(() {
          promotionModel = data;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        centerTitle: true,
        backgroundColor: AppColors.gray05,
        title: "Chi tiết giảm giá",
        context: context,
      ),
      bottomNavigationBar: promotionModel == null || widget.apply == null
          ? null
          : ButtonWidget(
              onClick: widget.canApply ??
                      (promotionModel?.isPromotionApplied ?? false)
                  ? () {
                      widget.apply?.call();
                    }
                  : null,
              child: Text(
                (widget.currentPromoId == widget.promotionId)
                    ? "Bỏ chọn"
                    : "Áp dụng",
                style: AppStyles.s16w6.withColor(AppColors.primaryLight),
              ),
            ).bottomSingle(),
      backgroundColor: AppColors.gray05,
      body: SafeArea(
        child: SingleChildScrollView(
          child: promotionModel == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        '${promotionModel!.promotionCode} - ${promotionModel!.promotionName}',
                        style: AppStyles.s24w6.withColor(
                            AppColors.primaryTextButton +
                                AppColors.black.withOpacity(0.3)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Html(
                        style: {
                          'body': Style(
                            color: const Color(0xFF0c0055),
                            fontFamily: 'Montserrat,sans-serif',
                          ),
                          'div': Style(
                            margin: Margins.zero,
                            padding: EdgeInsets.zero,
                          ),
                          'a, abbr, acronym, address, applet, article, aside, audio, b, big, blockquote, body, button, canvas, caption, center, cite, code, dd, del, details, dfn, div, dl, dt, em, embed, fieldset, figcaption, figure, footer, form, h1, h2, h3, h4, h5, h6, header, hgroup, html, i, iframe, img, input, ins, kbd, label, legend, li, mark, menu, nav, object, ol, output, p, pre, q, ruby, s, samp, section, small, span, strike, strong, sub, summary, sup, table, tbody, td, textarea, tfoot, th, thead, time, tr, tt, u, ul, var, video':
                              Style(
                            margin: Margins.zero,
                            padding: EdgeInsets.zero,
                            lineHeight: LineHeight.number(1.2),
                          ),
                          'p': Style(
                            color: const Color(0xFF595959),
                          ),
                        },
                        data: promotionModel!.description!,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
