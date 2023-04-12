import '../../../../data_chat/data_chat.dart';
import '../../../../utils/export/ui_export.dart';
import '../controllers/chat_room_cubit.dart';

class ChatContent extends StatefulWidget {
  const ChatContent(
      {Key? key,
      required this.cubit,
      required this.item,
      this.nearer,
      this.old})
      : super(key: key);
  final ChatRoomCubit cubit;
  final ChatMessageModel item;
  final ChatMessageModel? nearer;
  final ChatMessageModel? old;

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  final widgetKey = GlobalKey();
  final userTagRegex = RegExp(r'@​.+​');
  late final Map<RegExp, TextStyle>? patternMatchMap;

  @override
  void initState() {
    super.initState();
    patternMatchMap = {
      userTagRegex: AppStyles.s14w4.withColor(AppColors.primaryMain),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.item.replyTo != null) _buildReply(),
        RichText(
          text: RegexTextSpanBuilder.buildTextSpan(
            style: AppStyles.s14w4,
            text: widget.item.messageText!,
            patternMatchMap: patternMatchMap,
          ),
        ),
        if (widget.nearer == null ||
            widget.nearer!.author?.authorId != widget.item.author?.authorId ||
            widget.nearer!.createdAt!.difference(widget.item.createdAt!) >
                const Duration(hours: 1)) ...[
          const SizedBox(height: 4),
          Text(widget.item.createdAt!.toFormat('HH:mm'),
              style: AppStyles.s10w4.withColor(AppColors.gray70x76))
        ],
      ],
    );
  }

  _buildReply() {
    final patternMatchMap = {
      userTagRegex: AppStyles.s14w4.withColor(AppColors.primaryMain),
    };
    final size = MediaQuery.of(context).size;
    final replyTo = widget.item.replyTo!;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.item.isAuthor ?? false
            ? AppColors.primaryMain + AppColors.primaryLight.withOpacity(.7)
            : AppColors.gray10,
      ),
      constraints: BoxConstraints(
          minWidth: size.width * 0.3, maxWidth: size.width * 0.8),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(right: 12),
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 4),
          Container(
            height: double.maxFinite,
            width: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            color: AppColors.primaryMain,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                replyTo.author?.authorName ?? "",
                style: AppStyles.s14w6,
                overflow: TextOverflow.ellipsis,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: size.width * 0.65),
                child: RichText(
                  text: RegexTextSpanBuilder.buildTextSpan(
                    style: AppStyles.s14w4.withColor(AppColors.gray70x76),
                    text: replyTo.messageText ?? "",
                    patternMatchMap: patternMatchMap,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
