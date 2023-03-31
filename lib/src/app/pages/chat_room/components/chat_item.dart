import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import '../../../../data_chat/data_chat.dart';
import '../../../../utils/export/ui_export.dart';
import '../controllers/chat_room_cubit.dart';
import 'attachment_item.dart';
import 'chat_content.dart';
import 'map_image_thumnail.dart';

class ChatMessageItem extends StatefulWidget {
  const ChatMessageItem(this.item,
      {Key? key, required this.cubit, this.nearer, this.old})
      : super(key: key);
  final ChatRoomCubit cubit;
  final ChatMessageModel item;
  final ChatMessageModel? nearer;
  final ChatMessageModel? old;

  @override
  State<ChatMessageItem> createState() => _ChatMessageItemState();
}

class _ChatMessageItemState extends State<ChatMessageItem> {
  late final List<MenuItemModel> options;
  final CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    super.initState();
    options = [
      MenuItemModel(
        "Phản hồi",
        AppIcons.replyRectangle,
        () {
          widget.cubit.replyStream.add(widget.item.toReplyToModel);
        },
      ),
      // TODO: confirm this option
      // MenuItemModel(
      //   "Lưu nháp",
      //   Assets.icons.svg.note,
      //   () {},
      // ),
      // MenuItemModel(
      //   "Xóa",
      //   Assets.icons.svg.trash,
      //   () {
      //   },
      // )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isAuthor = widget.item.isAuthor ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isAuthor ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _buildSeparate(),
        Container(
          padding: isAuthor
              ? const EdgeInsets.only(left: 24)
              : const EdgeInsets.only(right: 24),
          alignment: isAuthor ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAuthor && widget.item.sendType == SendMessageType.rejected)
                const Icon(Icons.refresh, size: 20, color: AppColors.utilRed)
                    .inkWell(
                  onTap: () {
                    widget.item.sendType = SendMessageType.sending;
                    setState(() {});
                    widget.item.sendMessage?.call();
                  },
                ),
              const SizedBox(width: 4),
              CustomPopupMenu(
                controller: _controller,
                position: PreferredPosition.bottom,
                menuBuilder: () {
                  return _buildLongPressMenu();
                },
                barrierColor: AppColors.black.withOpacity(.8),
                pressType: PressType.longPress,
                arrowColor: AppColors.primaryLight,
                verticalMargin: 0,
                child: Column(
                  children: [
                    if (widget.item.location != null) _buildMapThumbnail(),
                    if ((widget.item.messageText ?? "").isNotEmpty)
                      _buildContent(),
                    if ((widget.item.attachments ?? []).isNotEmpty) ...[
                      if ((widget.item.messageText ?? "").isNotEmpty)
                        const SizedBox(height: 4),
                      _buildAttachment(),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.nearer == null && (widget.item.isAuthor ?? false)) ...[
          const SizedBox(height: 4),
          widget.item.sendType == SendMessageType.rejected
              ? const SizedBox()
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.black.withOpacity(.25),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: (widget.item.isRead ?? false)
                      ? _buildSendStatus(AppIcons.doubleCheck, "Đã nhận")
                      : widget.item.sendType == SendMessageType.sent
                          ? _buildSendStatus(AppIcons.check, "Đã gửi")
                          : _buildSendStatus(AppIcons.clockCircle, "Đang gửi"),
                ),
        ]
      ],
    );
  }

  _buildSendStatus(String icon, String title) {
    return SizedBox(
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            height: 12,
            width: 12,
            color: AppColors.primaryLight,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: AppStyles.s10w4.withColor(AppColors.primaryLight),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 54,
        color: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            options.length,
            (index) {
              final item = options[index];
              return Padding(
                padding:
                    EdgeInsets.only(right: index < options.length - 1 ? 12 : 0),
                child: InkWell(
                  onTap: () {
                    _controller.hideMenu();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      item.onTap();
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(6.0),
                        child: SvgPicture.asset(item.icon,
                            height: 20,
                            width: 20,
                            color: (item.title == "Xóa")
                                ? AppColors.gray70x76
                                : AppColors.primaryMain),
                      ),
                      Text(
                        item.title,
                        style: AppStyles.s10w4.withColor(AppColors.gray70x76),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _buildAttachment() {
    final maxWidth = MediaQuery.of(context).size.width * 0.65 -
        (widget.item.sendType == SendMessageType.rejected ? 20 : 0);
    final attachment = widget.item.attachments!;
    final size = attachment.length > 1 ? (maxWidth - 50) / 2 : maxWidth;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: maxWidth,
          child: Wrap(
            alignment: widget.item.isAuthor ?? false
                ? WrapAlignment.end
                : WrapAlignment.start,
            runSpacing: 4,
            spacing: 4,
            children: attachment.map((e) {
              return AttachmentItem(attachment: e, maxWidth: size);
            }).toList(),
          ),
        ),
        // build time
        if (widget.nearer == null ||
            widget.nearer!.author?.authorId != widget.item.author?.authorId ||
            widget.nearer!.createdAt!.difference(widget.item.createdAt!) >
                const Duration(hours: 1)) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(widget.item.createdAt!.toFormat('HH:mm'),
                style: AppStyles.s10w4.withColor(AppColors.white)),
          ),
        ],
      ],
    );
  }

  _buildContent() {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: BoxConstraints(maxWidth: size.width * 0.8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.item.isAuthor ?? false
            ? AppColors.primaryMain + AppColors.primaryLight.withOpacity(.8)
            : AppColors.primaryLight,
      ),
      child: ChatContent(
        cubit: widget.cubit,
        item: widget.item,
        old: widget.old,
        nearer: widget.nearer,
      ),
    );
  }

  _buildSeparate() {
    if (widget.old != null &&
        widget.item.createdAt!.difference(widget.old!.createdAt!) >
            const Duration(hours: 1)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16, top: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(widget.item.createdAt!.toFormat('HH:mm, dd/MM/yyyy'),
                style: AppStyles.s10w4.withColor(AppColors.white)),
          ),
        ],
      );
    } else if (widget.old?.author?.authorId != widget.item.author?.authorId) {
      return const SizedBox(height: 16);
    } else {
      return const SizedBox();
    }
  }

  _buildMapThumbnail() {
    final maxWidth = MediaQuery.of(context).size.width -
        60 -
        (widget.item.sendType == SendMessageType.rejected ? 20 : 0);
    final location = widget.item.location!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: maxWidth * .8,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.primaryMain +
                  AppColors.primaryLight.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: MapImageThumbnail(
            lat: location.lat!,
            long: location.lng!,
          ),
        ),
        // build time
        if (widget.nearer == null ||
            widget.nearer!.author?.authorId != widget.item.author?.authorId ||
            widget.nearer!.createdAt!.difference(widget.item.createdAt!) >
                const Duration(hours: 1)) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(widget.item.createdAt!.toFormat('HH:mm'),
                style: AppStyles.s10w4.withColor(AppColors.white)),
          ),
        ],
      ],
    );
  }
}

class MenuItemModel {
  String title;
  String icon;
  Function() onTap;

  MenuItemModel(
    this.title,
    this.icon,
    this.onTap,
  );
}
