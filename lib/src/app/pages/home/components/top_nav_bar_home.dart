import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../data/repositories/interfaces/notification_repo_interface.dart';
import '../../../common/widgets/available_money.dart';

class TopNavBarHome extends StatefulWidget {
  const TopNavBarHome({
    Key? key,
    required this.jumpToWallet,
  }) : super(key: key);
  final Function() jumpToWallet;

  @override
  State<TopNavBarHome> createState() => _TopNavBarHomeState();
}

class _TopNavBarHomeState extends State<TopNavBarHome> {
  late RemoveListener removeListener;
  late final INotificationRepo repo;

  @override
  void initState() {
    super.initState();
    removeListener = GetIt.I.get<AppState>().addListener((state) {
      if (state.isNewAction &&
          (state.action == ActionStateEnum.updateUserInfo ||
              state.action == ActionStateEnum.updateNotificationCount)) {
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
    final userInfo = GetIt.I.get<AppState>().currentState.user;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: LayoutBuilder(builder: (context, constraint) {
            String name = (userInfo?.partnerName ?? "");
            Size fullTextSize = name.getSize(AppStyles.s21w7);
            final listWord = name.split(" ");
            if (constraint.maxWidth < fullTextSize.width &&
                listWord.length > 1) {
              name = listWord.reversed.take(2).toList().reversed.join(" ");
              Size fullTextSize = name.getSize(AppStyles.s21w7);

              if (constraint.maxWidth < fullTextSize.width) {
                listWord.last;
              }
            }

            return Text(
              name,
              style: AppStyles.s21w7,
              overflow: TextOverflow.ellipsis,
            );
          }),
        ),
        _buildTopRight(context),
      ],
    );
  }

  Row _buildTopRight(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              "assets/icons/notification.svg",
              color: AppColors.black,
              height: 28,
              width: 28,
            ),
            GetIt.I<AppState>().currentState.notificationCount > 0
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 6,
                      width: 6,
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                        color: AppColors.textError,
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        )
            .padding(
              padding: const EdgeInsets.all(15.0),
            )
            .inkWell(
              onTap: () => Navigator.pushNamed(context, '/home/notification'),
            ),
        AvailableMoneyWidget(
          onTapWalletMoney: widget.jumpToWallet,
        ),
      ],
    );
  }
}
