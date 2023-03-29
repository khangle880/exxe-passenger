import '../../../../data_chat/data_chat.dart';
import '../../../../utils/export/ui_export.dart';
import 'room_item.dart';

class BodyChatHome extends StatefulWidget {
  const BodyChatHome({Key? key}) : super(key: key);

  @override
  State<BodyChatHome> createState() => _BodyChatHomeState();
}

class _BodyChatHomeState extends State<BodyChatHome> {
  final ChatSocketHelper chatSocketHelper = ChatSocketHelper.I;
  late RemoveListener removeListener;

  PaginationHelper<ChatRoomModel> get controller =>
      ChatSocketHelper.I.controller;

  @override
  void initState() {
    // listen app state
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction &&
          state.action == ActionStateEnum.updateChatUserInfo) {
        if (mounted) {
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ChatSocketHelper.I.user == null) {
      return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Text(
          "Không thể kết nối với dữ liệu tin nhắn.\nVui lòng đăng nhập lại.",
          textAlign: TextAlign.center,
          style: AppStyles.s14w6.withColor(AppColors.utilRed),
        ),
      );
    }
    return StreamBuilder<bool>(
        stream: ChatSocketHelper.I.connectSocket.stream,
        builder: (context, snapshot) {
          if (snapshot.data == false) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "Mất kết nối",
                style: AppStyles.s14w6.withColor(AppColors.utilRed),
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: PaginationListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  emptyBuilder: (_) => Center(
                    child: Text('Không có tin nhắn gần đây',
                        style: AppStyles.s16w6),
                  ),
                  loadingEffectItemBuilder: (_, index) =>
                      RoomItemWidget.shimmer(),
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return RoomItemWidget(
                      room: item,
                      user: chatSocketHelper.user!,
                      onTap: () {
                        if (item.roomType != RoomType.group) {
                          Navigator.pushNamed(
                            context,
                            Routes.chatRoom,
                            arguments: item,
                          ).then((value) {
                            if (value is ChatRoomModel) {
                              controller.items[index] = value;
                              controller.callListeners();
                            }
                          });
                        }
                      },
                    );
                  },
                  paginationController: controller,
                ),
              ),
            ],
          );
        });
  }
}
