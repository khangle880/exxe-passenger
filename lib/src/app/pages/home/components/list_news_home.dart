import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/data.dart';

class ListNews extends StatefulWidget {
  const ListNews({Key? key}) : super(key: key);

  @override
  State<ListNews> createState() => _ListNewsState();
}

class _ListNewsState extends State<ListNews> {
  late ScrollController _scrollController;
  late final INewsControllerRepo repo;
  List<NewsModel>? newsModels;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {});
    repo = GetIt.I();
    repo.getNewsPost().then((value) {
      value.fold((l) {
        log(l.toString());
        newsModels = [];
      }, (data) {
        newsModels = data;
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (newsModels == null) {
      return Padding(
        padding: const EdgeInsets.all(48),
        child: const SizedBox().appCenterProgressLoading,
      );
    }
    if (newsModels!.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 20.0, top: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: "Tin tức",
                fontSize: 18.0,
                weight: FontWeight.w700,
              ),
              ButtonMore(
                onTap: () {
                  Navigator.pushNamed(context, Routes.news);
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 548,
          child: GridView.builder(
            controller: _scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (250 / 163),
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
            ),
            itemCount: newsModels!.length,
            itemBuilder: (context, index) {
              return ItemNewsWidget(newsModels![index]);
            },
          ),
        ),
      ],
    );
  }
}
