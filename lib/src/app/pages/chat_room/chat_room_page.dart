import '../../../data_chat/data_chat.dart';
import '../../../utils/export/ui_export.dart';
import '../../common/widgets/widgets.dart';
import 'components/bottom_bar.dart';
import 'components/chat_item.dart';
import 'controllers/chat_room_cubit.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage(this.cubit, {Key? key}) : super(key: key);
  final ChatRoomCubit cubit;

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  ChatRoomCubit get cubit => widget.cubit;

  @override
  void dispose() {
    super.dispose();
    cubit.dispose();
  }

  onPop() {
    cubit.leaveRoom();
    cubit.room.messages = Messages(
      data: cubit.controller.items,
      hasMore: cubit.controller.canLoadMore,
      limit: cubit.controller.limit,
      offset: cubit.controller.config.offset,
    );
    if (cubit.textStream.valueOrNull != null &&
        cubit.textStream.value.isNotEmpty) {
      final message = ChatMessageModel(
        messageText: cubit.textStream.value,
        isAuthor: true,
        author: cubit.user.toAuthorModel,
        sendType: SendMessageType.typing,
      );
      cubit.controller.items.insert(
        0,
        message,
      );
    }
    Navigator.pop(context, cubit.room);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocConsumer<ChatRoomCubit, ChatRoomState>(
        listener: (context, state) {
          if (state is RoomNotExist) {
            AppDialog.I.showWarning(
              message: "Đoạn hội thoại không còn tồn tại!",
              barrierDismissible: false,
            );
          }
        },
        builder: (_, state) {
          if (cubit.partner == null) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () {
                AppDialog.I.showWarning(
                  message: "Cuộc trò chuyện không còn tồn tại",
                  onConfirm: () {
                    AppDialog.I.closeDialog();
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  barrierDismissible: false,
                );
              },
            );
            return const Scaffold();
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: Navigator.canPop(context)
                    ? Container(
                        margin: const EdgeInsets.only(left: 16),
                        child: SvgPicture.asset(
                          AppIcons.chevronLeft,
                          color: AppColors.black,
                        ).inkWell(
                          onTap: () {
                            onPop();
                          },
                        ),
                      )
                    : null,
                titleSpacing: 0.0,
                title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: _buildHeader()),
                elevation: .5,
                backgroundColor: AppColors.gray10,
                actions: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          GetIt.I<LocationHelper>().handleLocation(
                            context,
                            callBack: () {
                              cubit.createMessage(sendLocation: true);
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            AppIcons.locationPurple,
                            height: 24,
                            width: 24,
                            color: AppColors.primaryMain,
                          ),
                        ),
                      ),
                      if (cubit.partner?.phone != null &&
                          cubit.room.dependId != null)
                        InviteVoiceButton(
                          phone: cubit.partner!.phone.toString(),
                          name: cubit.partner!.userName ?? '',
                          compoundingCarCustomerCode: cubit.room.dependId!,
                        ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
              backgroundColor: AppColors.gray10,
              body: WillPopScope(
                onWillPop: () async {
                  onPop();
                  return false;
                },
                child: StreamBuilder<bool>(
                    stream: ChatSocketHelper.I.connectSocket.stream,
                    builder: (context, snapshot) {
                      if (snapshot.data == false) {
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            "Mất kết nối",
                            style: AppStyles.s14w6.withColor(AppColors.utilRed),
                          ),
                        );
                      }
                      return PaginationListView(
                        enableRefresh: false,
                        reverse: true,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        emptyBuilder: (_) => Center(
                          child: Text('Bắt đầu cuộc trò chuyện nào',
                              style: AppStyles.s16w6),
                        ),
                        loadingEffectItemCount: 20,
                        loadingEffectItemBuilder: (_, index) =>
                            MessageShimmer(index: index),
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final items = cubit.controller.items;
                          final item = items[index];
                          return ChatMessageItem(
                            item,
                            nearer: index == 0 ? null : items[index - 1],
                            old: index == items.length - 1
                                ? null
                                : items[index + 1],
                            cubit: cubit,
                          );
                        },
                        paginationController: cubit.controller,
                      );
                    }),
              ),
              resizeToAvoidBottomInset: false,
              bottomNavigationBar: const RoomBottomBar(),
            );
          }
        },
      ),
    );
  }

  _buildHeader() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Stack(
            children: [
              CustomNetworkImage(
                host: Apis.baseUrl,
                url: (cubit.room.roomAvatar ?? "").isNotEmpty
                    ? cubit.room.roomAvatar
                    : cubit.partner!.avatar,
                size: 48,
                errorImage: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SvgPicture.asset(AppIcons.user),
                ),
                decoration: const BoxDecoration(
                    color: AppColors.gray20, shape: BoxShape.circle),
              ),
              if (cubit.partner!.isOnline!)
                Positioned(
                  right: 4,
                  bottom: 4,
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
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cubit.partner!.userName ?? "", style: AppStyles.s18w7),
                if (cubit.room.dependId != null)
                  Text(
                    "Chuyến đi #${cubit.room.dependId}",
                    style: AppStyles.s14w4.copyWith(color: AppColors.gray70x76),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageShimmer extends StatelessWidget {
  const MessageShimmer({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: index < 6
          ? const EdgeInsets.only(left: 24)
          : const EdgeInsets.only(right: 24),
      alignment: index < 6 ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              ShimmerUtils.buildShimmerWithText(AppStyles.s14w4,
                  text: "message content ne"),
              const SizedBox(height: 4),
              ShimmerUtils.buildShimmerWithText(AppStyles.s10w4, text: "HH:mm"),
            ],
          ),
        ],
      ),
    );
  }
}
