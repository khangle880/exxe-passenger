import '../../../../data_chat/data_chat.dart';
import '../../../../utils/export/ui_export.dart';
import '../controllers/chat_room_cubit.dart';
import 'package:lottie/lottie.dart';

class RoomBottomBar extends StatefulWidget {
  const RoomBottomBar({Key? key}) : super(key: key);

  @override
  State<RoomBottomBar> createState() => _RoomBottomBarState();
}

class _RoomBottomBarState extends State<RoomBottomBar> {
  final DebounceHelper debounceHelper = DebounceHelper(milliseconds: 3000);
  late final RichTextController _controller;
  late final ChatRoomCubit cubit;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final userTagRegex = RegExp(r'@​.+​');
    cubit = context.read<ChatRoomCubit>();
    _controller = RichTextController(
      patternMatchMap: {
        //
        //* Returns every Mention with blue color and bold style.
        //
        userTagRegex: AppStyles.s14w4.withColor(AppColors.primaryMain),
      },
      onMatch: (List<String> matches) {
        // Do something with matches.
        //! P.S
        // as long as you're typing, the controller will keep updating the list.
      },
      deleteOnBack: true,
    );
    _controller.text = cubit.textStream.valueOrNull ?? "";

    cubit.replyStream.distinct((a, b) => false).listen((value) {
      if (value?.author?.authorName != null &&
          value?.author?.authorId != cubit.user.userId) {
        if (_controller.text.isNotEmpty && _controller.text[0] == "@") {
          _controller.text = _controller.text.replaceFirst(
              RegExp(r'@([​a-zA-Z0-9]+)|(​.+​)'),
              "@\u{200B}${value?.author?.authorName}\u{200B} ");
        } else {
          _controller.text =
              "@\u{200B}${value?.author?.authorName}\u{200B} ${_controller.text}";
        }
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
        cubit.textStream.add(_controller.text);
        FocusScope.of(context).requestFocus(focusNode);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: cubit.controller.bsIsLoading,
      builder: (context, snapshot) {
        return AbsorbPointer(
          absorbing: cubit.controller.isFirstLoad,
          child: Container(
            margin: MediaQuery.of(context).viewInsets,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<TypingUser>(
                  stream: cubit.typingStream.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.typing) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("${snapshot.data!.userName} ",
                                style: AppStyles.s12w4),
                            Lottie.asset(
                              width: 20,
                              height: 20,
                              'assets/lottie/three_dot_loading.json',
                              repeat: true,
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                _buildReplyTo(),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, -1),
                          blurRadius: 2,
                          color: const Color(0xFFDCDCDC).withOpacity(.1)),
                      BoxShadow(
                          offset: const Offset(0, -1),
                          blurRadius: 6,
                          color: const Color(0xFFDCDCDC).withOpacity(.3))
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    height: 44,
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTextField(),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            final assets =
                                await MediaPicker.multiImagePick(context, 9);
                            final files = await Future.wait(
                                assets.map((e) => e.originFile));
                            if (files.isEmpty) return;
                            final paths =
                                files.whereNotNull().map((e) => e.path);
                            cubit.createMessage(
                              filePaths: paths.toList(),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: AppColors.primaryMainBlur,
                            ),
                            child: SvgPicture.asset(
                              AppIcons.imagePicker,
                              height: 24,
                              width: 24,
                              color: AppColors.primaryMain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildSendButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildTextField() {
    return TextFormFieldBuilder.none(
      controller: _controller,
      focusNode: focusNode,
      onChanged: (value) {
        if (debounceHelper.timer == null || !debounceHelper.timer!.isActive) {
          cubit.startTyping();
        }
        debounceHelper.run(() {
          cubit.stopTyping();
        });
        cubit.textStream.add(value);
      },
      hintText: "Nhập tin nhắn",
      hintStyle: AppStyles.s14w4.copyWith(color: AppColors.gray50),
      style: AppStyles.s14w4,
      contentPadding: const EdgeInsets.all(12.0),
      textAlignVertical: TextAlignVertical.center,
    );
  }

  _buildSendButton() {
    return StreamBuilder<String>(
        stream: cubit.textStream.stream,
        builder: (context, snapshot) {
          final isNotEmpty = snapshot.hasData && snapshot.data!.isNotEmpty;
          return AnimatedContainer(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isNotEmpty ? AppColors.primaryMain : AppColors.gray10,
            ),
            duration: const Duration(milliseconds: 300),
            child: SvgPicture.asset(
              AppIcons.sent,
              height: 24,
              width: 24,
              color: AppColors.primaryLight,
            ),
          ).inkWell(
            onTap: () {
              cubit.createMessage();
              _controller.text = "";
              cubit.textStream.add("");
              setState(() {});
            },
          );
        });
  }

  _buildReplyTo() {
    return StreamBuilder<ReplyToModel?>(
        stream: cubit.replyStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final message = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.primaryLightBlur,
              ),
              margin: const EdgeInsets.only(bottom: 4),
              height: 60,
              child: Row(
                children: [
                  const SizedBox(width: 4),
                  Container(
                    height: double.maxFinite,
                    width: 2,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    color: AppColors.primaryMain,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.author?.authorName ?? "",
                            style: AppStyles.s14w6,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            message.messageText ?? "",
                            style:
                                AppStyles.s14w4.withColor(AppColors.gray70x76),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      cubit.replyStream.add(null);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AppIcons.close,
                          height: 24, width: 24),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}
