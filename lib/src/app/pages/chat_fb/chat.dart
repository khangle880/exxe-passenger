import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/export/ui_export.dart';
import 'chat_fb_core/firebase_chat_core.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
  });

  final types.Room room;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;

  @override
  void initState() {
    GetIt.I<AppState>().currentChatRoomId = widget.room.id;
    super.initState();
  }

  @override
  void dispose() {
    GetIt.I<AppState>().currentChatRoomId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = widget.room.users.firstWhereOrNull(
      (u) => u.id != FirebaseChatCore.instance.firebaseUser?.uid,
    );
    final phone = otherUser?.metadata?['phone'];
    final dependId = widget.room.metadata?['dependId'];

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(AppIcons.chevronLeft,
                  color: AppColors.primaryMain)
              .inkWell(
            padding: const EdgeInsets.all(4),
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, Routes.home);
              }
            },
          ),
        ),
        titleSpacing: 0.0,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _buildHeader(widget.room),
        ),
        elevation: .5,
        backgroundColor: AppColors.primaryLight,
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (phone != null && dependId != null)
                InviteVoiceButton(
                  phone: phone,
                  name: otherUser?.firstName ?? "",
                  compoundingCarCustomerCode: dependId,
                ),
              const SizedBox(width: 16),
            ],
          )
        ],
      ),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(widget.room.id),
        builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
          initialData: const [],
          stream: FirebaseChatCore.instance.messages(snapshot.data!),
          builder: (context, snapshot) {
            return Chat(
              theme: const DefaultChatTheme(
                inputBackgroundColor: AppColors.gray10,
                inputTextColor: AppColors.gray60x9d,
                primaryColor: AppColors.primaryMain,
                messageInsetsHorizontal: 16,
                messageInsetsVertical: 12,
              ),
              isAttachmentUploading: _isAttachmentUploading,
              messages: snapshot.data ?? [],
              onAttachmentPressed: _handleAttachmentPressed,
              onMessageTap: _handleMessageTap,
              onPreviewDataFetched: _handlePreviewDataFetched,
              onSendPressed: _handleSendPressed,
              user: types.User(
                id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
              ),
            );
          },
        ),
      ),
    );
  }

  _buildHeader(types.Room room) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          CustomNetworkImage(
            url: room.imageUrl,
            size: 50,
            decoration: const BoxDecoration(
              color: AppColors.gray20,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Builder(builder: (context) {
              final dependId = room.metadata?['dependId'];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(room.name ?? "", style: AppStyles.s18w7),
                  if (dependId != null)
                    Text(
                      "#$dependId",
                      style:
                          AppStyles.s14w4.copyWith(color: AppColors.gray70x76),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => Row(
        children: [
          SizedBox(
            height: 150,
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryLight,
                  ),
                  child: Text(
                    'Ảnh',
                    style: AppStyles.s16w6.withColor(AppColors.primaryMain),
                  ),
                ).inkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryLight,
                  ),
                  child: Text(
                    'Vị trí',
                    style: AppStyles.s16w6.withColor(AppColors.primaryMain),
                  ),
                ).inkWell(
                  onTap: () {
                    Navigator.pop(context);

                    GetIt.I<LocationHelper>().handleLocation(
                      context,
                      callBack: () {
                        final location =
                            GetIt.I<AppState>().currentState.currentLocation;
                        final message = types.PartialText(
                          text:
                              'https://www.google.com/maps/dir/?api=1&destination=${location!.coordinate!.latitude},${location.coordinate!.longitude}&travelmode=driving&dir_action=navigate',
                        );
                        FirebaseChatCore.instance.sendMessage(
                          message,
                          widget.room,
                        );
                      },
                    );
                  },
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryLight,
                  ),
                  child: Text(
                    'Đóng',
                    style: AppStyles.s16w6.withColor(AppColors.primaryMain),
                  ),
                ).inkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      // await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}
