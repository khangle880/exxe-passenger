import '../../../data/data.dart';
import '../../../utils/export/ui_export.dart';
import 'components/notificaiton_tabs.dart';
import 'components/notification_list.dart';
import 'components/vector.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({Key? key}) : super(key: key);

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  final repo = GetIt.I<INotificationRepo>();

  Map<NotificationTypeGroup, List<NotificationType>> get types =>
      NotificationType.allNotification.mapTypes;

  int currentIndex = 0;

  final PageController _pageController =
      PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: CustomAppBarWidget(
        title: 'Thông báo',
        context: context,
        actions: [
          VectorAppbar(
            repo: repo,
            context: context,
            icon: AppIcons.moreHorizontal,
            callBack: () {
              GetIt.I<AppState>().createAction(
                ActionStateEnum.deleteAllNoti,
                object: types.keys.toList()[currentIndex],
              );
            },
            callBackReadAllNotification: () {
              GetIt.I<AppState>().createAction(
                ActionStateEnum.readAllNoti,
                object: types.keys.toList()[currentIndex],
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            height: 28,
            child: NotificationTabs(
              groupTypes: types,
              initialIndex: 0,
              onTap: (i) {
                _pageController.jumpToPage(i);
              },
            ),
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                currentIndex = value;
              },
              controller: _pageController,
              children: types.entries
                  .map(
                    (e) => KeepAlivePage(
                      child: NotificationListWidget(
                        groupTypes: e,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
