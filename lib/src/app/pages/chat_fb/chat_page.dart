import '../../../utils/export/ui_export.dart';
import 'body_chat_home.dart';
import 'users.dart';

class ChatRoomsPage extends StatelessWidget {
  const ChatRoomsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      appBar: CustomAppBarWidget(
        centerTitle: false,
        autoGeneraIconLeading: false,
        title: 'Tin nhắn',
        fontSizeTitle: 24,
        context: context,
        backgroundColor:
            AppColors.primaryMain + AppColors.primaryLight.withOpacity(0.95),
        //TODO: only for agent
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const UsersPage(),
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryMain +
                  AppColors.primaryLight.withOpacity(0.95),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Hộp thư đến",
                style: AppStyles.s16w7.withColor(AppColors.black),
              ),
            ),
          ),
          const Expanded(child: BodyChatHome()),
        ],
      ),
    );
  }
}
