import 'package:exxe/src/app/pages/profile/components/services_our.dart';
import 'package:exxe/src/app/pages/profile/components/settings_profile.dart';
import 'package:exxe/src/utils/export/ui_export.dart';

import '../../../../controllers/token/token_cubit.dart';

class BodyProfile extends StatelessWidget {
  const BodyProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SettingsProfile(),
        const SizedBox(height: 12),
        const ServicesOurProfile(),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          width: double.maxFinite,
          child: ButtonWidget(
            onClick: () {
              AppDialog.I.showConfirmLogOutDialog(
                onConfirm: () {
                  AppDialog.I.closeDialog();
                  context.read<TokenCubit>().logOut();
                },
              );
            },
            backgroundColor: AppColors.primaryMain,
            child: Text(
              'Đăng xuất',
              style: AppStyles.s16w6.withColor(AppColors.primaryLight),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
