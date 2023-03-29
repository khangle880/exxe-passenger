import 'package:exxe/src/utils/export/ui_export.dart';

class BottomNavigatorWidget extends StatelessWidget {
  const BottomNavigatorWidget({
    Key? key,
    required this.onClick,
    required this.currentIndexPage,
  }) : super(key: key);
  final Function(int)? onClick;
  final int currentIndexPage;

  Widget _buildBottomNavItem({
    required String label,
    required String iconUrl,
    required int index,
    required Function() onTap,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          iconUrl,
          width: 25,
          height: 25,
          color: index == currentIndexPage
              ? AppColors.primaryTextButton
              : AppColors.gray95x06,
          fit: BoxFit.fill,
        ),
        const SizedBox(height: 6.0),
        TextWidget(
          text: label,
          fontSize: AppDimens.text12,
          weight: FontWeight.w400,
          colorText: index == currentIndexPage
              ? AppColors.primaryTextButton
              : AppColors.gray70x76,
        )
      ],
    ).inkWell(
      decoration: const ShapeDecoration(
        color: AppColors.primaryLight,
        shape: CircleBorder(),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppStyles.borderTop20LeftRight,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray70x76.withAlpha(50),
            blurRadius: 10.0,
            offset: const Offset(0, 0.0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _buildBottomNavItem(
              label: "ExxeVn",
              iconUrl: AppIcons.logoBottom,
              index: 0,
              onTap: () => currentIndexPage == 0 ? null : onClick!(0),
            ),
          ),
          Expanded(
            child: _buildBottomNavItem(
              label: "Chuyến đi",
              iconUrl: AppIcons.myRide,
              index: 1,
              onTap: () => currentIndexPage == 1 ? null : onClick!(1),
            ),
          ),
          Expanded(
            child: _buildBottomNavItem(
              label: "Tài khoản",
              iconUrl: AppIcons.walletDolar,
              index: 2,
              onTap: () => currentIndexPage == 2 ? null : onClick!(2),
            ),
          ),
          Expanded(
            child: _buildBottomNavItem(
              label: "Tin nhắn",
              iconUrl: AppIcons.message,
              index: 3,
              onTap: () => currentIndexPage == 3 ? null : onClick!(3),
            ),
          ),
          Expanded(
            child: _buildBottomNavItem(
              label: "Cá nhân",
              iconUrl: AppIcons.user,
              index: 4,
              onTap: () => currentIndexPage == 4 ? null : onClick!(4),
            ),
          ),
        ],
      ),
    );
  }
}
