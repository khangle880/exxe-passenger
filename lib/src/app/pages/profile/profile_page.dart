import 'package:exxe/src/app/pages/profile/components/body_profile.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../common/widgets/available_money.dart';
import 'components/user_info_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, this.jumpToWallet});

  final Function()? jumpToWallet;

  @override
  Widget build(BuildContext context) {
    return HeaderStackWidget(
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
          child: AvailableMoneyWidget(
            backgroundColor: AppColors.primaryLightBlur,
            onTapWalletMoney: jumpToWallet,
          ),
        ),
      ],
      title: 'Cá nhân',
      centerTitle: false,
      autoGenarateIconLeading: false,
      child: const UserInfoCard(),
      children: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              BodyProfile(),
            ],
          ),
        ),
      ),
    );
  }
}
