import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import '../../../utils/export/ui_export.dart';
import 'chat_fb_core/chat_fb_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BodyChatHome extends StatefulWidget {
  const BodyChatHome({Key? key}) : super(key: key);

  @override
  State<BodyChatHome> createState() => _BodyChatHomeState();
}

class _BodyChatHomeState extends State<BodyChatHome> {
  bool _error = false;
  bool _initialized = false;
  User? _user;

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Container();
    }

    if (!_initialized) {
      return Container();
    }

    return _user == null
        ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              bottom: 200,
            ),
            child: Text(
              'Chưa đăng nhập tài khoản',
              style: AppStyles.s15w5,
            ),
          )
        : StreamBuilder<List<types.Room>>(
            stream: FirebaseChatCore.instance.rooms(),
            initialData: const [],
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(
                    bottom: 200,
                  ),
                  child: Text(
                    'Chưa có cuộc hội thoại nào',
                    style: AppStyles.s16w6,
                  ),
                );
              }

              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final room = snapshot.data![index];
                  final lastMessage = room.lastMessages?.firstOrNull;

                  return Row(
                    children: [
                      _buildAvatar(room),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    room.name ?? "",
                                    style: AppStyles.s16w7,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  room.metadata?['dependId'] ?? "",
                                  style: AppStyles.s12w4
                                      .withColor(AppColors.gray70x76),
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (lastMessage != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Builder(builder: (context) {
                                    String content = "";
                                    if (lastMessage is types.TextMessage) {
                                      content = lastMessage.text;
                                      if (content.contains("maps/dir")) {
                                        content = "Vị trí";
                                      }
                                    } else if (lastMessage
                                        is types.ImageMessage) {
                                      content = "Hình ảnh";
                                    } else {
                                      content = "Tin nhắn mới";
                                    }
                                    return Text(
                                      content,
                                      style: AppStyles.s15w5
                                          .withColor(AppColors.gray70x76),
                                    );
                                  }),
                                  Text(
                                    DateTime.fromMillisecondsSinceEpoch(
                                            lastMessage.createdAt!)
                                        .toFormat('hh:mm a'),
                                    style: AppStyles.s12w4
                                        .withColor(AppColors.gray70x76),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      )
                    ],
                  ).inkWell(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(Routes.chatRoom, arguments: room);
                    },
                  );
                },
              );
            },
          );
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        _user = user;
        if (mounted) {
          setState(() {});
        }
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Widget _buildAvatar(types.Room room) {
    return CustomNetworkImage(
      url: room.imageUrl,
      size: 50,
      decoration: const BoxDecoration(
        color: AppColors.gray20,
        shape: BoxShape.circle,
      ),
    );
  }
}
