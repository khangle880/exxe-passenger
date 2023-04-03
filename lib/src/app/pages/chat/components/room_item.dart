import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

import '../../../../data_chat/data_chat.dart';
import '../../../../utils/export/ui_export.dart';

class RoomItemWidget extends StatelessWidget {
  RoomItemWidget(
      {Key? key, required this.room, required this.user, required this.onTap})
      : super(key: key);
  final ChatRoomModel room;
  final ChatUserModel user;
  final Function() onTap;

  static shimmer() {
    return const RoomItemWidgetShimmer();
  }

  LastMessageModel? get lastMessage =>
      room.messages?.data?.firstOrNull?.toLastMessageModel ?? room.lastMessage;

  String _getContent() {
    return lastMessage == null
        ? "Sẵn sàng bắt đầu cuộc trò chuyện"
        : "${lastMessage!.isAuthor ?? false ? "Bạn" : lastMessage!.authorName!.toString()}: ${lastMessage!.messageText ?? ""}";
  }

  final CustomPopupMenuController _controller = CustomPopupMenuController();

  PaginationHelper<ChatRoomModel> get controller =>
      ChatSocketHelper.I.controller;

  @override
  Widget build(BuildContext context) {
    if (room.roomType == RoomType.admin) {
      return _buildContent();
    }
    return CustomPopupMenu(
      controller: _controller,
      position: PreferredPosition.bottom,
      menuBuilder: () {
        return _buildLongPressMenu(room);
      },
      barrierColor: Colors.black54,
      pressType: PressType.longPress,
      verticalMargin: 0,
      child: _buildContent(),
    );
  }

  _buildContent() {
    ChatUserModel? partner;
    partner = room.getOtherMembers(user.userId).firstOrNull;
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              AnimatedContainer(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: room.isOnline!
                          ? AppColors.primaryLight.withOpacity(0.6) +
                              AppColors.primaryMain
                          : AppColors.gray30),
                  borderRadius: BorderRadius.circular(30),
                ),
                duration: const Duration(milliseconds: 300),
                child: CustomNetworkImage(
                  host: Apis.baseUrl,
                  url: partner?.avatar ?? room.roomAvatar,
                  size: 50,
                  errorImage: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SvgPicture.asset(AppIcons.user),
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.gray20,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (room.isOnline!)
                Positioned(
                  right: 4,
                  bottom: 6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF22DF64),
                    ),
                  ),
                )
            ],
          ),
          // Assets.icons.png.adminChatAvatar.svg(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          partner?.userName ?? room.roomName ?? "",
                          style: AppStyles.s16w7,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lastMessage?.createdAt?.toFormat('HH:mm') ?? '',
                        style: AppStyles.s12w4.withColor(AppColors.gray70x76),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _getContent(),
                          style: AppStyles.s14w6.withColor(
                              (room.messageUnreadCount ?? 0) <= 0
                                  ? AppColors.gray70x76
                                  : AppColors.primaryMain),
                          overflow: TextOverflow.ellipsis,
                          maxLines: room.roomType == RoomType.group ? 1 : 2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 36,
                        height: 20,
                        child: Center(
                          child: _buildMessageStatus(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (room.roomType == RoomType.group)
                    Row(
                      children: (room.topMembers?.where(
                                  (element) => element.userId != user.userId) ??
                              [])
                          .map(
                            (user) => CustomNetworkImage(
                              host: Apis.baseUrl,
                              url: user.avatar,
                              size: 20,
                              decoration: BoxDecoration(
                                color: AppColors.gray10,
                                border: Border.all(
                                  color: AppColors.primaryMain +
                                      AppColors.primaryLight.withOpacity(.8),
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLongPressMenu(ChatRoomModel item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 200,
        color: const Color(0xFF4C4C4C),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuItemModel(
              "Xóa",
              Icons.delete,
              () {
                GetIt.I<IChatRoomRepo>()
                    .deleteRoom(item.roomId!)
                    .then((either) {
                  either.fold((failure) {
                    log(failure.toString());
                  }, (data) {
                    controller.items.removeWhere(
                        (element) => element.roomId == item.roomId);
                    controller.callListeners();
                  });
                });
              },
            )
          ]
              .map(
                (item) => InkWell(
                  onTap: () {
                    _controller.hideMenu();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      item.onTap();
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 20,
                        color: Colors.white,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: Text(
                          item.title,
                          style:
                              AppStyles.s12w4.withColor(AppColors.primaryLight),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildMessageStatus() {
    final sendType = lastMessage?.sendType;
    if (sendType == null) return const SizedBox();
    if (sendType == SendMessageType.typing) {
      return FittedBox(
        child: Text("Chưa gửi",
            style: AppStyles.s10w4.withColor(AppColors.orangeMain)),
      );
    } else if (sendType == SendMessageType.sending) {
      return FittedBox(
        child: Text("Đang gửi",
            style: AppStyles.s10w4.withColor(AppColors.primaryMain)),
      );
    } else if (sendType == SendMessageType.rejected) {
      return SvgPicture.asset(
        AppIcons.warning,
        height: 16,
        width: 16,
        color: AppColors.orangeMain,
      );
    } else if ((room.messageUnreadCount ?? 0) == 0) {
      return SvgPicture.asset(
        AppIcons.checkCircle,
        height: 16,
        width: 16,
        color: AppColors.gray50,
      );
    }
    return Container(
      height: 16,
      width: 16,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.utilRed,
      ),
      alignment: Alignment.center,
      child: Text(
        room.messageUnreadCount!.toString(),
        style: AppStyles.s10w5.withColor(AppColors.primaryLight),
      ),
    );
  }
}

class MenuItemModel {
  String title;
  IconData icon;
  Function() onTap;

  MenuItemModel(
    this.title,
    this.icon,
    this.onTap,
  );
}

class RoomItemWidgetShimmer extends StatelessWidget {
  const RoomItemWidgetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            ShimmerUtils.buildShimmer(
                child: Container(
              decoration: const BoxDecoration(
                color: AppColors.gray20,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                AppIcons.user,
                width: 60,
                height: 60,
              ),
            ))
          ],
        ),
        // Assets.icons.png.adminChatAvatar.svg(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: ShimmerUtils.buildShimmerWithText(
                            AppStyles.s16w7,
                            text: "nguyen van a")),
                    const SizedBox(width: 8),
                    ShimmerUtils.buildShimmerWithText(AppStyles.s12w4,
                        text: "HH:mm am")
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerUtils.buildShimmerWithText(AppStyles.s14w6,
                        text: "bạn: tin nhan"),
                    const SizedBox(width: 4),
                    ShimmerUtils.buildShimmer(
                        child: const Icon(
                      Icons.circle,
                      size: 24,
                    ))
                  ],
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
