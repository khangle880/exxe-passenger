import '../../../data/models/models.dart';
import '../../../utils/export/ui_export.dart';

class UserNameWidget extends StatefulWidget {
  const UserNameWidget({Key? key}) : super(key: key);

  @override
  State<UserNameWidget> createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends State<UserNameWidget> {
  late RemoveListener removeListener;

  @override
  void initState() {
    super.initState();
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction && state.action == ActionStateEnum.updateUserInfo) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    removeListener();
  }

  @override
  Widget build(BuildContext context) {
    final PartnerModel? userInfo = GetIt.I<AppState>().currentState.user;
    if (userInfo == null) return const SizedBox();
    return LayoutBuilder(builder: (context, constraint) {
      String name = (userInfo.partnerName ?? "");
      Size fullTextSize = name.getSize(AppStyles.s21w7);
      final listWord = name.split(" ");
      if (constraint.maxWidth < fullTextSize.width && listWord.length > 1) {
        name = listWord.reversed.take(2).toList().reversed.join(" ");
        Size fullTextSize = name.getSize(AppStyles.s21w7);

        if (constraint.maxWidth < fullTextSize.width) {
          listWord.last;
        }
      }

      return Text(
        name,
        style: AppStyles.s20w6,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    });
  }
}
