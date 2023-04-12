import 'package:exxe/src/utils/export/ui_export.dart';
import 'components/ride_list.dart';
import 'components/top_nav.dart';

class MyTripPage extends StatefulWidget {
  const MyTripPage({Key? key}) : super(key: key);

  @override
  State<MyTripPage> createState() => _MyTripPageState();
}

class _MyTripPageState extends State<MyTripPage> {
  late final PageController _pageController;
  int index = 0;
  final Map<CompoundingCarStateGroup, bool> isReverse = {
    CompoundingCarStateGroup.all: true,
    CompoundingCarStateGroup.draft: true,
    CompoundingCarStateGroup.processing: true,
    CompoundingCarStateGroup.inProcess: true,
    CompoundingCarStateGroup.confirmPaid: true,
    CompoundingCarStateGroup.cancel: true,
  };

  @override
  void initState() {
    _pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: CustomAppBarWidget(
        actions: [
          Builder(builder: (context) {
            final key = CompoundingCarStateGroup.values[index];
            final value = isReverse[key]!;
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text("Thời gian",
                      style: AppStyles.s15w6.withColor(AppColors.primaryDark)),
                  !value
                      ? SvgPicture.asset(
                          AppIcons.directionDown,
                          width: 24,
                          height: 24,
                          color: AppColors.primaryDark,
                        )
                      : SvgPicture.asset(
                          AppIcons.directionTop,
                          width: 24,
                          height: 24,
                          color: AppColors.primaryDark,
                        ),
                ],
              ),
            ).inkWell(
              onTap: () {
                setState(() {
                  isReverse[key] = !value;
                });
              },
            );
          }),
        ],
        centerTitle: false,
        autoGeneraIconLeading: false,
        title: 'Chuyến đi',
        fontSizeTitle: 24,
        context: context,
        backgroundColor:
            AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.95),
      ),
      body: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primaryMain +
                  AppColors.primaryLight.withOpacity(0.95),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                height: 28,
                child: ActivityTopNav(
                  groups: CompoundingCarStateGroup.values,
                  currentIndex: index,
                  onTap: (i) {
                    _pageController.jumpToPage(i);
                    index = i;
                    setState(() {});
                  },
                ),
              ),
              Expanded(flex: 1, child: _buildPages()),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPages() {
    return PageView(
      onPageChanged: (page) {
        index = page;
        setState(() {});
      },
      controller: _pageController,
      children: CompoundingCarStateGroup.values
          .map((e) => KeepAlivePage(
                child: RideListWidget(
                    reverse: isReverse[e]!,
                    group: e,
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16)),
              ))
          .toList(),
    );
  }
}
