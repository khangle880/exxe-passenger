import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late final INewsControllerRepo repo;
  late PaginationHelper controller;

  @override
  void initState() {
    super.initState();
    repo = GetIt.I();
    initController();
  }

  void initController() {
    controller = PaginationHelper(
      limit: 20,
      asyncTask: (config) {
        return getNewsModels(config).then((data) {
          config.canLoadMore = data.length == 20;
          return (data);
        }).catchError((e) {
          log(e.toString());
          config.canLoadMore = false;
          throw e;
        });
      },
    );
    controller.run();
  }

  Future<List<NewsModel>> getNewsModels(PaginationConfig config) async {
    var result = await repo.getNewsPost(
      offset: config.offset,
    );
    return result.fold(
      (failure) {
        return Future.error(failure);
      },
      (data) {
        return data;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray05,
      appBar: CustomAppBarWidget(
        centerTitle: true,
        backgroundColor: AppColors.gray05,
        title: "Tin Tức",
        context: context,
      ),
      body: PaginationGridView(
        padding: const EdgeInsets.all(24),
        emptyBuilder: (_) => Center(
          child: Text('Chưa có tin mới', style: AppStyles.s16w6),
        ),
        loadingIndicatorBuilder: (_) => ItemNewsWidget.shimmer(),
        itemBuilder: (BuildContext context, int index) {
          final item = controller.items[index];
          return ItemNewsWidget(item);
        },
        paginationController: controller,
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        itemHeight: 250,
      ),
    );
  }
}
