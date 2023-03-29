import 'package:exxe/src/app/pages/news/controllers/news_cubit.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/base_state.dart';
import '../../../utils/export/ui_export.dart';

class NewsDetailPage extends StatefulWidget {
  const NewsDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsDetailPage> createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends BaseState<NewsDetailPage, NewsCubit> {
  @override
  late final NewsCubit bloc;

  @override
  void initState() {
    bloc = context.read<NewsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NewsState state = context.watch<NewsCubit>().state;

    return Scaffold(
      appBar: CustomAppBarWidget(
        centerTitle: true,
        backgroundColor: AppColors.gray05,
        title: "Tin Tức",
        context: context,
      ),
      backgroundColor: AppColors.gray05,
      body: SafeArea(
        child: SingleChildScrollView(
          child: state.newsDetail != null
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        state.newsDetail!.title!,
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
                        customRenders: {
                          tagMatcher("br"): CustomRender.widget(
                              widget: (context, buildChildren) =>
                                  const SizedBox(
                                    height: 22,
                                  )),
                        },
                        data: state.newsDetail!.content!,
                      )
                    ],
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
